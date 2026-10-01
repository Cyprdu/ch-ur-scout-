"""Serveur local du site + studio de synchronisation.

usage : python studio.py [port]          (par défaut 8000)

- sert le dossier site/ sans cache (les modifications apparaissent tout de suite) ;
- /api/status                 : ce que le serveur sait faire ;
- /api/publish (POST/DELETE)  : écrit / retire site/chants/<chant>/synchro.json
                                (l'ancienne version est archivée dans sources/synchro-archive/) ;
- /api/audio/<id>/peaks       : forme d'onde et attaques de l'audio d'une vidéo YouTube
                                (téléchargé avec yt-dlp, décodé avec ffmpeg, mis en cache).
"""
import json, os, re, shutil, subprocess, sys, threading, time, webbrowser
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SITE = os.path.join(ROOT, 'site') if os.path.isdir(os.path.join(ROOT, 'site')) else ROOT
CACHE = os.path.join(HERE, '.cache', 'audio')
ARCHIVE = os.path.join(HERE, 'synchro-archive')
ID_RE = re.compile(r'^[\w-]{11}$')
CHANT_RE = re.compile(r'^[a-z0-9-]+$')
LOCKS = {}


def tool(name):
    return shutil.which(name)


def catalogue():
    subprocess.run([sys.executable, os.path.join(HERE, 'build.py'), '--catalogue'], cwd=HERE,
                   capture_output=True, text=True)


# ---------------------------------------------------------------- audio
def audio_file(vid):
    os.makedirs(CACHE, exist_ok=True)
    for f in os.listdir(CACHE):
        if f.startswith(vid + '.') and not f.endswith(('.json', '.part', '.ytdl')):
            return os.path.join(CACHE, f)
    ytdlp = tool('yt-dlp')
    if not ytdlp:
        raise RuntimeError("yt-dlp n'est pas installé")
    r = subprocess.run([ytdlp, '-f', 'bestaudio', '--no-playlist', '-q', '--no-warnings',
                        '-o', os.path.join(CACHE, vid + '.%(ext)s'), f'https://www.youtube.com/watch?v={vid}'],
                       capture_output=True, text=True, encoding='utf-8', errors='replace')
    for f in os.listdir(CACHE):
        if f.startswith(vid + '.') and not f.endswith(('.json', '.part', '.ytdl')):
            return os.path.join(CACHE, f)
    raise RuntimeError('téléchargement impossible : ' + (r.stderr.strip().splitlines() or ['?'])[-1])


def analyse(vid):
    """Forme d'onde (100 valeurs / s, 0-255) et attaques (flux spectral)."""
    out = os.path.join(CACHE, vid + '.peaks.json')
    if os.path.exists(out):
        return json.load(open(out, encoding='utf-8'))
    import numpy as np
    src = audio_file(vid)
    ffmpeg = tool('ffmpeg')
    if not ffmpeg:
        raise RuntimeError("ffmpeg n'est pas installé")
    sr = 11025
    raw = subprocess.run([ffmpeg, '-v', 'error', '-i', src, '-ac', '1', '-ar', str(sr), '-f', 's16le', '-'],
                         capture_output=True).stdout
    x = np.frombuffer(raw, dtype=np.int16).astype(np.float32) / 32768.0
    if not len(x):
        raise RuntimeError('audio illisible')
    # Forme d'onde : maximum absolu par tranche de 10 ms, échelle racine (plus lisible)
    hop = sr // 100
    n = len(x) // hop
    env = np.abs(x[:n * hop]).reshape(n, hop).max(axis=1)
    top = np.percentile(env, 99.5) or 1.0
    peaks = np.clip(np.sqrt(env / top) * 255, 0, 255).astype(int).tolist()
    # Attaques : flux spectral (log-magnitude), seuil adaptatif, pics espacés de 60 ms
    win, step = 1024, 128
    frames = 1 + (len(x) - win) // step if len(x) >= win else 0
    onsets = []
    if frames > 10:
        idx = np.arange(win)[None, :] + step * np.arange(frames)[:, None]
        spec = np.abs(np.fft.rfft(x[idx] * np.hanning(win), axis=1))
        spec = np.log1p(100 * spec)
        flux = np.maximum(0, np.diff(spec, axis=0)).sum(axis=1)
        flux = np.concatenate([[0], flux])
        k = 25
        pad = np.pad(flux, k, mode='edge')
        med = np.array([np.median(pad[i:i + 2 * k + 1]) for i in range(len(flux))])
        strength = flux - med
        thr = np.percentile(strength, 75)
        min_gap = int(0.06 * sr / step)
        last = -min_gap
        for i in range(1, len(strength) - 1):
            if strength[i] > thr and strength[i] >= strength[i - 1] and strength[i] >= strength[i + 1] and i - last >= min_gap:
                onsets.append([round((i * step + win / 2) / sr, 3), round(float(strength[i]), 2)])
                last = i
        if onsets:
            mx = max(o[1] for o in onsets) or 1
            onsets = [[t, round(s / mx, 3)] for t, s in onsets]
    data = {'rate': 100, 'duration': round(len(x) / sr, 3), 'peaks': peaks, 'onsets': onsets}
    json.dump(data, open(out, 'w', encoding='utf-8'))
    return data


