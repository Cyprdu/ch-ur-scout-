"""Construit le site : PDF + SVG d'affichage + positions des notes + données JS pour chaque chant.

usage : python build.py [id ...]      (sans argument : tous les chants)
"""
import html, json, os, re, shutil, subprocess, sys, glob
from urllib.parse import unquote
import fitz  # PyMuPDF

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SITE = os.path.join(ROOT, 'site') if os.path.isdir(os.path.join(ROOT, 'site')) else ROOT
TMP = os.path.join(ROOT, 'build', 'web')
LILYPOND = os.environ.get('LILYPOND') or shutil.which('lilypond') or \
    os.path.join(os.environ.get('LOCALAPPDATA', ''), 'lilypond-2.24.4', 'bin', 'lilypond.exe')


def run(args, annotate=False, mel_file=None):
    env = dict(os.environ, CHORALE_ANNOTATE='1') if annotate else {k: v for k, v in os.environ.items() if k != 'CHORALE_ANNOTATE'}
    env.pop('CHORALE_MEL_FILE', None)
    if mel_file:
        env['CHORALE_MEL_FILE'] = mel_file
    r = subprocess.run([LILYPOND, '-dno-point-and-click', *args], cwd=HERE, env=env,
                       capture_output=True, text=True, encoding='utf-8', errors='replace')
    errs = [l for l in r.stderr.splitlines() if re.search(r'erreur|error', l, re.I)]
    if r.returncode != 0 or errs:
        print(r.stderr)
        raise SystemExit(f'LilyPond a échoué : {args}')


def pages(prefix):
    single = prefix + '.svg'
    if os.path.exists(single):
        return [single]
    return sorted(glob.glob(prefix + '-*.svg'), key=lambda p: int(re.search(r'-(\d+)\.svg$', p).group(1)))


def prefix_ids(svg, pfx):
    ids = set(re.findall(r'\bid="([^"]+)"', svg))
    def rid(m):
        return f'{m.group(1)}"{pfx}{m.group(2)}"' if m.group(2) in ids else m.group(0)
    svg = re.sub(r'(\bid=)"([^"]+)"', rid, svg)
    svg = re.sub(r'((?:xlink:)?href=)"#([^"]+)"', lambda m: f'{m.group(1)}"#{pfx}{m.group(2)}"' if m.group(2) in ids else m.group(0), svg)
    svg = re.sub(r'url\(#([^)]+)\)', lambda m: f'url(#{pfx}{m.group(1)})' if m.group(1) in ids else m.group(0), svg)
    return svg


def note_overlay(pdf_page, svg, ties=frozenset()):
    """Notes du lecteur : un <use> par tête de note, copie exacte du glyphe affiché.

    Les liens « http://n/?… » du PDF annoté donnent la note (voix, temps, hauteur…)
    et le cadre de sa tête ; on retrouve dans le SVG (même mise en page) le glyphe
    dessiné à cet endroit."""
    uses = [(m.group(1), float(m.group(2)), float(m.group(3))) for m in USE_RE.finditer(svg)]
    out = []
    for link in pdf_page.get_links():
        uri = link.get('uri') or ''
        if not uri.startswith('http://n/?'):
            continue
        r = link['from']
        cy = (r.y0 + r.y1) / 2
        cand = [(abs(x - r.x0) + abs(y - cy), g, x, y) for g, x, y in uses
                if r.x0 - 1.5 <= x <= r.x0 + 1.5 and r.y0 - 1 <= y <= r.y1 + 1]
        if not cand:
            raise SystemExit(f'tête de note introuvable dans le SVG : {uri} {r}')
        _, g, x, y = min(cand)
        attrs = dict(kv.split('=', 1) for kv in uri[len('http://n/?'):].split('&'))
        if (attrs.get('v'), attrs.get('t'), attrs.get('p')) in ties:
            attrs['tie'] = '1'
        data = ' '.join(f'data-{k}="{v}"' for k, v in attrs.items())
        out.append(f'<use class="nh" {data} xlink:href="#{g}" x="{x}" y="{y}"/>')
    return out


