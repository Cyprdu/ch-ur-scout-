"""Construit le site : PDF + SVG d'affichage + positions des notes + données JS pour chaque chant.

usage : python build.py [id ...]      (sans argument : tous les chants)
"""
import json, os, re, shutil, subprocess, sys, glob
import fitz  # PyMuPDF

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SITE = os.path.join(ROOT, 'site') if os.path.isdir(os.path.join(ROOT, 'site')) else ROOT
TMP = os.path.join(ROOT, 'build', 'web')
LILYPOND = os.environ.get('LILYPOND') or shutil.which('lilypond') or \
    r'C:/Users/cypri/AppData/Local/Temp/claude/C--Users-cypri-Downloads-Nouveau-dossier/b72d01b3-3782-4219-843d-e8350c48d756/scratchpad/lilypond-2.24.4/bin/lilypond.exe'


def run(args, annotate=False):
    env = dict(os.environ, CHORALE_ANNOTATE='1') if annotate else {k: v for k, v in os.environ.items() if k != 'CHORALE_ANNOTATE'}
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


def note_overlay(pdf_page, svg):
    """Notes du lecteur : un <use> par tête de note, copie exacte du glyphe affiché.

    Les liens « http://n/?… » du PDF annoté donnent la note (voix, temps, hauteur…)
    et le cadre de sa tête ; on retrouve dans le SVG (même mise en page) le glyphe
    dessiné à cet endroit."""
    uses = [(m.group(1), float(m.group(2)), float(m.group(3)))
            for m in re.finditer(r'<use xlink:href="#([^"]+)" x="([-\d.]+)" y="([-\d.]+)"/>', svg)]
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
        data = ' '.join(f'data-{k}="{v}"' for k, v in attrs.items())
        out.append(f'<use class="nh" {data} xlink:href="#{g}" x="{x}" y="{y}"/>')
    return out


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
    run(['-dbackend=cairo', '--pdf', '--svg', '-o', base, src], annotate=True)
    disp = pages(base)
    doc = fitz.open(base + '.pdf')
    assert len(disp) == len(doc), (disp, len(doc))
    out_pages = []
    total = 0
    for i, c in enumerate(disp):
        sc = open(c, encoding='utf-8').read()
        sc = sc[sc.index('<svg'):]
        sc = prefix_ids(sc, f'{sid}{i}-')
        notes = note_overlay(doc[i], sc)
        total += len(notes)
        sc = re.sub(r'<svg ([^>]*?)width="[^"]*" height="[^"]*"', r'<svg \1', sc, count=1)
        sc = sc.replace('</svg>', '<g class="overlay">' + ''.join(notes) + '</g></svg>')
        out_pages.append(sc)
    data = {k: v for k, v in song.items() if k not in ('file',)}
    data['pages'] = out_pages
    data['pdf'] = sid + '.pdf'
    with open(os.path.join(out, 'data.js'), 'w', encoding='utf-8') as f:
        f.write('window.CHANT = ' + json.dumps(data, ensure_ascii=False) + ';\n')
    print(f'  {len(out_pages)} page(s), {total} notes')
    return len(out_pages)


def main():
    songs = json.load(open(os.path.join(HERE, 'chants.json'), encoding='utf-8'))
    only = set(sys.argv[1:])
    for s in songs:
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
