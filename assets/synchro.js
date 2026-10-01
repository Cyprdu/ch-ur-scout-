/* Studio de synchronisation : caler un enregistrement YouTube sur la partition,
   mesure par mesure ou mot par mot, puis vérifier, corriger et publier. */
(async () => {
  const C = window.Chorale;
  const { EPS, store, esc } = C;
  const $ = id => document.getElementById(id);
  const toast = C.toaster($('status'));
  const r3 = x => Math.round(x * 1000) / 1000;
  const fmtT = s => C.fmt(s, true);
  const fmtH = s => {
    if (s == null || !isFinite(s)) return '—';
    const m = Math.floor(s / 60);
    return `${m}:${(s - m * 60).toFixed(2).padStart(5, '0')}`;
  };
  $('backBtn').innerHTML = icon('back') + '<span class="lbl">Chants</span>';

  // ======================================================================
  // Projet : chant + vidéo
  // ======================================================================
  const parseYouTube = s => {
    s = (s || '').trim();
    if (/^[\w-]{11}$/.test(s)) return s;
    const m = s.match(/(?:[?&]v=|youtu\.be\/|\/shorts\/|\/embed\/|\/live\/)([\w-]{11})/);
    return m ? m[1] : null;
  };
  const qs = new URLSearchParams(location.search);
  const last = store.get('chorale.synchro.last') || {};
  const chantId = qs.get('c') || last.c || '';
  const videoId = parseYouTube(qs.get('v') || '');
  const sel = $('chantSel');
  [...window.CHANTS].sort((a, b) => a.title.localeCompare(b.title, 'fr')).forEach(s => {
    const o = document.createElement('option');
    o.value = s.id; o.textContent = s.title + (s.video ? '  ●' : ''); sel.appendChild(o);
  });
  if (chantId) sel.value = chantId;
  const fetchJSON = url => fetch(url, { cache: 'no-store' }).then(r => (r.ok ? r.json() : null)).catch(() => null);
  // Synchro publiée d'un chant (le catalogue indique s'il y en a une, sauf demande explicite)
  const publishedOf = (c, force) => {
    const m = window.CHANTS.find(s => s.id === c);
    if (location.protocol === 'file:' || (!force && m && m.video === false)) return Promise.resolve(null);
    return fetchJSON(`chants/${c}/synchro.json`);
  };
  async function suggestVideo() {
    const c = sel.value;
    let v = store.get(`chorale.synchro.last.${c}`);
    if (!v) { const pub = await publishedOf(c); v = pub && pub.video; }
    if (sel.value === c && !$('url').matches(':focus')) $('url').value = v ? `https://www.youtube.com/watch?v=${v}` : '';
  }
  if (videoId) $('url').value = `https://www.youtube.com/watch?v=${videoId}`; else suggestVideo();
  sel.onchange = suggestVideo;
  $('setup').onsubmit = e => {
    e.preventDefault();
    const v = parseYouTube($('url').value);
    if (!v) { toast('Lien YouTube non reconnu.'); $('url').focus(); return; }
    location.search = `?c=${encodeURIComponent(sel.value)}&v=${v}`;
  };
  const meta = window.CHANTS.find(s => s.id === chantId);
  if (!meta || !videoId) {
    document.body.classList.add('no-project');
    $('yt').innerHTML = '<div class="msg">La vidéo apparaîtra ici une fois le chant et la vidéo choisis.</div>';
    return;
  }
  store.set('chorale.synchro.last', { c: chantId, v: videoId });
  store.set(`chorale.synchro.last.${chantId}`, videoId);
  document.title = `${meta.title} · Studio de synchro`;
  $('actions').hidden = false;

  const api = location.protocol === 'file:' ? null : await fetchJSON('api/status');
  if (!api) {
    // Serveur simple (ou site hébergé) : « Publier » ne peut que télécharger le fichier
    $('publishBtn').textContent = 'Télécharger';
    $('publishBtn').title = 'Ce serveur ne peut pas écrire sur le site : le fichier de synchro sera téléchargé';
    const w = document.createElement('span');
    w.className = 'srv-warn';
    w.title = 'Fermez la fenêtre du serveur actuel puis double-cliquez sur site/serveur-local.bat';
    w.textContent = '⚠ Publication directe indisponible : relancez serveur-local.bat';
    $('actions').prepend(w);
  }

  // ======================================================================
  // Partition
  // ======================================================================
  await C.loadScript(`chants/${chantId}/data.js`).catch(() => null);
  const data = window.CHANT;
  const scoreEl = $('scoreInner');
  if (!data) { scoreEl.innerHTML = '<div class="empty-state">Impossible de charger la partition.</div>'; return; }
  $('scoreBar').hidden = false;
  $('timeline').hidden = false;
  const settings = Object.assign({
    preroll: 2, magnet: false, lyrHl: 'all', follow: 'measure', tapKind: 'm', tapVoice: null, tapUnit: 'word',
    pps: 40, tlH: 250, zoom: 1, followTl: true,
  }, store.get('chorale.studio.settings') || {});
  const saveSettings = () => store.set('chorale.studio.settings', settings);
  const ZOOMS = [0.6, 0.75, 0.9, 1, 1.25, 1.5, 1.75, 2];
  if (!ZOOMS.includes(settings.zoom)) settings.zoom = 1;
  const applyZoom = () => {
    scoreEl.style.setProperty('--zoom', settings.zoom);
    $('zVal').textContent = `${Math.round(settings.zoom * 100)} %`;
    saveSettings();
  };
  $('zMinus').innerHTML = icon('minus'); $('zPlus').innerHTML = icon('plus');
  $('zMinus').onclick = () => { settings.zoom = ZOOMS[Math.max(0, ZOOMS.indexOf(settings.zoom) - 1)]; applyZoom(); lastReveal = null; };
  $('zPlus').onclick = () => { settings.zoom = ZOOMS[Math.min(ZOOMS.length - 1, ZOOMS.indexOf(settings.zoom) + 1)]; applyZoom(); lastReveal = null; };
  applyZoom();

  const model = C.mountScore(scoreEl, data, meta);
  const { END, systems } = model;
  const groups = model.groups;
  const hasLyrics = groups.length > 0;
  const verseName = v => (meta.structure && meta.structure.names && meta.structure.names[v]) || `Couplet ${v}`;
  const vtag = v => `<span class="vtag" style="--c:${C.verseColor(v)}">${esc(verseName(v))}</span>`;

  // Calques de surlignage
  const pools = {};
  function paint(cls, rects) {
    const pool = pools[cls] || (pools[cls] = []);
    rects.forEach((r, i) => {
      let el = pool[i];
      if (!el) { el = document.createElementNS(C.NS, 'rect'); el.setAttribute('class', cls); el.setAttribute('rx', 2); pool.push(el); }
      if (el.parentNode !== model.layers[r.page]) model.layers[r.page].appendChild(el);
      el.setAttribute('x', r.x); el.setAttribute('y', r.y); el.setAttribute('width', r.w); el.setAttribute('height', r.h);
      el.style.display = '';
    });
    for (let i = rects.length; i < pool.length; i++) pool[i].style.display = 'none';
  }
  const sysBottom = s => Math.max(s.maxY, s.lyMaxY || -Infinity);
  function rangeRects(w0, w1) {
    return systems.filter(s => s.t0 < w1 - EPS && s.t1 > w0 + EPS).map(s => {
      const x0 = (w0 <= s.t0 + EPS ? model.xAt(s, s.t0) : model.xAt(s, w0)) - 7;
      const x1 = w1 >= s.t1 - EPS ? s.pts[s.pts.length - 1][1] + 6 : model.xAt(s, w1) - 7;
      return { page: s.page, x: x0, y: s.minY - 9, w: Math.max(4, x1 - x0), h: sysBottom(s) - s.minY + 14 };
    });
  }
  const sylRects = syl => syl.map(s => ({ page: s.page, x: s.x - 2, y: s.y - 2, w: s.w + 4, h: s.h + 4 }));
  let lyClasses = new Map();
  function setLyClasses(map) {
    lyClasses.forEach((cls, el) => { if (map.get(el) !== cls) el.classList.remove(cls); });
    map.forEach((cls, el) => el.classList.add(cls));
    lyClasses = map;
  }
  let noteOn = new Set();
  function setNotesOn(set) {
    noteOn.forEach(el => { if (!set.has(el)) el.classList.remove('on'); });
    set.forEach(el => el.classList.add('on'));
    noteOn = set;
  }
  const pane = $('score');
  let lastReveal = null;
  function reveal(key, cls) {
    if (key === lastReveal) return;
    const el = (pools[cls] || []).find(e => e.style.display !== 'none');
    if (!el) return;
    lastReveal = key;
    const r = el.getBoundingClientRect(), pr = pane.getBoundingClientRect();
    if (r.top < pr.top + 60 || r.bottom > pr.bottom - 30) pane.scrollBy({ top: r.top - pr.top - pr.height * 0.25, behavior: 'smooth' });
    if (r.left < pr.left + 10 || r.right > pr.right - 10) pane.scrollBy({ left: r.left - pr.left - pr.width * 0.2, behavior: 'smooth' });
  }

  // ======================================================================
  // Plan, étapes et repères
  // ======================================================================
  const PKEY = `chorale.studio.${chantId}.${videoId}`;
  let project = { cfg: C.structureConfig(meta, null), marks: {}, offset: 0 };
  let plan, mSteps, endStep, keyIndex, unitCache, tmap, markerList = [];
  let tlDirty = true;

  function rebuild() {
    const order = C.orderFromConfig(meta, project.cfg, END);
    plan = C.makePlan(order, END);
    mSteps = C.measureSteps(model, plan);
    endStep = { kind: 'end', key: 'end', P: plan.TOTAL, w: END, wEnd: END, seg: plan.segs[plan.segs.length - 1], label: 'Fin du chant', m: null };
    unitCache = {};
    keyIndex = new Map();
    mSteps.forEach(s => keyIndex.set(s.key, s));
    keyIndex.set('end', endStep);
    groups.forEach(g => units(g.v, 'syl').forEach(u => keyIndex.set(u.key, u)));
  }
  function units(voice, unit) {
    const k = `${voice}|${unit}`;
    return unitCache[k] || (unitCache[k] = C.lyricUnits(model, plan, voice, unit));
  }
  // Signature stable d'une étape, indépendante du découpage en passages
  function signatures() {
    const occ = {}, out = new Map();
    const add = s => {
      const base = `${s.kind}|${s.voice || ''}|${s.w}|${s.seg.v}`;
      occ[base] = (occ[base] || 0) + 1;
      out.set(s.key, `${base}#${occ[base]}`);
    };
    mSteps.forEach(add);
    groups.forEach(g => units(g.v, 'syl').forEach(add));
    out.set('end', 'end');
    return out;
  }
  function recomputeMap() {
    const pts = [];
    for (const [key, m] of Object.entries(project.marks)) {
      const st = keyIndex.get(key);
      if (st) pts.push({ P: st.P, t: m.t, key, kind: st.kind });
    }
    tmap = C.timeMap(pts, plan.TOTAL);
    markerList = pts.map(p => {
      const st = keyIndex.get(p.key);
      return {
        key: p.key, t: p.t, kind: st.kind, voice: st.voice, st,
        label: st.kind === 'm' ? String(st.m) : st.kind === 'end' ? 'Fin' : st.tx,
        color: C.verseColor(st.seg.v), bad: tmap.rejected.has(p.key),
      };
    }).sort((a, b) => a.t - b.t);
    tlDirty = true;
  }
  const hasMap = () => tmap && tmap.anchors.length >= 2;

  // Charge un fichier de synchro (v1 ou v2) dans le projet
  function fromFile(obj) {
    const n = C.normalizeSync(obj, meta, END);
    if (!n) throw new Error('fichier illisible');
    const st = obj.structure;
    let cfg;
    if (st && Array.isArray(st.verses)) cfg = C.structureConfig(meta, st);
    else {
      const vs = C.versesOfOrder(n.order);
      const gen = meta.structure ? JSON.stringify(C.generateOrder(meta.structure, vs)) : null;
      cfg = { verses: vs.filter(v => !meta.structure || v <= meta.structure.verses), custom: gen === JSON.stringify(n.order) ? null : n.order };
      if (!cfg.verses.length) cfg.verses = [1];
    }
    const saved = project;
    project = { cfg, marks: {}, offset: n.offset || 0 };
    rebuild();
    let lost = 0;
    for (const m of n.marks) {
      let key = m.key && keyIndex.has(m.key) ? m.key : null;
      if (!key) {
        if (m.kind === 'end' || (Math.abs(m.P - plan.TOTAL) < EPS && m.kind !== 'l')) key = 'end';
        else {
          const pool = m.kind === 'l' ? groups.filter(g => !m.voice || g.v === m.voice).flatMap(g => units(g.v, 'syl')) : mSteps;
          const hit = pool.find(s => Math.abs(s.P - m.P) < 1e-6);
          key = hit && hit.key;
        }
      }
      if (key) project.marks[key] = { t: m.t }; else lost++;
    }
    if (!Object.keys(project.marks).length && n.marks.length) { project = saved; rebuild(); throw new Error('aucun repère ne correspond à cette partition'); }
    return lost;
  }
  function exportObj() {
    const marks = Object.entries(project.marks).map(([key, m]) => {
      const st = keyIndex.get(key);
      if (!st) return null;
      const o = { key, k: st.kind, P: Math.round(st.P * 1e6) / 1e6, t: m.t };
      if (st.kind === 'm') o.m = st.m;
      if (st.kind === 'l') { o.v = st.voice; o.tx = st.tx; }
      return o;
    }).filter(Boolean).sort((a, b) => a.P - b.P || a.t - b.t);
    return {
      format: 'chorale-synchro/2', chant: chantId, title: meta.title, video: videoId,
      offset: project.offset, created: new Date().toISOString(),
      structure: project.cfg, order: plan.order, marks,
    };
  }

  // ---------- Chargement ----------
  let published = await publishedOf(chantId);
  const local = store.get(PKEY);
  rebuild();
  if (local && local.cfg && local.marks) {
    project = { cfg: C.structureConfig(meta, local.cfg), marks: local.marks, offset: local.offset || 0 };
    rebuild();
  } else if (published && published.video === videoId) {
    try { fromFile(published); toast('Synchro publiée chargée : vous pouvez la retoucher.'); } catch (e) { toast('La synchro publiée est illisible.'); }
  }
  recomputeMap();
  const pubSig = () => (published && published.video === videoId ? JSON.stringify(published.marks.map(m => [Math.round(m.P * 1e4), m.t])) : null);
  let publishedSig = pubSig();

  // ======================================================================
  // Historique (annuler / rétablir) et sauvegarde automatique
  // ======================================================================
  let history = [], future = [];
  const snapshot = () => JSON.stringify(project);
  let saveTimer;
  function afterChange(structChanged) {
    if (structChanged) rebuild();
    recomputeMap();
    clearTimeout(saveTimer);
    saveTimer = setTimeout(() => store.set(PKEY, project), 250);
    $('undoBtn').disabled = !history.length;
    $('redoBtn').disabled = !future.length;
    refreshAll();
  }
  function change(fn) {
    const before = snapshot();
    const cfgBefore = JSON.stringify(project.cfg);
    fn();
    if (snapshot() === before) return false;
    history.push(before); if (history.length > 300) history.shift();
    future = [];
    afterChange(JSON.stringify(project.cfg) !== cfgBefore);
    return true;
  }
  function restore(snap) {
    const cfgBefore = JSON.stringify(project.cfg);
    project = JSON.parse(snap);
    afterChange(JSON.stringify(project.cfg) !== cfgBefore);
    editor.set(project.cfg);
    showOffset();
  }
  function undo() { if (!history.length) return; future.push(snapshot()); restore(history.pop()); toast('Annulé', 1200); }
  function redo() { if (!future.length) return; history.push(snapshot()); restore(future.pop()); toast('Rétabli', 1200); }
  $('undoBtn').onclick = undo;
  $('redoBtn').onclick = redo;
  function refreshSaveState() {
    const cur = JSON.stringify(exportObj().marks.map(m => [Math.round(m.P * 1e4), m.t]));
    const n = Object.keys(project.marks).length;
    const el = $('saveState');
    let txt, cls = '';
    if (publishedSig && cur === publishedSig) { txt = 'Publié'; cls = 'pub'; }
    else if (!n) txt = 'Aucun repère';
    else { txt = publishedSig ? 'Modifié, non publié' : 'Enregistré · non publié'; cls = 'dirty'; }
    el.className = 'save-state ' + cls;
    $('saveTxt').textContent = txt;
  }

  // ======================================================================
  // Lecteur vidéo
  // ======================================================================
  let video = null, x0Set = false;
  if (location.protocol === 'file:') {
    $('yt').innerHTML = '<div class="msg">YouTube refuse de s\'afficher dans une page ouverte par double-clic.<br>Lancez <b>serveur-local.bat</b> puis ouvrez http://localhost:8000/synchro.html</div>';
  } else {
    video = C.youtube('yt', videoId, {
      onState: () => { updatePlayBtn(); tlDirty = true; },
      onError: e => toast(`Erreur YouTube (${e}) : vidéo introuvable ou non intégrable.`, 6000),
    });
    video.whenReady.then(() => { video.rate(+$('rate').value); tlDirty = true; if (!x0Set) zoomFit(); });
  }
  const vReady = () => video && video.ready;
  const vTime = () => (vReady() ? video.time() : 0);
  const playing = () => vReady() && video.playing();
  const togglePlay = () => { if (!vReady()) return; playing() ? video.pause() : video.play(); };
  const seekV = t => { if (vReady()) { video.seek(Math.max(0, Math.min(t, video.duration() - 0.05))); dblLast = null; tlDirty = true; } };
  const updatePlayBtn = () => { $('tPlay').innerHTML = icon(playing() ? 'pause' : 'play', 'fill'); };
  updatePlayBtn();
  $('tPlay').onclick = togglePlay;
  $('shield').onclick = togglePlay;
  $('tStart').innerHTML = icon('restart');
  $('tStart').onclick = () => seekV(tmap.anchors.length ? tmap.anchors[0].t - settings.preroll : 0);
  $('tBack').onclick = () => seekV(vTime() - 2);
  $('tFwd').onclick = () => seekV(vTime() + 2);
  $('rate').onchange = e => { if (vReady()) video.rate(+e.target.value); e.target.blur(); };
  $('vol').oninput = e => { if (vReady()) video.volume(+e.target.value); };

  // ---------- Audio analysé (forme d'onde, attaques) ----------
  let audio = null, audioState = api && api.audio ? 'loading' : 'none';
  function setAudioHint() {
    const h = $('audioHint');
    const can = !!(audio && audio.onsets && audio.onsets.length);
    $('magnet').disabled = $('magnetTl').disabled = !can;
    if (audioState === 'loading') h.textContent = 'Analyse de l’audio de la vidéo en cours…';
    else if (audioState === 'ready') h.textContent = `Audio analysé : ${audio.onsets.length} attaques détectées. L’aimant colle les repères tapés ou déplacés à l’attaque la plus proche (± 0,12 s).`;
    else if (audioState === 'error') h.textContent = 'Analyse audio impossible : ' + ((audio && audio.error) || '');
    else h.textContent = 'La forme d’onde et l’aimant demandent le studio local (serveur-local.bat) avec yt-dlp et ffmpeg.';
  }
  setAudioHint();
  if (audioState === 'loading') {
    fetchJSON(`api/audio/${videoId}/peaks`).then(d => {
      if (d && d.peaks) { audio = d; audioState = 'ready'; }
      else { audio = d; audioState = 'error'; }
      setAudioHint(); tlDirty = true;
    });
  }
  const magnetOn = () => settings.magnet && audio && audio.onsets && audio.onsets.length;
  function snap(t, win = 0.12) {
    if (!magnetOn()) return t;
    const on = audio.onsets;
    let lo = 0, hi = on.length - 1;
    while (lo < hi) { const mid = (lo + hi) >> 1; if (on[mid][0] < t) lo = mid + 1; else hi = mid; }
    let best = null;
    for (const i of [lo - 1, lo]) if (on[i] && Math.abs(on[i][0] - t) <= win && (best == null || Math.abs(on[i][0] - t) < Math.abs(best - t))) best = on[i][0];
    return best ?? t;
  }
  const setMagnet = v => { settings.magnet = !!v; $('magnet').checked = $('magnetTl').checked = settings.magnet; saveSettings(); tlDirty = true; };
  $('magnet').onchange = e => setMagnet(e.target.checked);
  $('magnetTl').onchange = e => setMagnet(e.target.checked);
  setMagnet(settings.magnet);

  // ======================================================================
  // Onglets
  // ======================================================================
  let tab = 'tap';
  let lastPaintKey = null;
  function setTab(t) {
    tab = t;
    $('tabs').querySelectorAll('button').forEach(b => b.classList.toggle('active', b.dataset.tab === t));
    document.querySelectorAll('.s-panel').forEach(p => { p.hidden = p.dataset.panel !== t; });
    lastReveal = null; lastPaintKey = null;
    paint('hl-cur', []); paint('hl-next', []); paint('hl-soft', []); paint('hl-bar', []);
    setLyClasses(new Map()); setNotesOn(new Set());
    $('legend').innerHTML = t === 'tap'
      ? '<span><i class="sw-cur"></i>dernier repère</span><span><i class="sw-next"></i>prochain repère</span>'
      : '<span><i class="sw-cur"></i>position estimée</span>';
    refreshAll();
  }
  $('tabs').onclick = e => { const b = e.target.closest('button'); if (b) setTab(b.dataset.tab); };

  // ======================================================================
  // Taper
  // ======================================================================
  let curKey = null, lastTapped = null;
  if (hasLyrics) {
    $('tapVoice').innerHTML = groups.map(g => `<option value="${g.v}">Paroles · ${esc(g.name)}</option>`).join('');
    if (!groups.some(g => g.v === settings.tapVoice)) settings.tapVoice = groups[0].v;
    $('tapVoice').value = settings.tapVoice;
  } else {
    settings.tapKind = 'm';
    const b = $('tapKind').querySelector('[data-k="l"]');
    b.disabled = true; b.title = 'Pas de paroles sur cette partition';
  }
  const tapList = () => {
    if (settings.tapKind === 'l' && hasLyrics) return [...units(settings.tapVoice, settings.tapUnit), endStep];
    return [...mSteps, endStep];
  };
  function curIndex(list = tapList()) {
    if (curKey === '__done__') return list.length;
    let i = curKey ? list.findIndex(s => s.key === curKey) : -1;
    if (i < 0 && curKey && keyIndex.get(curKey)) {
      // Repère courant d'un autre mode : on prend l'étape correspondante la plus proche
      const P = keyIndex.get(curKey).P;
      i = list.findIndex(s => s.P >= P - EPS);
    }
    if (i < 0) i = list.findIndex(s => !project.marks[s.key]);
    if (i < 0) i = list.length;
    return i;
  }
  function setTapMode(kind, unit, voice) {
    const list0 = tapList(), i0 = curIndex(list0);
    const refP = list0[i0] ? list0[i0].P : null;
    if (kind) settings.tapKind = kind;
    if (unit) settings.tapUnit = unit;
    if (voice) settings.tapVoice = voice;
    saveSettings();
    $('tapKind').querySelectorAll('button').forEach(b => b.classList.toggle('active', b.dataset.k === settings.tapKind));
    $('tapUnit').querySelectorAll('button').forEach(b => b.classList.toggle('active', b.dataset.u === settings.tapUnit));
    $('lyrOpts').hidden = settings.tapKind !== 'l';
    const list = tapList();
    if (refP != null) { const j = list.findIndex(s => s.P >= refP - EPS); curKey = j >= 0 ? list[j].key : null; }
    lastTapped = null;
    lastPaintKey = null; lastReveal = null;
    refreshAll();
  }
  $('tapKind').onclick = e => { const b = e.target.closest('button'); if (b && !b.disabled) { setTapMode(b.dataset.k); b.blur(); } };
  $('tapUnit').onclick = e => { const b = e.target.closest('button'); if (b) { setTapMode(null, b.dataset.u); b.blur(); } };
  $('tapVoice').onchange = e => { setTapMode(null, null, e.target.value); e.target.blur(); };

  function tap() {
    if (!vReady()) { toast('La vidéo n’est pas encore prête.'); return; }
    const list = tapList();
    const i = curIndex(list);
    const st = list[i];
    if (!st) { toast('Tous les repères de cette liste sont posés. Cliquez une note pour en refaire un.'); return; }
    const t = r3(snap(vTime()));
    const prev = list.slice(0, i).reverse().find(s => project.marks[s.key]);
    const next = list.slice(i + 1).find(s => project.marks[s.key]);
    change(() => { project.marks[st.key] = { t }; });
    if ((prev && project.marks[prev.key].t >= t) || (next && project.marks[next.key].t <= t)) {
      toast('Ce repère contredit ses voisins : il est ignoré tant que ce n’est pas corrigé.', 3500);
    }
    lastTapped = st.key;
    curKey = list[i + 1] ? list[i + 1].key : '__done__';
    const b = $('tapBtn'); b.classList.add('flash'); setTimeout(() => b.classList.remove('flash'), 90);
    refreshAll();
  }
  function untap() {
    const list = tapList();
    const i = curIndex(list);
    let target = lastTapped && project.marks[lastTapped] ? list.findIndex(s => s.key === lastTapped) : -1;
    if (target < 0) for (let k = Math.min(i, list.length) - 1; k >= 0; k--) if (project.marks[list[k].key]) { target = k; break; }
    const st = list[target];
    if (!st) return;
    change(() => { delete project.marks[st.key]; });
    curKey = st.key;
    lastTapped = list.slice(0, target).reverse().find(s => project.marks[s.key])?.key || null;
    refreshAll();
  }
  function setCur(i, back = true) {
    const list = tapList();
    if (!list[i]) return;
    curKey = list[i].key;
    lastTapped = list.slice(0, i).reverse().find(s => project.marks[s.key])?.key || null;
    if (back) {
      const own = project.marks[list[i].key];
      const prev = lastTapped && project.marks[lastTapped];
      const t = own ? own.t : prev ? prev.t : hasMap() ? tmap.pToV(list[i].P) : null;
      if (t != null) seekV(t - settings.preroll);
    }
    lastReveal = null;
    refreshAll();
  }
  $('tapBtn').onclick = e => { if (selKey) selectMarker(null); tap(); e.currentTarget.blur(); };
  $('undoTap').onclick = e => { untap(); e.currentTarget.blur(); };
  $('gotoMissing').onclick = e => {
    e.currentTarget.blur();
    const list = tapList();
    const i = list.findIndex(s => !project.marks[s.key]);
    if (i < 0) toast('Tous les repères de cette liste sont posés.'); else setCur(i);
  };
  $('gotoHere').onclick = e => {
    e.currentTarget.blur();
    const P = hasMap() ? tmap.vToP(vTime()) : null;
    if (P == null) { toast('Posez d’abord quelques repères.'); return; }
    const list = tapList();
    const i = list.findIndex(s => s.P >= P - 0.02);
    setCur(i < 0 ? list.length - 1 : i, false);
  };

  // Contexte du prochain repère
  function lyricLineHTML(list, i) {
    const a = Math.max(0, i - 4), b = Math.min(list.length, i + 8);
    let h = '';
    for (let k = a; k < b; k++) {
      const u = list[k];
      if (u.kind !== 'l') continue;
      const p = list[k - 1];
      const sep = k > a ? (p && p.kind === 'l' && p.last && p.last.hy && settings.tapUnit === 'syl' ? '-' : ' ') : '';
      h += sep + `<span class="${k < i ? 'done' : k === i ? 'now' : ''}">${esc(u.tx)}</span>`;
    }
    return h;
  }
  function measureWords(st) {
    if (!hasLyrics || !st || st.kind !== 'm') return '';
    const g = groups.find(x => x.v === settings.tapVoice) || groups[0];
    const out = [];
    for (const line of g.lines) for (const s of line.syl) {
      if (s.t >= st.w - EPS && s.t < st.wEnd - EPS && model.chooseLine(g, st.seg.v, s.t) === line) out.push(s);
    }
    out.sort((a, b) => a.t - b.t);
    return out.map((s, k) => esc(s.tx) + (k < out.length - 1 ? (s.hy ? '-' : ' ') : '')).join('');
  }
  function refreshCue() {
    const list = tapList();
    const i = curIndex(list);
    const st = list[i];
    const done = list.filter(s => project.marks[s.key]).length;
    $('cueCount').textContent = `${Math.min(i + 1, list.length)} / ${list.length}`;
    $('cueProg').style.width = `${done / list.length * 100}%`;
    if (!st) {
      $('cueBig').textContent = 'Terminé';
      $('cueSub').innerHTML = `${done} repères posés sur ${list.length}. Passez à l’onglet <b>Vérifier</b>.`;
      $('cueLine').innerHTML = '';
      return;
    }
    const segN = plan.segs.indexOf(st.seg) + 1;
    $('cueBig').textContent = st.kind === 'l' ? st.tx : st.kind === 'end' ? 'Fin du chant' : `Mesure ${st.m}`;
    const m = st.kind === 'l' ? model.measureAt(st.w).m : null;
    $('cueSub').innerHTML = (C.versesOfOrder(plan.order).length > 1 ? vtag(st.seg.v) + ' ' : '') +
      `passage ${segN}/${plan.segs.length}` + (m != null ? ` · mes. ${m}` : '') +
      (project.marks[st.key] ? ` · <b>déjà posé à ${fmtH(project.marks[st.key].t)}</b>` : '');
    $('cueLine').innerHTML = st.kind === 'l' ? lyricLineHTML(list, i) : st.kind === 'm' ? measureWords(st) : 'Tapez quand la dernière note s’arrête.';
  }

  // Clic sur la partition
  function nearestIn(list, pred, refIdx) {
    let best = -1;
    list.forEach((s, k) => { if (pred(s) && (best < 0 || Math.abs(k - refIdx) < Math.abs(best - refIdx))) best = k; });
    return best;
  }
  function onScoreClick(t, syl) {
    if (tab === 'tap') {
      const list = tapList();
      const ref = curIndex(list);
      let i = -1;
      if (syl && settings.tapKind === 'l') i = nearestIn(list, s => s.syl && s.syl.includes(syl), ref);
      if (i < 0) i = nearestIn(list, s => s.kind !== 'end' && t >= s.w - EPS && t < (s.wEnd ?? s.w) - EPS, ref);
      if (i < 0) i = nearestIn(list, s => s.kind !== 'end' && s.w <= t + EPS && s.seg.a <= t + EPS && t < s.seg.b, ref);
      if (i >= 0) setCur(i);
    } else {
      if (!hasMap()) { toast('Posez d’abord des repères (onglet Taper).'); return; }
      const nowP = tmap.vToP(vTime() + project.offset) ?? 0;
      let cands = plan.segs.filter(s => t >= s.a - EPS && t < s.b - EPS);
      if (syl) {
        const g = groups.find(x => x.v === syl.v);
        const ok = cands.filter(s => model.chooseLine(g, s.v, t) === syl.line);
        if (ok.length) cands = ok;
      }
      if (!cands.length) return;
      const P = cands.map(s => s.off + (t - s.a)).reduce((x, y) => (Math.abs(y - nowP) < Math.abs(x - nowP) ? y : x));
      seekV(tmap.pToV(P) - project.offset);
    }
  }
  model.notes.forEach(n => n.el.addEventListener('click', () => onScoreClick(n.t, null)));
  model.lyrics.forEach(s => s.el.addEventListener('click', e => { e.stopPropagation(); onScoreClick(s.t, s); }));

  // ======================================================================
  // Vérifier
  // ======================================================================
  const showOffset = () => { const o = project.offset; $('offVal').textContent = `${o >= 0 ? '+' : '−'}${Math.abs(o).toFixed(2).replace('.', ',')} s`; };
  showOffset();
  document.querySelectorAll('[data-off]').forEach(b => b.onclick = () => { change(() => { project.offset = r3(project.offset + +b.dataset.off); }); showOffset(); });
  $('followSeg').querySelectorAll('button').forEach(b => {
    b.classList.toggle('active', b.dataset.f === settings.follow);
    b.onclick = () => {
      settings.follow = b.dataset.f; saveSettings(); lastPaintKey = null; lastReveal = null;
      $('followSeg').querySelectorAll('button').forEach(x => x.classList.toggle('active', x === b));
      b.blur();
    };
  });
  function refreshPasses() {
    $('passList').innerHTML = plan.segs.map((s, i) => {
      const ma = model.measureAt(s.a).m, mb = model.measureAt(Math.max(s.a, s.b - 1e-3)).m;
      const t = hasMap() ? tmap.pToV(s.off) : null;
      return `<div class="pass" data-i="${i}" style="--c:${C.verseColor(s.v)}"><i></i><div><b>${esc(verseName(s.v))}</b> · mes. ${ma}–${mb}</div><span>${t != null ? fmtT(t) : '—'}</span></div>`;
    }).join('');
  }
  $('passList').onclick = e => {
    const p = e.target.closest('.pass');
    if (!p || !hasMap()) return;
    const s = plan.segs[+p.dataset.i];
    seekV(tmap.pToV(s.off) - project.offset - 0.5);
  };

  // ======================================================================
  // Structure
  // ======================================================================
  const editor = C.structureEditor($('structEditor'), {
    model, meta, cfg: project.cfg,
    duration: order => {
      const tempo = data.tempo || meta.tempo || { bpm: 80, unit: 0.25 };
      return order.reduce((s, [a, b]) => s + (b - a), 0) * 60 / tempo.bpm / tempo.unit;
    },
    onChange: c => {
      const oldSig = signatures();
      const oldMarks = project.marks;
      let lost = 0;
      change(() => {
        project.cfg = c;
        rebuild();
        const newSig = signatures();
        const bySig = new Map([...newSig].map(([k, s]) => [s, k]));
        const marks = {};
        for (const [k, m] of Object.entries(oldMarks)) {
          const nk = bySig.get(oldSig.get(k));
          if (nk) marks[nk] = m; else lost++;
        }
        project.marks = marks;
      });
      curKey = null; lastTapped = null;
      refreshAll();
      if (lost) toast(`${lost} repère${lost > 1 ? 's' : ''} hors du nouveau plan retiré${lost > 1 ? 's' : ''} (Ctrl+Z pour annuler).`, 4000);
    },
  });

  // ======================================================================
  // Réglages
  // ======================================================================
  if (hasLyrics) {
    $('lyrHl').innerHTML = `<option value="all">Toutes les voix</option>` + groups.map(g => `<option value="${g.v}">${esc(g.name)}</option>`).join('') + `<option value="off">Non</option>`;
    if (![...$('lyrHl').options].some(o => o.value === settings.lyrHl)) settings.lyrHl = 'all';
    $('lyrHl').value = settings.lyrHl;
    $('lyrHl').onchange = e => { settings.lyrHl = e.target.value; saveSettings(); lastPaintKey = null; e.target.blur(); };
  } else $('lyrHl').closest('.row2').hidden = true;
  model.voices.forEach(v => { const o = document.createElement('option'); o.value = v; o.textContent = C.VOICE_NAMES[v] || v; $('dblVoice').appendChild(o); });
  $('preroll').value = String(settings.preroll);
  $('preroll').onchange = e => { settings.preroll = +e.target.value; saveSettings(); e.target.blur(); };
  document.querySelectorAll('[data-shift]').forEach(b => b.onclick = () => {
    const d = +b.dataset.shift;
    if (!Object.keys(project.marks).length) return;
    change(() => { for (const m of Object.values(project.marks)) m.t = r3(Math.max(0, m.t + d)); });
    toast(`Tous les repères décalés de ${d > 0 ? '+' : ''}${String(d).replace('.', ',')} s`, 1500);
  });

  // Doublure au piano (vérification à l'oreille)
  let piano = null, dblLast = null, dblEvents = null;
  $('dblVoice').onchange = async e => {
    e.target.blur();
    if (!e.target.value || piano) return;
    try {
      if (!window.Tone) await C.loadScript('assets/tone.js');
      await Tone.start();
      const SAMPLES = ['A1', 'C2', 'Ds2', 'Fs2', 'A2', 'C3', 'Ds3', 'Fs3', 'A3', 'C4', 'Ds4', 'Fs4', 'A4', 'C5', 'Ds5', 'Fs5', 'A5', 'C6'];
      toast('Chargement du piano…', 0);
      await new Promise(res => {
        piano = new Tone.Sampler({
          urls: Object.fromEntries(SAMPLES.map(n => [n.replace('s', '#'), n + '.mp3'])),
          baseUrl: 'assets/piano/', release: 1, onload: res, onerror: res,
        }).toDestination();
        setTimeout(res, 8000);
      });
      $('status').classList.remove('show');
    } catch (err) { toast('Piano indisponible.'); }
  };
  function doubling(P) {
    const v = $('dblVoice').value;
    if (!piano || !v || P == null || !playing() || tab === 'tap') { dblLast = P; return; }
    if (!dblEvents || dblEvents.plan !== plan) { dblEvents = C.perfEvents(model, plan); dblEvents.plan = plan; }
    if (dblLast != null && P > dblLast && P - dblLast < 0.5) {
      const rate = video.rate();
      for (const e of dblEvents) {
        if (e.P <= dblLast || e.P > P || e.n.v !== v) continue;
        const dur = Math.max(0.08, (tmap.pToV(e.P + e.dP) - tmap.pToV(e.P)) / rate - 0.03);
        piano.triggerAttackRelease(Tone.Frequency(e.n.p, 'midi').toFrequency(), dur, Tone.now(), 0.75);
      }
    }
    dblLast = P;
  }

  // ======================================================================
  // Partition : surlignage selon l'onglet
  // ======================================================================
  function paintTap() {
    const list = tapList();
    const i = curIndex(list);
    const key = `tap|${curKey}|${lastTapped}|${settings.tapKind}|${settings.tapUnit}|${settings.tapVoice}|${plan.segs.length}|${Object.keys(project.marks).length}`;
    if (key === lastPaintKey) return;
    lastPaintKey = key;
    const next = list[i] || null;
    let prev = lastTapped ? list.find(s => s.key === lastTapped) || keyIndex.get(lastTapped) : null;
    const ly = new Map();
    if (next && next.kind === 'l') { next.syl.forEach(s => ly.set(s.el, 'cue-next')); paint('hl-next', sylRects(next.syl)); }
    else paint('hl-next', next && next.kind === 'm' ? rangeRects(next.w, next.wEnd) : []);
    if (prev && prev.kind === 'l') { prev.syl.forEach(s => ly.set(s.el, 'cue-last')); paint('hl-cur', []); }
    else paint('hl-cur', prev && prev.kind === 'm' ? rangeRects(prev.w, prev.wEnd) : []);
    setLyClasses(ly);
    paint('hl-soft', []); paint('hl-bar', []);
    setNotesOn(new Set());
    if (next) reveal('n' + next.key, 'hl-next'); else if (prev) reveal('p' + prev.key, 'hl-cur');
  }
  function paintFollow(P) {
    if (P == null || P >= plan.TOTAL - EPS) {
      if (lastPaintKey !== 'none') { paint('hl-cur', []); paint('hl-soft', []); paint('hl-bar', []); setLyClasses(new Map()); setNotesOn(new Set()); lastPaintKey = 'none'; }
      return null;
    }
    const seg = plan.segAt(P);
    const w = Math.min(plan.toWritten(P), END - EPS);
    const st = mSteps.reduce((a, s) => (s.P <= P + EPS ? s : a), mSteps[0]);
    paint('hl-next', []);
    if (settings.follow === 'measure') {
      paint('hl-cur', rangeRects(st.w, st.wEnd)); paint('hl-soft', []); paint('hl-bar', []);
      setNotesOn(new Set());
    } else {
      paint('hl-cur', []);
      paint('hl-soft', rangeRects(st.w, st.wEnd));
      const s = model.systemAt(w), x = model.xAt(s, w);
      paint('hl-bar', [{ page: s.page, x: x - 1, y: s.minY - 9, w: 2, h: sysBottom(s) - s.minY + 14 }]);
      const on = new Set();
      for (const n of model.notes) if (w >= n.t - EPS && w < n.t + n.d - EPS) on.add(n.el);
      setNotesOn(on);
    }
    const ly = new Map();
    const syls = settings.lyrHl === 'off' ? [] : model.lyricsAt(w, seg.v, settings.lyrHl === 'all' ? null : v => v === settings.lyrHl);
    syls.forEach(s => ly.set(s.el, 'on'));
    setLyClasses(ly);
    lastPaintKey = 'follow';
    reveal('f' + st.key, settings.follow === 'measure' ? 'hl-cur' : 'hl-soft');
    return { seg, w, st, syls };
  }
  let lastCheck = '';
  function refreshCheck(info) {
    let big, verse = '', sub = '', line = '';
    if (!hasMap()) { big = 'Pas encore de repères'; sub = 'Posez des repères dans l’onglet Taper.'; }
    else if (!info) { big = tmap.vToP(vTime() + project.offset) == null ? 'Avant le début' : 'Fin'; }
    else {
      big = `Mesure ${info.st.m}`;
      verse = vtag(info.seg.v);
      sub = `passage ${plan.segs.indexOf(info.seg) + 1}/${plan.segs.length}`;
      if (hasLyrics) {
        // Voix choisie pour taper si elle chante sur cette ligne, sinon la première qui chante
        const sys = model.systemAt(info.w);
        const sylOf = g => {
          const ln = model.chooseLine(g, info.seg.v, info.w);
          return ln ? ln.syl.filter(s => s.t >= sys.t0 - EPS && s.t < sys.t1 - EPS) : [];
        };
        const pref = groups.find(x => x.v === settings.tapVoice);
        let syl = pref ? sylOf(pref) : [];
        for (const g of groups) { if (syl.length) break; syl = sylOf(g); }
        if (syl.length) {
          line = syl.map((s, k) => `<span class="${info.w >= s.tEnd - EPS ? 'done' : info.w >= s.t - EPS ? 'now' : ''}">${esc(s.tx)}</span>` + (k < syl.length - 1 ? (s.hy ? '-' : ' ') : '')).join('');
        }
      }
    }
    const k = big + verse + sub + line;
    if (k === lastCheck) return;
    lastCheck = k;
    $('chkBig').textContent = big; $('chkVerse').innerHTML = verse; $('chkSub').textContent = sub; $('chkLine').innerHTML = line;
  }

  // ======================================================================
  // Frise (canvas)
  // ======================================================================
  const cv = $('tl'), g2 = cv.getContext('2d'), wrap = $('tlWrap'), tip = $('tlTip');
  const GUT = 96;
  let W = 0, H = 0, x0 = 0;
  let pps = settings.pps;
  let selKey = null, hoverKey = null, drag = null;
  let colors = {};
  function readColors() {
    const cs = getComputedStyle(document.body);
    const v = n => cs.getPropertyValue(n).trim();
    colors = { ink: v('--ink'), ink2: v('--ink-2'), muted: v('--muted'), line: v('--line'), lineS: v('--line-strong'), surface: v('--surface'), bg: v('--bg'), red: v('--red') };
    tlDirty = true;
  }
  readColors();
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', readColors);
  function resizeTl() {
    const r = wrap.getBoundingClientRect();
    const dpr = devicePixelRatio || 1;
    W = r.width; H = r.height;
    cv.width = Math.round(W * dpr); cv.height = Math.round(H * dpr);
    g2.setTransform(dpr, 0, 0, dpr, 0, 0);
    tlDirty = true;
  }
  new ResizeObserver(resizeTl).observe(wrap);
  const tToX = t => GUT + (t - x0) * pps;
  const xToT = x => x0 + (x - GUT) / pps;
  const PPS_MIN = 1.5, PPS_MAX = 900;
  const ppsToRange = p => Math.round(1000 * Math.log(p / PPS_MIN) / Math.log(PPS_MAX / PPS_MIN));
  const rangeToPps = r => PPS_MIN * Math.pow(PPS_MAX / PPS_MIN, r / 1000);
  function setZoom(p, anchorX = GUT + (W - GUT) / 2) {
    const t = xToT(anchorX);
    pps = Math.max(PPS_MIN, Math.min(PPS_MAX, p));
    x0 = Math.max(-2, t - (anchorX - GUT) / pps);
    x0Set = true;
    settings.pps = pps; saveSettings();
    $('zoomRange').value = ppsToRange(pps);
    tlDirty = true;
  }
  function zoomFit() {
    const ts = markerList.map(m => m.t);
    const dur = vReady() ? video.duration() : 0;
    let a = 0, b = dur || 60;
    if (ts.length > 1 && ts[ts.length - 1] - ts[0] > 5) { a = Math.max(0, ts[0] - 3); b = ts[ts.length - 1] + 3; }
    pps = Math.max(PPS_MIN, Math.min(PPS_MAX, (W - GUT - 10) / Math.max(1, b - a)));
    x0 = a; x0Set = true;
    $('zoomRange').value = ppsToRange(pps);
    settings.pps = pps; saveSettings();
    tlDirty = true;
  }
  const playheadAnchor = () => { const x = tToX(vTime()); return x > GUT && x < W ? x : GUT + (W - GUT) / 2; };
  $('zoomRange').value = ppsToRange(pps);
  $('zoomRange').oninput = e => setZoom(rangeToPps(+e.target.value), playheadAnchor());
  $('zoomIn').onclick = () => setZoom(pps * 1.6, playheadAnchor());
  $('zoomOut').onclick = () => setZoom(pps / 1.6, playheadAnchor());
  $('zoomFit').onclick = zoomFit;
  $('followTl').checked = settings.followTl;
  $('followTl').onchange = e => { settings.followTl = e.target.checked; saveSettings(); };

  // Pistes
  function tracks() {
    const out = [
      { id: 'ruler', h: 24 },
      { id: 'plan', h: 22, name: 'Passages' },
      { id: 'audio', h: 52, name: 'Audio' },
      { id: 'm', h: 36, name: 'Mesures' },
    ];
    groups.filter(g => markerList.some(m => m.voice === g.v) || (settings.tapKind === 'l' && settings.tapVoice === g.v))
      .forEach(g => out.push({ id: 'l:' + g.v, h: 36, name: 'Paroles ' + g.v, voice: g.v }));
    const fixed = out.reduce((s, t) => s + t.h, 0);
    if (fixed > H) out[2].h = Math.max(20, out[2].h - (fixed - H));
    let y = 0;
    out.forEach(t => { t.y = y; y += t.h; });
    return out;
  }
  const trackOf = m => (m.kind === 'l' ? 'l:' + m.voice : 'm');
  function rulerStep() {
    for (const s of [0.1, 0.2, 0.5, 1, 2, 5, 10, 15, 30, 60, 120]) if (s * pps >= 64) return s;
    return 300;
  }
  function draw() {
    tlDirty = false;
    const g = g2;
    g.clearRect(0, 0, W, H);
    g.fillStyle = colors.surface; g.fillRect(0, 0, W, H);
    const T = tracks();
    const tStart = xToT(GUT), tEnd = xToT(W);
    g.font = '11px Inter, system-ui, sans-serif';
    g.textBaseline = 'middle';
    T.forEach((tr, i) => {
      if (tr.id !== 'ruler' && i % 2 === 0) { g.fillStyle = colors.bg; g.globalAlpha = 0.55; g.fillRect(GUT, tr.y, W - GUT, tr.h); g.globalAlpha = 1; }
      g.strokeStyle = colors.line; g.beginPath(); g.moveTo(0, tr.y + tr.h - 0.5); g.lineTo(W, tr.y + tr.h - 0.5); g.stroke();
    });
    // Règle
    const step = rulerStep();
    g.fillStyle = colors.muted; g.strokeStyle = colors.lineS;
    for (let t = Math.floor(tStart / step) * step; t <= tEnd; t += step) {
      if (t < -1e-9) continue;
      const x = Math.round(tToX(t)) + 0.5;
      g.beginPath(); g.moveTo(x, 14); g.lineTo(x, 24); g.stroke();
      g.fillText(step < 1 ? fmtT(t) : C.fmt(t), x + 3, 9);
      for (let k = 1; k < 5; k++) {
        const xs = Math.round(tToX(t + step * k / 5)) + 0.5;
        g.beginPath(); g.moveTo(xs, 19); g.lineTo(xs, 24); g.stroke();
      }
    }
    const dur = vReady() ? video.duration() : 0;
    if (dur) { const xe = tToX(dur); if (xe < W) { g.fillStyle = colors.bg; g.fillRect(Math.max(GUT, xe), 24, W - Math.max(GUT, xe), H); } }
    // Passages
    const plT = T.find(t => t.id === 'plan');
    if (hasMap()) {
      plan.segs.forEach((s, i) => {
        const a = tmap.pToV(s.off), b = tmap.pToV(s.off + s.b - s.a);
        const xa = Math.max(GUT, tToX(a)), xb = Math.min(W, tToX(b));
        if (xb <= GUT || xa >= W) return;
        g.fillStyle = C.verseColor(s.v); g.globalAlpha = 0.16; g.fillRect(xa, plT.y + 3, xb - xa - 1, plT.h - 6); g.globalAlpha = 1;
        g.fillRect(xa, plT.y + 3, 2, plT.h - 6);
        g.save(); g.beginPath(); g.rect(xa, plT.y, Math.max(0, xb - xa - 2), plT.h); g.clip();
        g.fillStyle = colors.ink2; g.fillText(`${i + 1}. ${verseName(s.v)}`, xa + 6, plT.y + plT.h / 2);
        g.restore();
      });
    }
    // Audio
    const au = T.find(t => t.id === 'audio');
    const mid = au.y + au.h / 2;
    if (audio && audio.peaks) {
      const pk = audio.peaks, rate = audio.rate;
      g.fillStyle = colors.muted; g.globalAlpha = 0.6;
      for (let x = GUT; x < W; x++) {
        const a = Math.max(0, Math.floor(xToT(x) * rate)), b = Math.max(a + 1, Math.floor(xToT(x + 1) * rate));
        if (a >= pk.length) break;
        if (xToT(x + 1) < 0) continue;
        let m = 0;
        for (let k = a; k < b && k < pk.length; k++) if (pk[k] > m) m = pk[k];
        const h = m / 255 * (au.h / 2 - 3);
        g.fillRect(x, mid - h, 1, Math.max(1, h * 2));
      }
      g.globalAlpha = 1;
      if (pps > 50 && audio.onsets) {
        g.strokeStyle = magnetOn() ? colors.red : colors.ink2; g.globalAlpha = magnetOn() ? 0.6 : 0.28;
        for (const [t, s] of audio.onsets) {
          if (t < tStart || t > tEnd) continue;
          const x = Math.round(tToX(t)) + 0.5;
          g.beginPath(); g.moveTo(x, au.y + 2); g.lineTo(x, au.y + 4 + s * 8); g.stroke();
        }
        g.globalAlpha = 1;
      }
    } else {
      g.fillStyle = colors.muted;
      g.fillText(audioState === 'loading' ? 'Analyse de l’audio…' : audioState === 'error' ? 'Audio indisponible' : 'Forme d’onde : studio local requis', GUT + 10, mid);
    }
    // Repère attendu (onglet Taper)
    if (tab === 'tap' && hasMap()) {
      const list = tapList(), st = list[curIndex(list)];
      if (st && !project.marks[st.key]) {
        const tr = T.find(t => t.id === (st.kind === 'l' ? 'l:' + st.voice : 'm'));
        const t = tmap.pToV(st.P);
        if (tr && t != null) {
          const x = Math.round(tToX(t)) + 0.5;
          g.setLineDash([3, 3]); g.strokeStyle = colors.red; g.globalAlpha = 0.6;
          g.beginPath(); g.moveTo(x, tr.y + 2); g.lineTo(x, tr.y + tr.h - 2); g.stroke();
          g.setLineDash([]); g.globalAlpha = 1;
        }
      }
    }
    // Repères
    const lastLabel = {};
    const drawMarker = m => {
      const tr = T.find(t => t.id === trackOf(m));
      if (!tr) return;
      const x = Math.round(tToX(m.t)) + 0.5;
      if (x < GUT - 60 || x > W + 2) return;
      const selected = m.key === selKey, hov = m.key === hoverKey;
      const col = m.bad ? '#d97706' : m.color;
      g.strokeStyle = col;
      g.lineWidth = selected ? 2 : 1;
      if (m.bad) g.setLineDash([2, 2]);
      g.beginPath(); g.moveTo(x, tr.y + 2); g.lineTo(x, tr.y + tr.h - 2); g.stroke();
      g.setLineDash([]); g.lineWidth = 1;
      const tw = g.measureText(m.label).width + 8;
      if (selected || hov || x > (lastLabel[tr.id] ?? -1e9)) {
        const lx = x + 1, ly = tr.y + 4;
        g.fillStyle = selected ? col : colors.surface;
        g.fillRect(lx, ly, tw, 15);
        if (!selected) { g.strokeStyle = col; g.strokeRect(lx + 0.5, ly + 0.5, tw - 1, 14); }
        g.fillStyle = selected ? '#fff' : m.bad ? '#b45309' : colors.ink;
        g.fillText(m.label, lx + 4, ly + 8);
        if (!selected && !hov) lastLabel[tr.id] = x + tw + 2;
      }
    };
    markerList.forEach(m => { if (m.key !== selKey && m.key !== hoverKey) drawMarker(m); });
    markerList.forEach(m => { if (m.key === selKey || m.key === hoverKey) drawMarker(m); });
    // Tête de lecture
    const ph = tToX(vTime());
    if (ph >= GUT && ph <= W) {
      g.strokeStyle = colors.red; g.lineWidth = 1.5;
      g.beginPath(); g.moveTo(ph, 4); g.lineTo(ph, H); g.stroke(); g.lineWidth = 1;
      g.fillStyle = colors.red;
      g.beginPath(); g.moveTo(ph - 5, 3); g.lineTo(ph + 5, 3); g.lineTo(ph, 10); g.closePath(); g.fill();
    }
    // Colonne des noms
    g.fillStyle = colors.surface; g.fillRect(0, 0, GUT, H);
    g.strokeStyle = colors.line; g.beginPath(); g.moveTo(GUT - 0.5, 0); g.lineTo(GUT - 0.5, H); g.stroke();
    g.font = '600 11px Inter, system-ui, sans-serif';
    T.forEach(tr => {
      if (!tr.name) return;
      g.fillStyle = tr.voice && tr.voice === settings.tapVoice && settings.tapKind === 'l' ? colors.red : colors.ink2;
      g.fillText(tr.name, 10, tr.y + tr.h / 2);
    });
    g.fillStyle = colors.ink; g.font = '600 11.5px Inter, system-ui, sans-serif';
    g.fillText(fmtH(vTime()), 10, 12);
  }

  // Interactions de la frise
  function hit(x, y) {
    const T = tracks();
    const tr = T.find(t => y >= t.y && y < t.y + t.h);
    if (!tr) return { type: 'none' };
    if (tr.id === 'ruler') return { type: 'ruler' };
    if (x < GUT) return { type: 'gutter', tr };
    if (tr.id === 'm' || tr.id.startsWith('l:')) {
      let best = null, bd = 7;
      for (const m of markerList) {
        if (trackOf(m) !== tr.id) continue;
        const d = Math.abs(tToX(m.t) - x);
        if (d < bd || (d === bd && m.key === selKey)) { best = m; bd = d; }
      }
      if (best) return { type: 'marker', m: best, tr };
    }
    return { type: 'track', tr };
  }
  function selectMarker(key) {
    selKey = key; tlDirty = true;
    refreshSel();
  }
  function refreshSel() {
    const box = $('tlSel');
    const m = selKey && project.marks[selKey];
    const st = selKey && keyIndex.get(selKey);
    if (!m || !st) {
      selKey = null;
      box.innerHTML = '<span>Cliquez un repère pour le sélectionner · glissez-le pour le déplacer</span>';
      return;
    }
    const bad = tmap.rejected.has(selKey);
    const what = st.kind === 'm' ? `Mesure ${st.m}` : st.kind === 'end' ? 'Fin du chant' : `« ${esc(st.tx)} »`;
    box.innerHTML = `${bad ? '<span style="color:#b45309" title="Ce repère contredit ses voisins : il est ignoré">⚠ ignoré</span>' : ''}<b>${what}</b>${vtag(st.seg.v)}<span>${fmtH(m.t)}</span>` +
      `<span class="stepper"><button data-nudge="-0.1" title="Maj + ,">−0,1</button><button data-nudge="-0.01" title=",">−0,01</button><button data-nudge="0.01" title=".">+0,01</button><button data-nudge="0.1" title="Maj + .">+0,1</button></span>` +
      `<button class="tb-icon" data-del title="Supprimer (Suppr)">✕</button><span class="kbh"><kbd>←</kbd><kbd>→</kbd> décaler · <kbd>Échap</kbd></span>`;
  }
  $('tlSel').onclick = e => {
    const b = e.target.closest('button');
    if (!b || !selKey) return;
    if (b.dataset.nudge) nudge(+b.dataset.nudge);
    if ('del' in b.dataset) delSel();
  };
  function nudge(d) {
    if (!selKey || !project.marks[selKey]) return;
    const k = selKey;
    change(() => { project.marks[k].t = r3(Math.max(0, project.marks[k].t + d)); });
    seekV(project.marks[k].t - Math.min(1.5, settings.preroll));
    refreshSel();
  }
  function delSel() {
    if (!selKey || !project.marks[selKey]) return;
    const k = selKey;
    change(() => { delete project.marks[k]; });
    selKey = null; refreshSel();
  }
  let scrubbing = false, lastScrub = 0;
  cv.addEventListener('pointerdown', e => {
    const r = cv.getBoundingClientRect(), x = e.clientX - r.left, y = e.clientY - r.top;
    const h = hit(x, y);
    cv.setPointerCapture(e.pointerId);
    if (h.type === 'marker') {
      selectMarker(h.m.key);
      drag = { key: h.m.key, x, t0: project.marks[h.m.key].t, moved: false, before: snapshot() };
    } else if (h.type === 'ruler' || h.type === 'track') {
      scrubbing = true; seekV(xToT(x));
      if (h.type === 'track') selectMarker(null);
    }
  });
  cv.addEventListener('pointermove', e => {
    const r = cv.getBoundingClientRect(), x = e.clientX - r.left, y = e.clientY - r.top;
    if (drag) {
      if (Math.abs(x - drag.x) > 3) drag.moved = true;
      if (drag.moved) {
        let t = Math.max(0, drag.t0 + (x - drag.x) / pps);
        if (!e.altKey) t = snap(t, Math.max(0.03, 8 / pps));
        project.marks[drag.key].t = r3(t);
        recomputeMap(); refreshSel();
        showTip(x, y, fmtH(t));
      }
      return;
    }
    if (scrubbing) {
      const now = performance.now();
      if (now - lastScrub > 70) { lastScrub = now; seekV(xToT(x)); }
      return;
    }
    const h = hit(x, y);
    const k = h.type === 'marker' ? h.m.key : null;
    if (k !== hoverKey) { hoverKey = k; tlDirty = true; }
    cv.style.cursor = h.type === 'marker' ? 'ew-resize' : h.type === 'ruler' || h.type === 'track' ? 'text' : 'default';
    if (h.type === 'marker') {
      const st = h.m.st;
      showTip(tToX(h.m.t), h.tr.y, `${st.kind === 'm' ? 'Mesure ' + st.m : st.kind === 'end' ? 'Fin' : '« ' + st.tx + ' »'} · ${verseName(st.seg.v)} · ${fmtH(h.m.t)}${h.m.bad ? ' · ignoré (incohérent)' : ''}`);
    } else hideTip();
  });
  const endDrag = e => {
    if (drag) {
      const d = drag;
      drag = null; hideTip();
      if (d.moved) {
        history.push(d.before); future = [];
        afterChange(false);
        seekV(project.marks[d.key].t - 1);
      } else seekV(project.marks[d.key].t);
    }
    if (scrubbing) { scrubbing = false; const r = cv.getBoundingClientRect(); seekV(xToT(e.clientX - r.left)); }
  };
  cv.addEventListener('pointerup', endDrag);
  cv.addEventListener('pointercancel', endDrag);
  cv.addEventListener('pointerleave', () => { if (!drag) { hoverKey = null; hideTip(); tlDirty = true; } });
  cv.addEventListener('dblclick', e => {
    const r = cv.getBoundingClientRect();
    const h = hit(e.clientX - r.left, e.clientY - r.top);
    if (h.type === 'marker') { seekV(h.m.t - settings.preroll); if (vReady()) video.play(); }
  });
  cv.addEventListener('wheel', e => {
    e.preventDefault();
    const r = cv.getBoundingClientRect(), x = e.clientX - r.left;
    if (e.ctrlKey || e.metaKey) setZoom(pps * Math.exp(-e.deltaY * 0.0018), Math.max(GUT, x));
    else { x0 = Math.max(-2, x0 + (Math.abs(e.deltaX) > Math.abs(e.deltaY) ? e.deltaX : e.deltaY) / pps); x0Set = true; tlDirty = true; }
  }, { passive: false });
  function showTip(x, y, txt) { tip.textContent = txt; tip.style.left = `${Math.min(Math.max(x, 90), W - 90)}px`; tip.style.top = `${Math.max(16, y)}px`; tip.classList.add('show'); }
  function hideTip() { tip.classList.remove('show'); }
  const setTlH = h => { settings.tlH = Math.max(150, Math.min(innerHeight * 0.6, h)); document.body.style.setProperty('--tl-h', settings.tlH + 'px'); };
  setTlH(settings.tlH);
  $('tlResize').addEventListener('pointerdown', e => {
    e.preventDefault();
    const y0 = e.clientY, h0 = settings.tlH;
    const mv = ev => setTlH(h0 + (y0 - ev.clientY));
    const up = () => { removeEventListener('pointermove', mv); removeEventListener('pointerup', up); saveSettings(); };
    addEventListener('pointermove', mv); addEventListener('pointerup', up);
  });

  // ======================================================================
  // Fichier et publication
  // ======================================================================
  const menu = $('fileMenu');
  $('fileBtn').onclick = e => { e.stopPropagation(); menu.hidden = !menu.hidden; };
  document.addEventListener('pointerdown', e => { if (!menu.hidden && !menu.contains(e.target) && e.target !== $('fileBtn')) menu.hidden = true; });
  function download() {
    const blob = new Blob([JSON.stringify(exportObj(), null, 1)], { type: 'application/json' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = `${chantId}.${videoId}.synchro.json`;
    a.click();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
  }
  function loadObj(obj, label) {
    if (obj.chant && obj.chant !== chantId) { toast(`Ce fichier concerne un autre chant (${obj.chant}).`, 4000); return; }
    const before = snapshot();
    try {
      const lost = fromFile(obj);
      history.push(before); future = [];
      curKey = null; lastTapped = null;
      afterChange(true);
      editor.set(project.cfg); showOffset();
      toast(`${label} chargé${lost ? ` (${lost} repère${lost > 1 ? 's' : ''} non reconnu${lost > 1 ? 's' : ''})` : ''}.` + (obj.video && obj.video !== videoId ? ' Attention : il a été fait pour une autre vidéo.' : ''), 4000);
    } catch (err) { toast('Fichier refusé : ' + err.message, 4000); }
  }
  menu.onclick = async e => {
    const b = e.target.closest('button');
    if (!b) return;
    menu.hidden = true;
    const act = b.dataset.act;
    if (act === 'download') download();
    if (act === 'import') $('importFile').click();
    if (act === 'published') {
      published = await publishedOf(chantId, true);
      if (!published) toast('Aucune synchro publiée pour ce chant.');
      else loadObj(published, 'Version publiée');
      publishedSig = pubSig(); refreshSaveState();
    }
    if (act === 'listen') window.open(`chant.html?c=${encodeURIComponent(chantId)}`, '_blank');
    if (act === 'clear') {
      if (!Object.keys(project.marks).length || !confirm('Effacer tous les repères de cette vidéo ? (Ctrl+Z permet d’annuler)')) return;
      change(() => { project.marks = {}; }); curKey = null; lastTapped = null; refreshAll();
    }
    if (act === 'unpublish') {
      if (!api || !api.publish) { toast('Retirer une synchro demande le studio local : supprimez le fichier synchro.json du chant.', 5000); return; }
      if (!confirm('Retirer la synchro publiée de ce chant ? Le site ne proposera plus « Écouter le chœur ».')) return;
      const r = await fetch(`api/publish/${chantId}`, { method: 'DELETE' }).then(x => x.json()).catch(() => ({ error: 'serveur injoignable' }));
      if (r.ok) { published = null; publishedSig = null; refreshSaveState(); toast('Synchro retirée du site (une copie est archivée).', 4000); }
      else toast('Échec : ' + r.error, 5000);
    }
  };
  $('importFile').onchange = async e => {
    const f = e.target.files[0]; e.target.value = '';
    if (!f) return;
    try { loadObj(JSON.parse(await f.text()), 'Fichier'); } catch (err) { toast('Fichier illisible.'); }
  };
  $('publishBtn').onclick = async () => {
    const obj = exportObj();
    if (obj.marks.length < 2) { toast('Il faut au moins deux repères pour publier.'); return; }
    if (tmap.rejected.size && !confirm(`${tmap.rejected.size} repère(s) incohérent(s) seront ignorés. Publier quand même ?`)) return;
    if (!api || !api.publish) {
      download();
      toast('Fichier téléchargé. Pour publier directement, fermez ce serveur et lancez site/serveur-local.bat (sinon : renommez le fichier synchro.json et placez-le dans site/chants/' + chantId + '/).', 9000);
      return;
    }
    const r = await fetch('api/publish', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ chant: chantId, data: obj }) })
      .then(x => x.json()).catch(() => ({ error: 'serveur injoignable' }));
    if (r.ok) {
      published = obj; publishedSig = pubSig(); refreshSaveState();
      toast('Publié ! Le chant propose maintenant « Écouter le chœur ».', 4000);
    } else toast('Échec de la publication : ' + r.error, 6000);
  };

  // Aide
  $('helpBtn').onclick = () => { $('helpModal').hidden = false; };
  $('helpModal').onclick = e => { if (e.target === $('helpModal') || 'close' in e.target.dataset) $('helpModal').hidden = true; };

  // ======================================================================
  // Clavier
  // ======================================================================
  addEventListener('keydown', e => {
    const ae = document.activeElement;
    if (/INPUT|SELECT|TEXTAREA/.test(ae.tagName) && !(ae.tagName === 'INPUT' && /range|checkbox/.test(ae.type))) return;
    if (!$('helpModal').hidden) { if (e.key === 'Escape') $('helpModal').hidden = true; return; }
    const k = e.key, ctrl = e.ctrlKey || e.metaKey;
    if (ctrl && (k === 'z' || k === 'Z')) { e.preventDefault(); e.shiftKey ? redo() : undo(); return; }
    if (ctrl && (k === 'y' || k === 'Y')) { e.preventDefault(); redo(); return; }
    if (ctrl || e.altKey) return;
    if (k === ' ') { e.preventDefault(); togglePlay(); return; }
    if (k === 'j' || k === 'J') { seekV(vTime() - (e.shiftKey ? 5 : 2)); return; }
    if (k === 'l' || k === 'L') { seekV(vTime() + (e.shiftKey ? 5 : 2)); return; }
    if (k === 'k' || k === 'K') { togglePlay(); return; }
    if (k === 'Home') { e.preventDefault(); $('tStart').click(); return; }
    if (k === '?') { $('helpModal').hidden = false; return; }
    if (k === 't' || k === 'T') { setTab('tap'); return; }
    if (k === 'v' || k === 'V') { setTab('check'); return; }
    if (k === 'f' || k === 'F') { $('followTl').click(); return; }
    if ((k === 'm' || k === 'M') && !$('magnet').disabled) { setMagnet(!settings.magnet); toast(`Aimant ${settings.magnet ? 'activé' : 'désactivé'}`, 1200); return; }
    if (k === '+' || k === '=') { setZoom(pps * 1.6, playheadAnchor()); return; }
    if (k === '-' || k === '_') { setZoom(pps / 1.6, playheadAnchor()); return; }
    if (k === 'Escape') { selectMarker(null); return; }
    // Repère sélectionné : les flèches (et , .) le décalent ; Échap rend les flèches à la frappe
    if (selKey && (k === 'ArrowLeft' || k === 'ArrowRight')) { e.preventDefault(); nudge((k === 'ArrowLeft' ? -1 : 1) * (e.shiftKey ? 0.1 : 0.01)); return; }
    if (selKey && (k === ',' || k === '<')) { nudge(e.shiftKey || k === '<' ? -0.1 : -0.01); return; }
    if (selKey && (k === '.' || k === '>')) { nudge(e.shiftKey || k === '>' ? 0.1 : 0.01); return; }
    if (k === 'Delete' && selKey) { e.preventDefault(); delSel(); return; }
    if (e.shiftKey && (k === 'ArrowLeft' || k === 'ArrowRight')) { e.preventDefault(); seekV(vTime() + (k === 'ArrowLeft' ? -5 : 5)); return; }
    if (tab === 'tap') {
      if (k === 'ArrowRight' || k === 'Enter') { e.preventDefault(); if (selKey) selectMarker(null); if (!e.repeat) tap(); return; }
      if (k === 'ArrowLeft') { e.preventDefault(); untap(); return; }
      if (k === 'Backspace') { e.preventDefault(); if (selKey) delSel(); else untap(); return; }
      if (k === '1') { setTapMode('m'); return; }
      if (k === '2' && hasLyrics) { setTapMode('l'); return; }
    } else if (k === 'Backspace' && selKey) { e.preventDefault(); delSel(); }
    else if (k === 'ArrowLeft' || k === 'ArrowRight') {
      e.preventDefault();
      if (!hasMap()) return;
      const P = tmap.vToP(vTime() + project.offset);
      let i = P == null ? 0 : mSteps.reduce((a, s, j) => (s.P <= P + EPS ? j : a), 0);
      if (k === 'ArrowRight') i++;
      else if (P != null && P - mSteps[i].P < 0.08) i--;
      i = Math.max(0, Math.min(mSteps.length - 1, i));
      seekV(tmap.pToV(mSteps[i].P) - project.offset);
    }
  });
  addEventListener('blur', () => setTimeout(() => {
    if (document.activeElement && document.activeElement.tagName === 'IFRAME') toast('Cliquez sur la partition pour retrouver les raccourcis clavier.', 3000);
  }, 0));

  // ======================================================================
  // Boucle d'affichage
  // ======================================================================
  function refreshAll() {
    refreshCue(); refreshPasses(); refreshSel(); refreshSaveState();
    lastPaintKey = null; lastCheck = ''; tlDirty = true;
  }
  let lastClock = '', lastV = -1;
  function frame() {
    requestAnimationFrame(frame);
    const v = vTime();
    if (v !== lastV) { lastV = v; tlDirty = true; }
    const c = fmtT(v) + '|' + (vReady() ? video.duration() : 0);
    if (c !== lastClock) { lastClock = c; $('clock').innerHTML = `${fmtT(v)}<small>/ ${fmtT(vReady() ? video.duration() : 0)}</small>`; }
    if (tab === 'tap') { paintTap(); dblLast = null; }
    else {
      const P = hasMap() ? tmap.vToP(v + project.offset) : null;
      const info = paintFollow(P);
      if (tab === 'check') refreshCheck(info);
      doubling(P);
    }
    if (playing()) {
      tlDirty = true;
      if (settings.followTl && !drag && !scrubbing) {
        const x = tToX(v);
        if (x > W - 60 || x < GUT) { x0 = v - (W - GUT) * 0.15 / pps; }
      }
    }
    if (tlDirty && W) draw();
  }

  setTapMode(settings.tapKind);
  setTab(Object.keys(project.marks).length ? 'tap' : 'struct');
  requestAnimationFrame(frame);
  // Accès pour les tests automatiques
  window.__studio = { project: () => project, plan: () => plan, tmap: () => tmap, tap, untap, setTab, setTapMode, exportObj, keyIndex: () => keyIndex, tapList, curIndex: () => curIndex() };
})();
