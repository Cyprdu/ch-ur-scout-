"""Génère lion.ly à partir de Lion/Le-lion.json (notes) et du PDF d'origine (paroles, accords)."""
import json, os, sys, collections, re
from fractions import Fraction as F
import fitz

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import omr

data = json.load(open(os.path.join(ROOT, 'Lion', 'Le-lion.json'), encoding='utf-8'))
pdf = fitz.open(os.path.join(ROOT, 'partitions', 'LE_LION.pdf'))
PW, PH = 595.0, 842.0
NM = len(data['measures'])

# ---------- systèmes ----------
sys_meas = collections.defaultdict(list)
for m in data['measures']:
    sys_meas[m['system']].append(m['index'])
sys_page = {m['system']: m['page'] for m in data['measures']}
sys_parts = collections.defaultdict(set)
meas_sys = {m['index']: m['system'] for m in data['measures']}
for p, notes in data['voices'].items():
    for n in notes:
        sys_parts[meas_sys[n['measure']]].add(int(p.split()[-1]))
sys_count = {s: (5 if 5 in sys_parts[s] else 4) for s in sys_meas}
ORDER4, ORDER5 = ['S', 'A', 'T', 'B'], ['Solo', 'S', 'A', 'T', 'B']
def voice_of(part_no, s):
    return (ORDER5 if sys_count[s] == 5 else ORDER4)[part_no - 1]

# ---------- notes par voix ----------
VOICES = ['Solo', 'S', 'A', 'T', 'B']
notes = {v: [] for v in VOICES}
for p, lst in data['voices'].items():
    pn = int(p.split()[-1])
    for n in lst:
        s = meas_sys[n['measure']]
        v = voice_of(pn, s)
        name = n['name']
        m = re.match(r'([A-G])([#b]?)(\d)', name)
        letter, acc, octv = m.group(1), m.group(2), int(m.group(3))
        if v == 'T':
            octv -= 1  # clé de sol octaviée
        cx = (n['bbox'][0] + n['bbox'][2]) / 2 * PW
        notes[v].append(dict(m=n['measure'], on=F(n['onset_whole']), d=F(n['duration_whole']),
                             letter=letter, acc=acc, oct=octv, tie=n['tied_from_previous'],
                             page=n['page'], x=cx, sys=s, syl=None))
for v in VOICES:
    notes[v].sort(key=lambda n: (n['m'], n['on'], n['oct'], n['letter']))

def lily_pitch(n):
    p = n['letter'].lower() + {'#': 'is', 'b': 'es', '': ''}[n['acc']]
    o = n['oct'] - 3
    return p + ("'" * o if o > 0 else ',' * (-o))

DUR = {F(1): '1', F(3, 4): '2.', F(1, 2): '2', F(3, 8): '4.', F(1, 4): '4', F(3, 16): '8.', F(1, 8): '8', F(1, 16): '16', F(7, 8): '2..'}
def split_rest(gap, pos):
    out = []
    while gap > 0:
        for dv in (F(1), F(1, 2), F(1, 4), F(1, 8), F(1, 16)):
            if dv <= gap and (pos % dv == 0):
                out.append('r' + DUR[dv]); gap -= dv; pos += dv; break
        else:
            raise ValueError(gap)
    return out

# ---------- paroles ----------
def page_staves(pi):
    page, hs, vs, fills, glyphs, texts = omr.load(pdf.name, pi)
    return omr.staves(hs), texts

# tokens par (voix, ligne) -> {index de note: (syllabe, trait d'union)}
lyr = collections.defaultdict(dict)
chords = []  # (t, texte)
for page_no in sorted(set(sys_page.values())):
    pi = page_no - 1
    sts, _ = page_staves(pi)
    sts.sort(key=lambda s: s['top'])
    systems = sorted([s for s in sys_meas if sys_page[s] == page_no])
    # textes de la page
    spans = []
    for b in pdf[pi].get_text('dict')['blocks']:
        for l in b.get('lines', []):
            for sp in l['spans']:
                if not sp['text'].strip():
                    continue
                x0, y0, x1, y1 = sp['bbox']
                if x0 < 60:
                    continue
                t = sp['text'].strip()
                if sp['font'].startswith('Maestro'):
                    # altérations des noms d'accords (police musicale)
                    if t not in ('b', '#'):
                        continue
                    t = {'b': '♭', '#': '♯'}[t]
                    spans.append(dict(x0=x0, x1=x1, y=(y0 + y1) / 2, t=t, size=0, font='acc'))
                    continue
                spans.append(dict(x0=x0, x1=x1, y=(y0 + y1) / 2, t=t, size=sp['size'], font=sp['font']))
    k = 0
    for s in systems:
        cnt = sys_count[s]
        group = sts[k:k + cnt]
        k += cnt
        order = ORDER5 if cnt == 5 else ORDER4
        # accords : au-dessus de la 1re portée
        top = group[0]['top']
        cs = [sp for sp in spans if top - 24 < sp['y'] < top - 2 and sp['t'] not in ('1', '2')
              and len(sp['t']) <= 4 and ' ' not in sp['t']]
        cs.sort(key=lambda sp: sp['x0'])
        merged = []
        for sp in cs:
            if merged and sp['x0'] - merged[-1]['x1'] < 1.5:
                merged[-1]['t'] += sp['t']; merged[-1]['x1'] = sp['x1']
            else:
                merged.append(dict(sp))
        ph = [p for p in data['playhead'] if p['page'] == page_no and p['system'] == s]
        for c in merged:
            # temps par interpolation x -> t
            pts = sorted((p['x'] * PW, F(p['t'])) for p in ph)
            x = c['x0'] + 2
            t = pts[0][1]
            for (xa, ta), (xb, tb) in zip(pts, pts[1:]):
                if xa <= x <= xb:
                    t = ta if (x - xa) < (xb - x) else tb
                    break
                if x > xb:
                    t = tb
            chords.append((t, c['t']))
        # paroles : sous chaque portée
        for i, st in enumerate(group):
            v = order[i]
            lo = st['bot'] + 1
            hi = group[i + 1]['top'] - 1 if i + 1 < cnt else st['bot'] + 45
            ls = [sp for sp in spans if lo < sp['y'] < hi and sp['size'] > 7]
            rows = []
            for sp in sorted(ls, key=lambda sp: sp['y']):
                if rows and abs(rows[-1][0] - sp['y']) < 3:
                    rows[-1][1].append(sp)
                else:
                    rows.append([sp['y'], [sp]])
            vnotes = [(j, n) for j, n in enumerate(notes[v]) if n['sys'] == s]
            for r, (_, row) in enumerate(rows):
                row.sort(key=lambda sp: sp['x0'])
                for q, sp in enumerate(row):
                    if sp['t'] in ('-', '_'):
                        continue
                    cx = (sp['x0'] + sp['x1']) / 2
                    cand = [(abs(n['x'] - cx), j) for j, n in vnotes if not n['tie']]
                    if not cand:
                        continue
                    dist, j = min(cand)
                    hyph = q + 1 < len(row) and row[q + 1]['t'] == '-'
                    if j in lyr[(v, r)]:
                        print('collision', v, r, sp['t'], lyr[(v, r)][j], file=sys.stderr)
                    lyr[(v, r)][j] = (sp['t'], hyph)

