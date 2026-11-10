/* Application installable et hors ligne : enregistre sw.js et affiche l'avancement
   du téléchargement des chants sur l'appareil. */
(() => {
  // Pas sur le studio local (port 8765) : il doit toujours lire les fichiers à jour
  if (!('serviceWorker' in navigator) || location.protocol === 'file:' || location.port === '8765') return;
  navigator.serviceWorker.register('sw.js', { updateViaCache: 'none' }).catch(() => {});
  if (navigator.storage && navigator.storage.persist) navigator.storage.persist().catch(() => {});

  let el, timer;
  const show = (txt, hideAfter) => {
    if (!el) { el = document.createElement('div'); el.className = 'offline-pill'; document.body.appendChild(el); }
    el.textContent = txt; el.classList.add('show');
    clearTimeout(timer);
    if (hideAfter) timer = setTimeout(() => el.classList.remove('show'), hideAfter);
  };
  navigator.serviceWorker.addEventListener('message', e => {
    const m = e.data;
    if (!m || m.type !== 'offline') return;
    if (m.done < m.total) show(`Téléchargement pour le hors ligne… ${Math.floor(m.done / m.total * 100)} %`);
    else show('✓ Tous les chants sont disponibles hors ligne', 4000);
  });
})();
