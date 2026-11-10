/* Hors ligne : tout le site (pages, partitions, enregistrements MP3, sons de piano) est gardé
   sur l'appareil. precache.js (généré par build.py) liste chaque fichier avec sa révision :
   à chaque publication, seuls les fichiers modifiés sont retéléchargés. */
importScripts('precache.js');   // self.PRECACHE = { chemin: révision }

const CACHE = 'chorale', META = 'chorale-meta';
const FONTS = 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Source+Serif+4:opsz,wght@8..60,500;8..60,600&display=swap';
const EXTERNAL = [FONTS, 'https://cdnjs.cloudflare.com/ajax/libs/lamejs/1.2.1/lame.min.js'];
const ROOT = new URL('./', self.location).href;
const abs = p => new URL(p, ROOT).href;
// L'hébergeur redirige chant.html -> /chant : Safari refuse d'afficher une page « redirigée »
// servie par le service worker, on la recopie donc sans cette marque.
const clean = res => (res && res.redirected
  ? res.blob().then(b => new Response(b, { status: res.status, statusText: res.statusText, headers: res.headers }))
  : res);
const key = url => { const u = new URL(url); return u.origin === location.origin ? u.origin + u.pathname : url; };

async function report(done, total) {
  for (const c of await self.clients.matchAll({ includeUncontrolled: true })) c.postMessage({ type: 'offline', done, total });
}

async function sync() {
  const cache = await caches.open(CACHE), meta = await caches.open(META);
  const old = await meta.match('revs').then(r => (r ? r.json() : {}));
  const revs = {};
  const entries = Object.entries(self.PRECACHE);
  const todo = [];
  for (const [p, r] of entries) {
    const hit = old[p] === r && await cache.match(abs(p));
    if (hit && !hit.redirected) revs[p] = r; else todo.push([p, r]);
  }
  const total = entries.length;
  let done = total - todo.length, i = 0;
  const save = () => meta.put('revs', new Response(JSON.stringify(revs)));
  if (todo.length) report(done, total);
  // 4 téléchargements à la fois ; ce qui est déjà téléchargé est gardé même si la suite échoue
  await Promise.all(Array.from({ length: 4 }, async () => {
    while (i < todo.length) {
      const [p, r] = todo[i++];
      const res = await fetch(abs(p), { cache: 'reload' });
      if (!res.ok) throw new Error(`${p} : ${res.status}`);
      await cache.put(abs(p), await clean(res));
      revs[p] = r; done++;
      if (done % 5 === 0 || done === total) { await save(); report(done, total); }
    }
  }));
  await save();
  // fichiers retirés du site
  const keep = new Set(entries.map(([p]) => abs(p)));
  for (const req of await cache.keys()) {
    if (new URL(req.url).origin === location.origin && !keep.has(req.url)) await cache.delete(req);
  }
  // polices et encodeur MP3 (hors du site)
  for (const url of EXTERNAL) {
    if (!(await cache.match(url))) {
      const res = await fetch(url);
      if (!res.ok) throw new Error(url);
      if (url === FONTS) {
        const css = await res.clone().text();
        for (const [, f] of css.matchAll(/url\((https:[^)]+)\)/g)) if (!(await cache.match(f))) await cache.put(f, await fetch(f));
      }
      await cache.put(url, res);
    }
  }
  if (todo.length) report(total, total);
}

self.addEventListener('install', e => e.waitUntil(sync().then(() => self.skipWaiting())));
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin === location.origin && url.pathname.startsWith('/api/')) return;   // studio local
  const k = req.mode === 'navigate' && url.pathname.endsWith('/') ? abs('index.html') : key(req.url);
  e.respondWith(caches.open(CACHE).then(async cache => {
    // /chant (adresse après redirection) = chant.html
    const hit = await cache.match(k) || (/\/[^./]+$/.test(url.pathname) && await cache.match(k + '.html'));
    if (hit) return clean(hit);
    try {
      const res = await clean(await fetch(req));
      if (res.ok && url.origin !== location.origin) cache.put(k, res.clone());   // ex. fichiers de police
      return res;
    } catch (err) {
      if (req.mode === 'navigate') return cache.match(abs('index.html'));
      throw err;
    }
  }));
});
