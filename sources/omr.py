"""Aide à la transcription : extrait notes / silences / barres d'un PDF vectoriel de partition.
usage: python omr.py fichier.pdf page [clefs]   (clefs ex: "GF" ou "GGgF" ; g = sol octavié)
"""
import sys, fitz, collections

SMUFL = {
    0xE0A4: ('head', 4), 0xE0A3: ('head', 2), 0xE0A2: ('head', 1),
    0xE1E7: ('dot', 0), 0xE262: ('acc', '#'), 0xE260: ('acc', 'b'), 0xE261: ('acc', 'n'),
    0xE240: ('flag', 1), 0xE241: ('flag', 1), 0xE242: ('flag', 2), 0xE243: ('flag', 2),
    0xE4E3: ('rest', 1), 0xE4E4: ('rest', 2), 0xE4E5: ('rest', 4), 0xE4E6: ('rest', 8), 0xE4E7: ('rest', 16),
    0xE050: ('clef', 'G'), 0xE062: ('clef', 'F'), 0xE052: ('clef', 'g'), 0xE4C0: ('ferm', 0),
}
MAESTRO = {
    0x153: ('head', 4), 0x2D9: ('head', 2), 0x77: ('head', 1), 0x2E: ('dot', 0),
    0x23: ('acc', '#'), 0x62: ('acc', 'b'), 0x6E: ('acc', 'n'),
    0x6A: ('flag', 1), 0x4A: ('flag', 1), 0x152: ('rest', 4), 0x2030: ('rest', 8),
    0x2211: ('rest', 1), 0xD3: ('rest', 2), 0x2248: ('rest', 16),
    0x26: ('clef', 'G'), 0x3F: ('clef', 'F'), 0x56: ('clef', 'g'), 0x55: ('ferm', 0),
}
# MuseScore 2 (police « MScoreRegular », codes privés)
MSCORE2 = {
    0xE12D: ('head', 4), 0xE12C: ('head', 2), 0xE12B: ('head', 1), 0xE127: ('dot', 0),
    0xE114: ('acc', 'b'), 0xE11D: ('acc', 'n'), 0xE11E: ('acc', '#'),
    0xE19E: ('clef', 'G'), 0xE19C: ('clef', 'F'),
}
FONTS = {'MScoreRegular': MSCORE2, 'MScore': SMUFL, 'Leland': SMUFL, 'Maestro': MAESTRO, 'Petrucci': MAESTRO}
MUSIC_FONTS = set(FONTS) | {'MScoreText', 'MScoreTextRegular', 'BravuraText'}
NAMES = 'CDEFGAB'


def load(path, pno, petrucci_map=None):
    doc = fitz.open(path)
    page = doc[pno]
    hs, vs, fills = [], [], []
    for d in page.get_drawings():
        for it in d['items']:
            if it[0] == 'l':
                a, b = it[1], it[2]
                if abs(a.y - b.y) < 0.3 and abs(a.x - b.x) > 2:
                    hs.append((min(a.x, b.x), max(a.x, b.x), (a.y + b.y) / 2))
                elif abs(a.x - b.x) < 0.3 and abs(a.y - b.y) > 2:
                    vs.append(((a.x + b.x) / 2, min(a.y, b.y), max(a.y, b.y)))
            elif it[0] == 're':
                r = it[1]
                if r.width < 1.5 and r.height > 2:
                    vs.append((r.x0 + r.width / 2, r.y0, r.y1))
                elif r.height < 1.5 and r.width > 2:
                    hs.append((r.x0, r.x1, r.y0 + r.height / 2))
        if d['type'] in ('f', 'fs'):
            r = d['rect']
            kinds = ''.join(i[0] for i in d['items'])
            if 'c' not in kinds and r.width > 3:
                fills.append(r)
    glyphs, texts = [], []
    for b in page.get_text('rawdict')['blocks']:
        for l in b.get('lines', []):
            for s in l['spans']:
                f = s['font'].split('+')[-1]
                if f in FONTS:
                    m = FONTS[f] if f != 'Petrucci' else (petrucci_map or {})
                    for ch in s['chars']:
                        code = ord(ch['c'])
                        bb = fitz.Rect(ch['bbox'])
                        if code in m:
                            glyphs.append((m[code], bb, ch['origin']))
                        elif code != 0x20:
                            glyphs.append((('?', hex(code)), bb, ch['origin']))
                elif f not in MUSIC_FONTS:
                    txt = ''.join(c['c'] for c in s['chars'])
                    if txt.strip():
                        texts.append((s['bbox'], txt, f, round(s['size'], 1)))
    return page, hs, vs, fills, glyphs, texts