# ---------- écriture LilyPond ----------
def voice_music(v):
    out = []
    byM = collections.defaultdict(list)
    for j, n in enumerate(notes[v]):
        byM[n['m']].append((j, n))
    for mi in range(NM):
        evs = byM.get(mi, [])
        bar = []
        if not evs:
            bar = ['R1']
        else:
            pos = F(0)
            # regroupe les accords (même attaque)
            groups = collections.OrderedDict()
            for j, n in evs:
                groups.setdefault(n['on'], []).append((j, n))
            onsets = list(groups)
            for gi, on in enumerate(onsets):
                g = groups[on]
                if on > pos:
                    bar += split_rest(on - pos, pos)
                    pos = on
                d = min(n['d'] for _, n in g)
                if gi + 1 < len(onsets):
                    d = min(d, onsets[gi + 1] - on)
                ds = DUR.get(d)
                if ds is None:
                    raise ValueError((v, mi, on, d))
                # liaison vers la note suivante ?
                tie_next = False
                for j, n in g:
                    if j + 1 < len(notes[v]) and notes[v][j + 1]['tie']:
                        tie_next = True
                pitches = sorted(set(lily_pitch(n) for _, n in g), key=lambda p: p)
                txt = pitches[0] if len(pitches) == 1 else '<' + ' '.join(pitches) + '>'
                bar.append(txt + ds + ('~' if tie_next else ''))
                pos = on + d
            if pos < 1:
                bar += split_rest(1 - pos, pos)
        out.append(bar)
    return out

def lyric_line(v, r):
    toks = []
    seen = set()
    for j, n in enumerate(notes[v]):
        key = (n['m'], n['on'])
        if key in seen:
            continue  # accord : une seule syllabe
        seen.add(key)
        if j in lyr[(v, r)]:
            t, h = lyr[(v, r)][j]
            t = t.replace('"', '\\"')
            toks.append(f'"{t}"' + (' --' if h else ''))
        else:
            toks.append('_')
    # extenseurs : syllabe sans trait suivie de silences de mélisme
    return toks

music = {v: voice_music(v) for v in VOICES}

def wrap(v):
    bars = music[v]
    s = []
    for i, b in enumerate(bars):
        line = ' '.join(b)
        if i == 10:
            s.append('\\repeat volta 2 {')
        s.append('  ' + line + ' |')
        if i == 30:
            s.append('  \\alternative {')
        if i == 31:
            s[-1] = '    { ' + line + ' }'
        if i == 32:
            s[-1] = '    { ' + line + ' }\n  }\n}'
    return '\n'.join(s)

# accords
chords.sort()
ch_out = []
pos = F(0)
for t, txt in chords:
    if t < pos:
        continue
    if t > pos:
        ch_out.append(f's1*{t - pos}' if (t - pos).denominator == 1 else f's4*{(t - pos) * 4}')
    pos = t
    ch_out.append(f'\\ch "{txt}" 4')
    pos += F(1, 4)
if pos < NM:
    ch_out.append(f's4*{(NM - pos) * 4}')

nrows = {v: max([r + 1 for (vv, r) in lyr if vv == v] or [0]) for v in VOICES}
with open(os.path.join(HERE, 'lion_music.ily'), 'w', encoding='utf-8') as f:
    for v in VOICES:
        name = {'Solo': 'solo', 'S': 'sop', 'A': 'alto', 'T': 'tenor', 'B': 'basse'}[v]
        f.write(f'{name}Music = {{\n{wrap(v)}\n}}\n\n')
        for r in range(nrows[v]):
            f.write(f'{name}Lyr{"AB"[r]} = \\lyricmode {{\n  ' + ' '.join(lyric_line(v, r)) + '\n}\n\n')
    f.write('accords = { ' + ' '.join(ch_out) + ' }\n')
print('lignes de paroles :', nrows)
print('accords :', len(chords))