USE_RE = re.compile(r'<use xlink:href="#([^"]+)" x="([-\d.]+)" y="([-\d.]+)"/>')
VOICE_FALLBACK = {'sop': 'S', 'alto': 'A', 'ten': 'T', 'bas': 'B', 'solo': 'Solo'}


def voice_map(src):
    """Nom de contexte Voice (« sop ») -> voix du lecteur (« S »)."""
    text = open(os.path.join(HERE, src), encoding='utf-8').read()
    m = dict(VOICE_FALLBACK)
    for name, tag in re.findall(r'\\new Voice = "(\w+)"\s*\\with\s*\\voiceAttrs\s*"(\w+)"', text):
        m[name] = tag
    return m


def parse_uri(uri, prefix):
    return {k: unquote(v) for k, v in (kv.split('=', 1) for kv in uri[len(prefix):].split('&'))}


def lyric_overlay(pdf_page, svg, vmap, mel=frozenset()):
    """Paroles du lecteur : un <g class="ly"> par syllabe, copie exacte de ses glyphes.

    Les liens « http://l/?… » donnent la syllabe (ligne, couplet, voix, instant, texte)
    et son cadre ; on recopie les glyphes du SVG dessinés dans ce cadre.
    Les liens « http://h/?… » signalent les syllabes suivies d'un trait d'union."""
    uses = [(m.group(1), float(m.group(2)), float(m.group(3))) for m in USE_RE.finditer(svg)]
    links = pdf_page.get_links()
    hyph, ext, mel = set(), set(), set(mel)
    for link in links:
        uri = link.get('uri') or ''
        for prefix, dest in (('http://h/?', hyph), ('http://e/?', ext)):
            if uri.startswith(prefix):
                q = parse_uri(uri, prefix)
                dest.add((q['ln'], q['t']))
    out, bad = [], []
    for link in links:
        uri = link.get('uri') or ''
        if not uri.startswith('http://l/?'):
            continue
        q = parse_uri(uri, 'http://l/?')
        r = link['from']
        glyphs = sorted(((g, x, y) for g, x, y in uses
                         if r.x0 - 0.6 <= x <= r.x1 + 0.2 and r.y0 + 0.4 * (r.y1 - r.y0) <= y <= r.y1 + 1),
                        key=lambda u: u[1])
        n = len(re.sub(r'\s', '', q['tx']))
        if not n:
            mel.add((q['ln'], q['t']))
            continue
        if len(glyphs) != n:
            bad.append(f"{q['tx']}({len(glyphs)}/{n})")
        if not glyphs:
            continue
        attrs = {
            'ln': q['ln'], 'st': q['st'].rstrip('.'), 'v': vmap.get(q['vc'], q['vc']),
            'm': q['m'], 't': q['t'], 'tx': q['tx'],
        }
        if (q['ln'], q['t']) in hyph:
            attrs['hy'] = '1'
        if (q['ln'], q['t']) in ext:
            attrs['ex'] = '1'
        data = ' '.join(f'data-{k}="{html.escape(v, quote=True)}"' for k, v in attrs.items())
        out.append(f'<g class="ly" {data}>' + ''.join(
            f'<use xlink:href="#{g}" x="{x}" y="{y}"/>' for g, x, y in glyphs) + '</g>')
    # « _ » : la syllabe précédente de la ligne est tenue sur cette note
    out += [f'<g class="ly mel" data-ln="{ln}" data-t="{t}"></g>' for ln, t in sorted(mel)]
    return out, bad


