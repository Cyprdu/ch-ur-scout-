/* Lien avec le direct du concert (worker.js) : appelle onEtat({i, n}) à chaque changement d'étape.
   WebSocket, avec reconnexion ; à défaut, interrogation toutes les 15 s. */
/* Codage de l'état i : -1 = rien (avant le concert), 0 = accueil, 1 à 99 = chant n° i,
   100 + n = saynète après le chant n (100 = avant le 1er chant). */
window.etatDe = i => (i === 0 ? { accueil: true } : i >= 1 && i < 100 ? { chant: i } : i >= 100 ? { saynete: true, apres: i - 100 } : {});
// début du concert : mercredi 2 décembre 2026, 20 h 30 (heure de Paris)
window.DEBUT_CONCERT = Date.parse('2026-12-02T20:30:00+01:00');

window.liveConnect = function (onEtat) {
  const base = location.origin;
  let ws = null, retry = 1000, poll = null, last = null;
  const got = e => { if (typeof e.i === 'number') { last = e; onEtat(e); } };
  const fetchEtat = () => fetch(base + '/live/etat', { cache: 'no-store' }).then(r => (r.ok ? r.json() : null)).then(e => e && got(e)).catch(() => {});
  function open() {
    if (ws && ws.readyState <= 1) return;
    try { ws = new WebSocket(base.replace(/^http/, 'ws') + '/live/ws'); } catch { return later(); }
    ws.onmessage = m => { try { got(JSON.parse(m.data)); } catch {} };
    ws.onopen = () => { retry = 1000; clearInterval(poll); poll = null; };
    ws.onclose = later;
  }
  function later() {
    ws = null;
    if (!poll) { fetchEtat(); poll = setInterval(fetchEtat, 15000); }
    setTimeout(open, retry);
    retry = Math.min(retry * 2, 30000);
  }
  // téléphone sorti de veille : on se remet à jour tout de suite
  document.addEventListener('visibilitychange', () => { if (!document.hidden) { fetchEtat(); open(); } });
  setInterval(() => { if (ws && ws.readyState === 1) ws.send('ping'); }, 50000);
  open();
  return { get: () => last, refresh: fetchEtat };
};