def staves(hs):
    long = sorted([h for h in hs if h[1] - h[0] > 60], key=lambda h: h[2])
    # fusionne les segments à même y
    rows = []
    for h in long:
        if rows and abs(rows[-1][2] - h[2]) < 0.4 and h[0] <= rows[-1][1] + 5:
            rows[-1] = (min(rows[-1][0], h[0]), max(rows[-1][1], h[1]), rows[-1][2])
        elif rows and abs(rows[-1][2] - h[2]) < 0.4:
            rows[-1] = (min(rows[-1][0], h[0]), max(rows[-1][1], h[1]), rows[-1][2])
        else:
            rows.append(h)
    out = []
    i = 0
    while i + 4 < len(rows):
        grp = rows[i:i + 5]
        gaps = [grp[k + 1][2] - grp[k][2] for k in range(4)]
        if max(gaps) - min(gaps) < 0.6 and 3 < gaps[0] < 12:
            out.append({'top': grp[0][2], 'bot': grp[4][2], 'sp': sum(gaps) / 4,
                        'x0': min(g[0] for g in grp), 'x1': max(g[1] for g in grp)})
            i += 5
        else:
            i += 1
    return out


def pitch(st, y, clef):
    step = round((st['bot'] - y) / (st['sp'] / 2))  # 0 = ligne du bas
    base = {'G': 2 + 4 * 7, 'g': 2 + 3 * 7, 'F': 4 + 2 * 7}[clef]  # E4 / E3 / G2
    idx = base + step
    return NAMES[idx % 7] + str(idx // 7)


def analyse(path, pno, clefs, petrucci_map=None, show_text=True):
    page, hs, vs, fills, glyphs, texts = load(path, pno, petrucci_map)
    sts = staves(hs)
    for k, st in enumerate(sts):
        st['clef'] = clefs[k % len(clefs)]
        st['idx'] = k
    def staff_of(y):
        best = None
        for st in sts:
            if st['top'] - 4 * st['sp'] <= y <= st['bot'] + 4 * st['sp']:
                d = 0 if st['top'] <= y <= st['bot'] else min(abs(y - st['top']), abs(y - st['bot']))
                if best is None or d < best[0]:
                    best = (d, st)
        return best[1] if best else None
    # barres : verticales couvrant toute la portée
    bars = collections.defaultdict(list)
    for x, y0, y1 in vs:
        for st in sts:
            if y0 <= st['top'] + 0.5 and y1 >= st['bot'] - 0.5 and (y1 - y0) < 40 * st['sp']:
                # exclure les hampes (une hampe touche une tête) : test plus bas
                bars[st['idx']].append(x)
    heads = [(g, bb) for g, bb, o in glyphs if g[0] == 'head']
    def near_head(x, y0, y1):
        for g, bb in heads:
            if (abs(bb.x0 - x) < 1.2 or abs(bb.x1 - x) < 1.2) and y0 - 2 <= (bb.y0 + bb.y1) / 2 <= y1 + 2:
                return True
        return False
    for k in bars:
        xs = sorted(set(round(x, 1) for x in bars[k]))
        st = sts[k]
        xs = [x for x in xs if not any(abs(x - v[0]) < 0.3 and near_head(v[0], v[1], v[2]) for v in vs if abs(v[0] - x) < 0.3)]
        merged = []
        for x in xs:
            if merged and x - merged[-1] < 4:
                merged[-1] = x
            else:
                merged.append(x)
        bars[k] = merged
    # événements
    ev = collections.defaultdict(list)
    for g, bb, o in glyphs:
        cx, cy = (bb.x0 + bb.x1) / 2, (bb.y0 + bb.y1) / 2
        if g[0] == 'head':
            # centre vertical réel de la tête : origine du glyphe (baseline) pour SMuFL/Maestro
            cy = o[1]
            st = staff_of(cy)
            if not st:
                continue
            sp = st['sp']
            stem = None
            for x, y0, y1 in vs:
                if (abs(x - bb.x0) < 1.0 or abs(x - bb.x1) < 1.0) and y0 - 1 <= cy <= y1 + 1 and (y1 - y0) > 2 * sp and (y1 - y0) < 6 * sp:
                    up = (cy - y0) > (y1 - cy)
                    stem = (x, y0, y1, up)
                    break
            ev[st['idx']].append({'x': bb.x0, 'kind': 'n', 'p': pitch(st, cy, st['clef']), 'dur': g[1], 'stem': stem, 'y': cy, 'w': bb.width})
        elif g[0] in ('rest', 'dot', 'acc', 'flag', 'ferm', '?'):
            st = staff_of(cy if g[0] != 'ferm' else cy + 10)
            if st:
                ev[st['idx']].append({'x': bb.x0, 'kind': g[0], 'v': g[1], 'y': cy, 'p': pitch(st, cy, st['clef']) if g[0] in ('acc', 'dot') else ''})
    # beams : nombre de poutres traversant l'extrémité de hampe
    for k, lst in ev.items():
        st = sts[k]
        for e in lst:
            if e['kind'] == 'n' and e['stem']:
                x, y0, y1, up = e['stem']
                end = y0 if up else y1
                n = 0
                for r in fills:
                    if r.x0 - 1 <= x <= r.x1 + 1 and abs(((r.y0 + r.y1) / 2) - end) < 2.2 * st['sp'] and r.height < 3.5 * st['sp']:
                        n += 1
                e['beams'] = n
    # sortie
    for st in sts:
        k = st['idx']
        lst = sorted(ev[k], key=lambda e: e['x'])
        bl = bars.get(k, [])
        print(f"\n=== portée {k} clef {st['clef']} y={st['top']:.0f} sp={st['sp']:.2f} barres={len(bl)}")
        meas = 0
        bi = 0
        line = []
        # regroupe les têtes en accords par x (même hampe)
        groups = []
        for e in lst:
            if groups and e['kind'] == 'n' and groups[-1][0]['kind'] == 'n' and abs(groups[-1][0]['x'] - e['x']) < 2.5 * st['sp'] * 0.6:
                groups[-1].append(e)
            else:
                groups.append([e])
        for gp in groups:
            x = gp[0]['x']
            while bi < len(bl) and bl[bi] < x:
                print(f"  | {' '.join(line)}")
                line = []
                bi += 1
            e = gp[0]
            if e['kind'] == 'n':
                parts = []
                for n in sorted(gp, key=lambda n: -n['y']):
                    d = n['dur']
                    if d == 4 and n['stem']:
                        d = 4 * 2 ** n.get('beams', 0)
                    st_ = ('^' if n['stem'][3] else 'v') if n['stem'] else '-'
                    parts.append(f"{n['p']}:{d}{st_}")
                line.append('[' + ' '.join(parts) + ']')
            elif e['kind'] == 'rest':
                line.append(f"r{e['v']}")
            elif e['kind'] == 'dot':
                line.append('.')
            elif e['kind'] == 'acc':
                line.append(f"{e['v']}({e['p']})")
            elif e['kind'] == 'flag':
                line.append(f"flag{e['v']}")
            elif e['kind'] == 'ferm':
                line.append('FERM')
            else:
                line.append(f"?{e['v']}")
        print(f"  | {' '.join(line)}")
    if show_text:
        print('\n=== texte')
        rows = collections.defaultdict(list)
        for bb, t, f, s in texts:
            rows[round(bb[1] / 3)].append((bb[0], t, f[:12], s))
        for r in sorted(rows):
            items = sorted(rows[r])
            print(f"y={r * 3:4d} " + ' · '.join(f"{t}" for x, t, f, s in items))


if __name__ == '__main__':
    path, pno = sys.argv[1], int(sys.argv[2])
    clefs = sys.argv[3] if len(sys.argv) > 3 else 'GF'
    analyse(path, pno, clefs)
