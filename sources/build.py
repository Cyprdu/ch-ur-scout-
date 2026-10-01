"""Construit le site : PDF + SVG annotés + données JS pour chaque chant.

usage : python build.py [id ...]      (sans argument : tous les chants)
"""
import json, os, re, shutil, subprocess, sys, glob

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SITE = os.path.join(ROOT, 'site') if os.path.isdir(os.path.join(ROOT, 'site')) else ROOT
TMP = os.path.join(ROOT, 'build', 'web')
LILYPOND = os.environ.get('LILYPOND') or shutil.which('lilypond') or 'lilypond'
PAGE_W_PT = 595.2756  # A4


def run(args):
    r = subprocess.run([LILYPOND, '-dno-point-and-click', *args], cwd=HERE,
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


def build_song(song):
    sid = song['id']
    out = os.path.join(SITE, 'chants', sid)
    os.makedirs(out, exist_ok=True)
    os.makedirs(TMP, exist_ok=True)
    src = song.get('file', sid) + '.ly'
    print(f'• {sid}')
    # 1. PDF
    run(['-o', os.path.join(out, sid), src])
    # 2. SVG annoté (positions + temps des notes)
    for f in glob.glob(os.path.join(TMP, sid + '*.svg')):
        os.remove(f)
    run(['-dbackend=svg', '-o', os.path.join(TMP, sid + '_a'), src])
    # 3. SVG d'affichage (texte vectorisé, rendu identique au PDF)
    run(['-dbackend=cairo', '--svg', '-o', os.path.join(TMP, sid + '_c'), src])
    ann, disp = pages(os.path.join(TMP, sid + '_a')), pages(os.path.join(TMP, sid + '_c'))
    assert len(ann) == len(disp), (ann, disp)
    out_pages = []
    total = 0
    for i, (a, c) in enumerate(zip(ann, disp)):
        sa = open(a, encoding='utf-8').read()
        sc = open(c, encoding='utf-8').read()
        vb = [float(v) for v in re.search(r'viewBox="([^"]+)"', sa).group(1).split()]
        k = PAGE_W_PT / vb[2]
        groups = re.findall(r'<g class="nh".*?</g>\s*</g>', sa, flags=re.S)
        total += len(groups)
        sc = sc[sc.index('<svg'):]
        sc = prefix_ids(sc, f'{sid}{i}-')
        sc = re.sub(r'<svg ([^>]*?)width="[^"]*" height="[^"]*"', r'<svg \1', sc, count=1)
        overlay = f'<g class="overlay" transform="scale({k:.6f})">' + ''.join(g.replace('\n', '') for g in groups) + '</g>'
        sc = sc.replace('</svg>', overlay + '</svg>')
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
