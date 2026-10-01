// Jeu d'icônes SVG (inséré une fois dans la page, utilisé via <use href="#i-…">)
(function () {
  const icons = {
    play: '<path class="f" d="M8 5.6v12.8a.8.8 0 0 0 1.2.7l10.4-6.4a.8.8 0 0 0 0-1.4L9.2 4.9A.8.8 0 0 0 8 5.6z"/>',
    pause: '<rect class="f" x="6.5" y="5" width="4" height="14" rx="1"/><rect class="f" x="13.5" y="5" width="4" height="14" rx="1"/>',
    restart: '<path d="M19 19.2 9.6 12.6a.7.7 0 0 1 0-1.2L19 4.8"/><path d="M5.5 5v14"/>',
    metronome: '<path d="M9.2 3.5h5.6l3.9 16.6a.8.8 0 0 1-.8 1H6.1a.8.8 0 0 1-.8-1z"/><path d="M12 16.5 17.5 6"/><path d="M7.4 16.5h9.2"/>',
    headphones: '<path d="M4 15v-3a8 8 0 0 1 16 0v3"/><rect x="3.5" y="14" width="4.5" height="6.5" rx="1.6"/><rect x="16" y="14" width="4.5" height="6.5" rx="1.6"/>',
    download: '<path d="M12 4v11"/><path d="m7.5 10.5 4.5 4.5 4.5-4.5"/><path d="M5 20h14"/>',
    back: '<path d="M19 12H5"/><path d="m11 18-6-6 6-6"/>',
    search: '<circle cx="11" cy="11" r="6.5"/><path d="m20 20-4.2-4.2"/>',
    minus: '<path d="M6 12h12"/>',
    plus: '<path d="M6 12h12"/><path d="M12 6v12"/>',
    loop: '<path d="m17 3 3 3-3 3"/><path d="M4 11.5V10a4 4 0 0 1 4-4h12"/><path d="m7 21-3-3 3-3"/><path d="M20 12.5V14a4 4 0 0 1-4 4H4"/>',
    note: '<path d="M9 18V5.5l11-2V16"/><circle cx="6.5" cy="18" r="2.5"/><circle cx="17.5" cy="16" r="2.5"/>',
    video: '<rect x="3" y="5.5" width="13" height="13" rx="2.5"/><path d="m16 10.2 4.2-2.6a.6.6 0 0 1 .8.5v7.8a.6.6 0 0 1-.8.5L16 13.8"/>',
    list: '<path d="M9 6h11"/><path d="M9 12h11"/><path d="M9 18h11"/><circle class="f" cx="4.5" cy="6" r="1.3"/><circle class="f" cx="4.5" cy="12" r="1.3"/><circle class="f" cx="4.5" cy="18" r="1.3"/>',
    file: '<path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/>',
  };
  const sprite = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  sprite.setAttribute('style', 'display:none');
  sprite.innerHTML = Object.entries(icons).map(([k, v]) =>
    `<symbol id="i-${k}" viewBox="0 0 24 24">${v.replace(/class="f"/g, 'style="fill:currentColor;stroke:none"')}</symbol>`).join('');
  document.body.prepend(sprite);
  window.icon = (name, cls = '') => `<svg class="icon ${cls}" aria-hidden="true"><use href="#i-${name}"/></svg>`;
})();