# ---------------------------------------------------------------- serveur
class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *a, **k):
        super().__init__(*a, directory=SITE, **k)

    def log_message(self, fmt, *args):
        if '/api/' in (self.path or ''):
            sys.stderr.write('  %s\n' % (fmt % args))

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

    def send_json(self, obj, code=200):
        body = json.dumps(obj, ensure_ascii=False).encode('utf-8')
        self.send_response(code)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == '/api/status':
            return self.send_json({'ok': True, 'publish': True,
                                   'audio': bool(tool('yt-dlp') and tool('ffmpeg'))})
        m = re.match(r'^/api/audio/([\w-]{11})/peaks$', self.path)
        if m:
            vid = m.group(1)
            lock = LOCKS.setdefault(vid, threading.Lock())
            try:
                with lock:
                    return self.send_json(analyse(vid))
            except Exception as e:  # noqa: BLE001
                return self.send_json({'error': str(e)})
        return super().do_GET()

    def read_json(self):
        n = int(self.headers.get('Content-Length') or 0)
        return json.loads(self.rfile.read(n).decode('utf-8') or '{}')

    def chant_dir(self, chant):
        if not CHANT_RE.match(chant or ''):
            raise ValueError('chant invalide')
        d = os.path.join(SITE, 'chants', chant)
        if not os.path.isdir(d):
            raise ValueError('chant inconnu')
        return d

    def archive(self, chant, path):
        if os.path.exists(path):
            os.makedirs(ARCHIVE, exist_ok=True)
            shutil.copy2(path, os.path.join(ARCHIVE, f'{chant}-{time.strftime("%Y%m%d-%H%M%S")}.json'))

    def do_POST(self):
        if self.path != '/api/publish':
            return self.send_json({'error': 'inconnu'}, 404)
        try:
            body = self.read_json()
            chant = body.get('chant')
            data = body.get('data')
            if not isinstance(data, dict) or not isinstance(data.get('marks'), list) or not ID_RE.match(data.get('video', '')):
                raise ValueError('données de synchro invalides')
            path = os.path.join(self.chant_dir(chant), 'synchro.json')
            self.archive(chant, path)
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=1)
            catalogue()
            return self.send_json({'ok': True, 'path': os.path.relpath(path, ROOT)})
        except Exception as e:  # noqa: BLE001
            return self.send_json({'error': str(e)}, 400)

    def do_DELETE(self):
        m = re.match(r'^/api/publish/([a-z0-9-]+)$', self.path)
        if not m:
            return self.send_json({'error': 'inconnu'}, 404)
        try:
            path = os.path.join(self.chant_dir(m.group(1)), 'synchro.json')
            self.archive(m.group(1), path)
            if os.path.exists(path):
                os.remove(path)
            catalogue()
            return self.send_json({'ok': True})
        except Exception as e:  # noqa: BLE001
            return self.send_json({'error': str(e)}, 400)


def main():
    port = next((int(a) for a in sys.argv[1:] if a.isdigit()), 8000)
    srv = ThreadingHTTPServer(('127.0.0.1', port), Handler)
    url = f'http://localhost:{port}/synchro.html'
    print(f'Studio de synchronisation : {url}')
    print('(laisser cette fenêtre ouverte ; Ctrl+C pour arrêter)')
    if '--no-browser' not in sys.argv:
        threading.Timer(0.8, lambda: webbrowser.open(url)).start()
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
