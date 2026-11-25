"""Concert de Noël : prend les MP3 exportés (dossier Choarle),
les copie tels quels dans site/noel/ et écrit site/noel/pistes.js.
usage : python noel_import.py [dossier des MP3]   (défaut : ~/Documents/Musique/Choarle)"""
import hashlib, json, os, shutil, subprocess, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
SITE = os.path.join(HERE, '..', 'site')
OUT = os.path.join(SITE, 'noel')
SRC = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser('~/Documents/Musique/Choarle')
DIRS = {'Dirige-moi': 'dirige-moi-par-ta-verite', 'Glorificamus Te': 'glorificamus-te', 'Il est au milieu de nous': 'il-est-au-milieu-de-nous',
        'Je ne t': 'je-ne-t-ai-point-cherche', 'Jhesus': 'jhesu-maria', 'L_veil': 'l-eveil-du-salut', 'La Nativ': 'la-nativite',
        'Le Lion': 'le-lion', 'Maintenant': 'maintenant-seigneur', 'Venez': 'venez-tous-accourez'}
V = {'Soprano': 'S', 'Alto': 'A', 'Ténor': 'T', 'Basse': 'B', 'Soprano 2': 'S2', 'Solo': 'Solo'}


def ff(*a):
    return subprocess.run(['ffmpeg', '-nostdin', '-hide_banner', *a], capture_output=True)


def pcm(f):
    return np.frombuffer(ff('-v', 'error', '-i', f, '-ac', '1', '-ar', '8000', '-f', 's16le', '-').stdout, np.int16).astype(float)


def corr(r, x):
    best = 0
    for s in (60, 100):
        a, b = r[s * 8000:(s + 8) * 8000], x[(s - 1) * 8000:(s + 9) * 8000]
        if len(a) and len(b):
            L = 1 << 18
            c = np.fft.irfft(np.fft.rfft(b, L) * np.conj(np.fft.rfft(a, L)))[:16000]
            best = max(best, c.max() / np.sqrt((a @ a) * (b @ b) + 1))
    return best


def copy(src, dst):
    shutil.copyfile(src, dst)
    return hashlib.md5(open(dst, 'rb').read()).hexdigest()[:8]


pistes = {}
for d in sorted(os.listdir(SRC)):
    k = next((v for p, v in DIRS.items() if d.startswith(p)), 'l-eveil-du-salut' if 'veil' in d else None)
    if not k:
        continue
    e = pistes[k] = {'voices': {}, 'd': {}, 'piano': []}
    rec, r = os.path.join(SITE, 'chants', k, 'enregistrement.mp3'), None
    todo = [(V[n[:-4].rsplit(' - ', 1)[1]], os.path.join(SRC, d, n)) for n in os.listdir(os.path.join(SRC, d)) if n.endswith('.mp3')]
    if os.path.exists(rec):
        r = pcm(rec)
        todo.insert(0, ('Tutti', rec))
    for v, f in todo:
        x = pcm(f)
        c = corr(r, x) if r is not None else 0
        e['voices'][v] = copy(f, os.path.join(OUT, f'{k}-{v}.mp3')) if v != 'Tutti' else hashlib.md5(open(f, 'rb').read()).hexdigest()[:8]
        e['d'][v] = round(len(x) / 8000, 1)
        if c < 0.12:
            e['piano'].append(v)
        print(k, v, e['d'][v], f'corr {c:.2f}', flush=True)
    e['choir'] = r is not None
tr = next(os.path.join(SRC, d, n) for d in os.listdir(SRC) if '3 routes' in d for n in os.listdir(os.path.join(SRC, d)))
copy(tr, os.path.join(OUT, 'trois-routes.mp3'))
with open(os.path.join(OUT, 'pistes.js'), 'w', encoding='utf-8') as f:
    f.write('window.PISTES = ' + json.dumps(pistes, ensure_ascii=False, indent=1) + ';')