def build_song(song):
    sid = song['id']
    out = os.path.join(SITE, 'chants', sid)
    os.makedirs(out, exist_ok=True)
    os.makedirs(TMP, exist_ok=True)
    src = song.get('file', sid) + '.ly'
    print(f'• {sid}')
    # 1. PDF à télécharger
    run(['-o', os.path.join(out, sid), src])
    # 2. Une seule mise en page Cairo -> PDF annoté (liens sur les têtes) + SVG d'affichage
    for f in glob.glob(os.path.join(TMP, sid + '*')):
        os.remove(f)
    base = os.path.join(TMP, sid)
    mel_file = base + '.mel.txt'
    run(['-dbackend=cairo', '--pdf', '--svg', '-o', base, src], annotate=True, mel_file=mel_file)
    mel = set()
    if os.path.exists(mel_file):
        mel = {tuple(l.split('	')) for l in open(mel_file, encoding='utf-8').read().splitlines() if '	' in l}
    disp = pages(base)
    doc = fitz.open(base + '.pdf')
    assert len(disp) == len(doc), (disp, len(doc))
    out_pages = []
    total = 0
    nly = 0
    vmap = voice_map(src)
    # Liaisons de prolongation (liens « http://t/?… » sur les traits), toutes pages confondues
    ties = {(q['v'], q['t'], q['p']) for pg in doc for l in pg.get_links()
            if (l.get('uri') or '').startswith('http://t/?') for q in [parse_uri(l['uri'], 'http://t/?')]}
    for i, c in enumerate(disp):
        sc = open(c, encoding='utf-8').read()
        sc = sc[sc.index('<svg'):]
        sc = prefix_ids(sc, f'{sid}{i}-')
        notes = note_overlay(doc[i], sc, ties)
        lyr, bad = lyric_overlay(doc[i], sc, vmap, mel if i == 0 else set())
        if bad:
            print(f'  ! page {i + 1} : glyphes de syllabes douteux : ' + ', '.join(bad[:12]))
        total += len(notes)
        nly += len(lyr)
        sc = re.sub(r'<svg ([^>]*?)width="[^"]*" height="[^"]*"', r'<svg \1', sc, count=1)
        sc = sc.replace('</svg>', '<g class="overlay">' + ''.join(lyr) + ''.join(notes) + '</g></svg>')
        out_pages.append(sc)
    data = {k: v for k, v in song.items() if k not in ('file',)}
    data['pages'] = out_pages
    data['pdf'] = sid + '.pdf'
    with open(os.path.join(out, 'data.js'), 'w', encoding='utf-8') as f:
        f.write('window.CHANT = ' + json.dumps(data, ensure_ascii=False) + ';\n')
    print(f'  {len(out_pages)} page(s), {total} notes, {nly} syllabes, {len(mel)} vocalises « _ »')
    return len(out_pages)


def main():
    songs = json.load(open(os.path.join(HERE, 'chants.json'), encoding='utf-8'))
    only = set(sys.argv[1:])
    if '--catalogue' in only:  # ne régénère que chants.js (ex. après ajout d'un synchro.json)
        only = {'--catalogue'}
    for s in songs:
        # Vidéo synchronisée : présente si site/chants/<id>/synchro.json existe
        s['video'] = os.path.exists(os.path.join(SITE, 'chants', s['id'], 'synchro.json'))
        if not only or s['id'] in only:
            s['nPages'] = build_song(s)
        else:
            dj = os.path.join(SITE, 'chants', s['id'], 'data.js')
            s['nPages'] = len(json.loads(open(dj, encoding='utf-8').read()[len('window.CHANT = '):-2])['pages']) if os.path.exists(dj) else 0
    catalogue = [{k: v for k, v in s.items() if k != 'file'} for s in songs]
    with open(os.path.join(SITE, 'chants.js'), 'w', encoding='utf-8') as f:
        f.write('window.CHANTS = ' + json.dumps(catalogue, ensure_ascii=False, indent=1) + ';\n')
    print('catalogue :', len(catalogue), 'chants')


if __name__ == '__main__':
    main()
