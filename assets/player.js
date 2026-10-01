/* Lecteur de partition : lecture synchronisée voix par voix (piano)
   ou sur l'enregistrement original, couplets au choix, paroles surlignées. */
(async () => {
  const C = window.Chorale;
  const { EPS, store, fmt } = C;
  const $ = id => document.getElementById(id);
  const VOICE_NAMES = C.VOICE_NAMES;
  const SHORT = { S: 'Sop.', A: 'Alto', T: 'Tén.', B: 'Bas.', Solo: 'Solo' };
  const toast = C.toaster($('status'));
  const status = $('status');

  // ---------- Chant demandé ----------
  const qs = new URLSearchParams(location.search);
  const id = qs.get('c');
  const meta = (window.CHANTS || []).find(s => s.id === id);
  $('backBtn').innerHTML = icon('back') + '<span class="lbl">Chants</span>';
  if (!meta) {
    $('scoreInner').innerHTML = '<div class="loading">Chant introuvable. <a href="index.html" style="color:var(--red)">Retour à la liste</a></div>';
    return;
  }
  document.title = `${meta.title} — Chorale Scouts d'Europe Lyon 2026`;
  $('title').textContent = meta.title;
  $('authors').textContent = meta.authors || '';
  $('pdfBtn').href = `chants/${id}/${id}.pdf`;
  $('pdfBtn').innerHTML = icon('download') + '<span class="lbl">Partition PDF</span>';

  // Enregistrement original : uniquement si chants/<id>/synchro.json existe (site hébergé)
  const syncLoad = location.protocol === 'file:' || meta.video === false ? Promise.resolve(null)
    : fetch(`chants/${id}/synchro.json`, { cache: 'no-cache' }).then(r => (r.ok ? r.json() : null)).catch(() => null);
  await C.loadScript(`chants/${id}/data.js`).catch(() => null);
  const data = window.CHANT;
  if (!data) { $('scoreInner').innerHTML = '<div class="loading">Impossible de charger la partition.</div>'; return; }

  // ---------- Partition ----------
  const scroller = $('score');
  const score = $('scoreInner');
  const ZOOMS = [0.6, 0.75, 0.9, 1, 1.25, 1.5, 1.75, 2, 2.5];
  let zoom = store.get('chorale.zoom');
  if (!ZOOMS.includes(zoom)) zoom = innerWidth < 700 ? 1.75 : 1;
  const applyZoom = () => {
    score.style.setProperty('--zoom', zoom);
    $('zVal').textContent = `${Math.round(zoom * 100)} %`;
    store.set('chorale.zoom', zoom);
  };
  $('zMinus').innerHTML = icon('minus'); $('zPlus').innerHTML = icon('plus');
  $('zMinus').onclick = () => { zoom = ZOOMS[Math.max(0, ZOOMS.indexOf(zoom) - 1)]; applyZoom(); render(pos, true); };
  $('zPlus').onclick = () => { zoom = ZOOMS[Math.min(ZOOMS.length - 1, ZOOMS.indexOf(zoom) + 1)]; applyZoom(); render(pos, true); };
  applyZoom();

  const model = C.mountScore(score, data, meta);
  const { notes, systems, END } = model;
  const voices = model.voices;
  const cursors = model.layers.map(layer => {
    const cur = document.createElementNS(C.NS, 'rect');
    cur.setAttribute('class', 'cursor'); cur.setAttribute('rx', 0.6); cur.setAttribute('width', 3);
    cur.style.display = 'none';
    layer.appendChild(cur);
    return cur;
  });

  // ---------- Plan de lecture (couplets) ----------
  const SKEY = `chorale.structure.${id}`;
  let cfg = C.structureConfig(meta, store.get(SKEY));
  let pianoPlan = C.makePlan(C.orderFromConfig(meta, cfg, END), END);
  let plan = pianoPlan;

  // ---------- État ----------
  const tempo0 = data.tempo || meta.tempo || { bpm: 80, unit: 0.25 };
  let bpm = tempo0.bpm;
  const unit = tempo0.unit;
  const unitLabel = { 0.25: '♩', 0.375: '♩.', 0.5: '𝅗𝅥', 0.125: '♪' }[unit] || '♩';
  const vstate = Object.fromEntries(voices.map(v => [v, true]));
  let solo = null;
  let playing = false, pos = 0, startPos = 0, loop = false, metro = false, raf = 0;
  let lyricsMode = store.get('chorale.lyrics') ?? 'all';
  const audible = v => solo ? v === solo : vstate[v];
  const secPerWhole = () => 60 / bpm / unit;
  const measureBars = () => new Set(model.measureList.map(x => Math.round(x.t * 1e4)));
  const BARS = measureBars();

  // ---------- Audio (piano) ----------
  const out = new Tone.Gain(0.85).toDestination();
  const reverb = new Tone.Reverb({ decay: 2.2, wet: 0.2 }).connect(out);
  let pianoReady = false, pianoDone;
  const pianoLoaded = new Promise(r => (pianoDone = r));
  const SAMPLES = ['A1', 'C2', 'Ds2', 'Fs2', 'A2', 'C3', 'Ds3', 'Fs3', 'A3', 'C4', 'Ds4', 'Fs4', 'A4', 'C5', 'Ds5', 'Fs5', 'A5', 'C6'];
  const piano = new Tone.Sampler({
    urls: Object.fromEntries(SAMPLES.map(n => [n.replace('s', '#'), n + '.mp3'])),
    baseUrl: location.protocol === 'file:' ? 'https://tonejs.github.io/audio/salamander/' : 'assets/piano/',
    release: 1,
    onload: () => { pianoReady = true; pianoDone(); },
    onerror: () => pianoDone(),
  }).connect(reverb);
  const organ = new Tone.PolySynth(Tone.Synth, {
    oscillator: { type: 'custom', partials: [1, 0.5, 0.28, 0.16, 0.08, 0.04] },
    envelope: { attack: 0.05, decay: 0.1, sustain: 0.85, release: 0.25 },
    volume: -15,
  }).connect(reverb);
  organ.maxPolyphony = 48;
  const click = new Tone.Synth({
    oscillator: { type: 'triangle' }, envelope: { attack: 0.001, decay: 0.05, sustain: 0, release: 0.02 }, volume: -8,
  }).connect(out);
  const instr = $('instr');
  const instrument = () => (instr.value === 'piano' && pianoReady ? piano : organ);

  const T = Tone.Transport;
  function schedule(from) {
    T.stop(); T.cancel(); T.seconds = 0;
    startPos = from;
    const spw = secPerWhole();
    const inst = instrument();
    for (const e of C.perfEvents(model, plan)) {
      if (!audible(e.n.v) || e.P < from - EPS) continue;
      const f = Tone.Frequency(e.n.p, 'midi').toFrequency();
      const dur = Math.max(0.06, e.dP * spw - 0.03);
      const vel = e.n.v === 'S' || e.n.v === 'Solo' ? 0.72 : 0.6;
      T.schedule(time => inst.triggerAttackRelease(f, dur, time, vel), (e.P - from) * spw);
    }
    if (metro) {
      const first = Math.ceil((from - EPS) / unit) * unit;
      for (let P = first; P < plan.TOTAL - EPS; P += unit) {
        const accent = BARS.has(Math.round(plan.toWritten(P) * 1e4));
        T.schedule(time => click.triggerAttackRelease(accent ? 'C6' : 'G5', 0.03, time, accent ? 0.9 : 0.5), (P - from) * spw);
      }
    }
    T.start('+0.06');
  }
  function stopAudio() {
    T.stop(); T.cancel();
    piano.releaseAll(); organ.releaseAll();
  }

  // ---------- Enregistrement original ----------
  const sync = C.normalizeSync(await syncLoad, meta, END);
  let syncPlan = null, tmap = null;
  if (sync) {
    syncPlan = C.makePlan(sync.order, END);
    tmap = C.timeMap(sync.marks, syncPlan.TOTAL);
  }
  const hasVideo = !!(sync && (sync.audio || sync.video) && tmap && tmap.anchors.length >= 2);
  const vOffset = (sync && sync.offset) || 0;
  let source = 'piano';
  let video = null;
  const videoBox = document.createElement('div');
  videoBox.className = 'video-float'; videoBox.hidden = true;
  videoBox.innerHTML = '<div id="yt"></div>';
  document.body.appendChild(videoBox);
  function loadVideo() {
    if (!video) {
      // Copie MP3 de l'enregistrement si elle existe (le site ne dépend alors pas de YouTube)
      const make = sync.audio
        ? (opts) => C.audioFile(`chants/${id}/${sync.audio}`, opts)
        : (opts) => C.youtube('yt', sync.video, opts);
      video = make({
        onState: st => {
          if (source !== 'video') return;
          const p = st === 1 || (st === 3 && playing);
          if (p === playing) return;
          playing = p; updatePlayBtn();
          cancelAnimationFrame(raf);
          if (p) raf = requestAnimationFrame(tick); else render(pos);
        },
        onError: () => toast('Enregistrement indisponible.'),
      });
    }
    return video.whenReady;
  }
  const seekVideo = P => { if (video && video.ready) { video.seek(P <= EPS ? 0 : tmap.pToV(P) - vOffset); dblLast = null; } };
  // Doublure au piano de la voix « solo » par-dessus l'enregistrement
  let dblEvents = [], dblLast = null;
  function doubling(P) {
    if (solo && playing && P != null && dblLast != null && P > dblLast && P - dblLast < 0.5) {
      const rate = video.rate();
      const inst = pianoReady ? piano : organ;
      for (const e of dblEvents) {
        if (e.P <= dblLast || e.P > P || e.n.v !== solo) continue;
        const dur = Math.max(0.08, (tmap.pToV(e.P + e.dP) - tmap.pToV(e.P)) / rate - 0.03);
        inst.triggerAttackRelease(Tone.Frequency(e.n.p, 'midi').toFrequency(), dur, Tone.now(), 0.75);
      }
    }
    dblLast = P;
  }

  // ---------- Lecture ----------
  async function play() {
    await Tone.start();
    if (source === 'video') {
      await loadVideo();
      if (!video.ready) return;
      if (pos >= plan.TOTAL - EPS) { pos = 0; seekVideo(0); }
      video.play();
      return;
    }
    if (instr.value === 'piano' && !pianoReady) {
      toast('Chargement du piano…', 0);
      await Promise.race([pianoLoaded, new Promise(r => setTimeout(r, 8000))]);
      if (pianoReady) status.classList.remove('show'); else toast('Piano indisponible : son d’orgue utilisé.');
    }
    if (pos >= plan.TOTAL - EPS) pos = 0;
    playing = true; updatePlayBtn();
    schedule(pos);
    cancelAnimationFrame(raf); raf = requestAnimationFrame(tick);
  }
  function pause() {
    if (source === 'video') {
      if (video) video.pause();
      playing = false; updatePlayBtn(); cancelAnimationFrame(raf); render(pos);
      return;
    }
    if (!playing) return;
    playing = false; updatePlayBtn();
    cancelAnimationFrame(raf); stopAudio();
    render(pos);
  }
  function seek(P, resume = playing) {
    pos = Math.max(0, Math.min(P, plan.TOTAL));
    if (source === 'video') {
      seekVideo(pos);
      render(pos, true);
      if (resume && !playing) play(); else updatePlayBtn();
      return;
    }
    if (playing) { playing = false; cancelAnimationFrame(raf); stopAudio(); }
    render(pos, true);
    if (resume) play(); else updatePlayBtn();
  }
  function tick() {
    if (!playing) return;
    if (source === 'video') {
      const P = tmap.vToP(video.time() + vOffset);
      doubling(P);
      pos = P == null ? 0 : P;
      if (P != null && P >= plan.TOTAL - EPS && loop) { seek(0, true); return; }
      render(pos);
      raf = requestAnimationFrame(tick);
      return;
    }
    // Position réellement entendue : le Transport est en avance du « lookAhead » de Tone
    // et de la latence de sortie audio ; on se cale sur l'horloge audio.
    const ctx = Tone.context, raw = ctx.rawContext || {};
    const heard = ctx.currentTime - (raw.outputLatency || raw.baseLatency || 0);
    pos = startPos + Math.max(0, T.getSecondsAtTime(heard)) / secPerWhole();
    if (pos >= plan.TOTAL) {
      if (loop) { pos = 0; schedule(0); }
      else { playing = false; stopAudio(); updatePlayBtn(); pos = plan.TOTAL; render(pos); return; }
    }
    render(pos);
    raf = requestAnimationFrame(tick);
  }

  // ---------- Affichage ----------
  let lastSys = null, lastOn = new Set();
  const lyricFilter = () => (lyricsMode === 'off' ? () => false : lyricsMode === 'all' ? null : v => v === lyricsMode);
  const verseLabel = v => (meta.structure && meta.structure.names && meta.structure.names[v]) || `couplet ${v}`;
  function render(P, jump = false) {
    const seg = plan.segAt(Math.min(P, plan.TOTAL - EPS));
    const w = Math.min(plan.toWritten(P), END - EPS);
    const on = new Set();
    const active = playing || P > 0;
    if (playing) for (const n of notes) if (audible(n.v) && w >= n.t - EPS && w < n.t + n.d - EPS) on.add(n.el);
    if (active && P < plan.TOTAL - EPS && lyricsMode !== 'off') for (const s of model.lyricsAt(w, seg.v, lyricFilter())) on.add(s.el);
    lastOn.forEach(el => { if (!on.has(el)) el.classList.remove('on'); });
    on.forEach(el => el.classList.add('on'));
    lastOn = on;

    const s = model.systemAt(w);
    const x = model.xAt(s, w);
    cursors.forEach((c, i) => { c.style.display = i === s.page && active ? '' : 'none'; });
    const c = cursors[s.page];
    c.setAttribute('x', x - 1.5); c.setAttribute('y', s.minY); c.setAttribute('height', s.maxY - s.minY);

    const m = model.measureAt(w).m;
    const lastMeasure = model.measureList[model.measureList.length - 1].m;
    const clock = source === 'video' && video && video.ready
      ? `${fmt(playing ? video.time() : (P <= EPS ? 0 : tmap.pToV(P) - vOffset))} / ${fmt(video.duration())}`
      : `${fmt(P * secPerWhole())} / ${fmt(plan.TOTAL * secPerWhole())}`;
    const nVerses = C.versesOfOrder(plan.order).length;
    $('time').innerHTML = `<b>Mes. ${m}</b> / ${lastMeasure}${nVerses > 1 ? ` <span class="verse-tag" style="--c:${C.verseColor(seg.v)}">${verseLabel(seg.v)}</span>` : ''}<br>${clock}`;
    const frac = plan.TOTAL ? P / plan.TOTAL : 0;
    $('pFill').style.width = `${frac * 100}%`;
    $('pKnob').style.left = `${frac * 100}%`;

    if ((playing && s !== lastSys) || jump) {
      lastSys = s;
      const r = c.getBoundingClientRect();
      const top = document.querySelector('.topbar').offsetHeight;
      const bottom = innerHeight - $('dock').offsetHeight;
      if (r.top < top + 10 || r.bottom > bottom - 10) {
        scrollBy({ top: r.top - top - (bottom - top) * 0.18, behavior: 'smooth' });
      }
    }
    if (playing || jump) {
      const r = c.getBoundingClientRect(), sr = scroller.getBoundingClientRect();
      if (r.left < sr.left + 16 || r.right > sr.right - 16) {
        scroller.scrollTo({ left: scroller.scrollLeft + r.left - sr.left - sr.width * 0.25, behavior: playing ? 'smooth' : 'auto' });
      }
    }
  }
  // Repères des passages sur la barre de progression
  function drawSegments() {
    const box = $('pSegs');
    if (!box) return;
    box.innerHTML = plan.segs.length > 1 ? plan.segs.map(s =>
      `<span style="left:${s.off / plan.TOTAL * 100}%;width:${(s.b - s.a) / plan.TOTAL * 100}%;--c:${C.verseColor(s.v)}"></span>`).join('') : '';
  }

  // ---------- Commandes ----------
  const playBtn = $('play');
  function updatePlayBtn() {
    playBtn.innerHTML = icon(playing ? 'pause' : 'play', 'fill');
    playBtn.setAttribute('aria-label', playing ? 'Pause' : 'Lecture');
  }
  playBtn.onclick = () => (playing ? pause() : play());
  $('restart').innerHTML = icon('restart');
  $('restart').onclick = () => seek(0);
  $('loop').innerHTML = icon('loop');
  $('loop').onclick = () => { loop = !loop; $('loop').classList.toggle('active', loop); };
  $('metro').innerHTML = icon('metronome');
  $('metro').onclick = () => { metro = !metro; $('metro').classList.toggle('active', metro); if (playing) seek(pos); };

  function updateTempo() {
    $('tVal').innerHTML = `<span>${unitLabel} = ${bpm}</span><small>${bpm === tempo0.bpm ? 'tempo d’origine' : Math.round(bpm / tempo0.bpm * 100) + ' %'}</small>`;
  }
  const setTempo = v => { bpm = Math.max(30, Math.min(200, v)); updateTempo(); if (playing) seek(pos); else render(pos); };
  $('tMinus').innerHTML = icon('minus'); $('tPlus').innerHTML = icon('plus');
  $('tMinus').onclick = () => setTempo(bpm - 4);
  $('tPlus').onclick = () => setTempo(bpm + 4);
  $('tVal').onclick = () => setTempo(tempo0.bpm);

  const vbox = $('voices');
  vbox.style.setProperty('--nv', voices.length);
  vbox.classList.toggle('compact', voices.length > 4);
  voices.forEach(v => {
    const el = document.createElement('div');
    el.className = 'voice'; el.dataset.v = v;
    const name = VOICE_NAMES[v] || v;
    el.innerHTML = `<button class="v-name" title="Activer / couper la voix"><span class="led"></span><span class="full">${name}</span><span class="short">${SHORT[v] || name}</span></button>` +
      `<button class="v-solo" title="Écouter cette voix seule">${icon('headphones')}</button>`;
    el.querySelector('.v-name').onclick = () => { if (solo) solo = null; else vstate[v] = !vstate[v]; refreshVoices(); };
    el.querySelector('.v-solo').onclick = () => { solo = solo === v ? null : v; refreshVoices(); };
    vbox.appendChild(el);
  });
  function refreshVoices() {
    vbox.querySelectorAll('.voice').forEach(el => {
      const v = el.dataset.v;
      el.classList.toggle('muted', !audible(v));
      el.classList.toggle('solo', solo === v);
    });
    if (playing && source !== 'video') seek(pos); else render(pos);
  }

  // Clic sur une note ou une syllabe : reprendre à cet endroit (occurrence la plus proche)
  notes.forEach(n => n.el.addEventListener('click', () => {
    const P = plan.toPerf(n.t, pos);
    if (P != null) seek(P, true);
  }));
  model.lyrics.forEach(s => s.el.addEventListener('click', () => {
    const g = model.groups.find(x => x.v === s.v);
    const cands = plan.segs.filter(sg => s.t >= sg.a - EPS && s.t < sg.b - EPS && model.chooseLine(g, sg.v, s.t) === s.line)
      .map(sg => sg.off + (s.t - sg.a));
    const all = cands.length ? cands : plan.toPerfAll(s.t);
    if (!all.length) return;
    seek(all.reduce((x, y) => (Math.abs(y - pos) < Math.abs(x - pos) ? y : x)), true);
  }));

  // Barre de progression
  const prog = $('progress');
  const seekFromEvent = e => {
    const r = prog.getBoundingClientRect();
    return Math.max(0, Math.min(1, (e.clientX - r.left) / r.width)) * plan.TOTAL;
  };
  let dragging = false, wasPlaying = false;
  prog.addEventListener('pointerdown', e => {
    dragging = true; wasPlaying = playing; prog.classList.add('drag'); prog.setPointerCapture(e.pointerId);
    if (playing) pause();
    pos = seekFromEvent(e); render(pos, true);
  });
  prog.addEventListener('pointermove', e => { if (dragging) { pos = seekFromEvent(e); render(pos); } });
  prog.addEventListener('pointerup', e => {
    if (!dragging) return;
    dragging = false; prog.classList.remove('drag');
    seek(seekFromEvent(e), wasPlaying);
  });

  // ---------- Couplets et paroles (fenêtre) ----------
  const stBtn = $('structBtn');
  const stPop = $('structPop');
  const hasLyrics = model.groups.length > 0;
  const lyrSel = $('lyricsSel');
  if (hasLyrics) {
    lyrSel.innerHTML = `<option value="all">Toutes les voix</option>` +
      model.groups.map(g => `<option value="${g.v}">${C.esc(g.name)}</option>`).join('') + `<option value="off">Ne pas surligner</option>`;
    if (![...lyrSel.options].some(o => o.value === lyricsMode)) lyricsMode = 'all';
    lyrSel.value = lyricsMode;
    lyrSel.onchange = () => { lyricsMode = lyrSel.value; store.set('chorale.lyrics', lyricsMode); render(pos); };
  } else $('lyricsRow').hidden = true;
  const editor = C.structureEditor($('structEditor'), {
    model, meta, cfg,
    duration: order => order.reduce((s, [a, b]) => s + (b - a), 0) * secPerWhole(),
    onChange: (c, order) => {
      cfg = c; store.set(SKEY, c);
      const wasP = playing, frac = plan.TOTAL ? pos / plan.TOTAL : 0;
      if (playing) pause();
      pianoPlan = C.makePlan(order, END);
      if (source !== 'video') plan = pianoPlan;
      drawSegments(); updateStructBtn();
      seek(Math.min(frac * plan.TOTAL, plan.TOTAL), wasP && source !== 'video');
    },
  });
  function updateStructBtn() {
    const vs = C.versesOfOrder(plan.order);
    const N = (meta.structure && meta.structure.verses) || 1;
    let lbl;
    if (source === 'video') lbl = 'Enregistrement';
    else if (cfg.custom) lbl = 'Personnalisé';
    else if (N <= 1) lbl = 'Structure';
    else if (meta.structure.names) lbl = vs.length === N ? 'Avec reprise' : 'Sans reprise';
    else lbl = vs.length === 1 ? `Couplet ${vs[0]}` : vs.length === N ? `${N} couplets` : `${vs.length} couplets`;
    stBtn.innerHTML = icon('list') + `<span>${lbl}</span>`;
  }
  stBtn.onclick = e => { e.stopPropagation(); stPop.hidden = !stPop.hidden; stBtn.classList.toggle('active', !stPop.hidden); };
  $('structClose').onclick = () => { stPop.hidden = true; stBtn.classList.remove('active'); };
  document.addEventListener('pointerdown', e => {
    if (!stPop.hidden && !stPop.contains(e.target) && !stBtn.contains(e.target)) { stPop.hidden = true; stBtn.classList.remove('active'); }
  });

  // ---------- Choix du son : piano / orgue / chœur ----------
  const videoBtn = $('videoBtn');
  async function setSource(src) {
    const wasPlaying = playing;
    const frac = plan.TOTAL ? pos / plan.TOTAL : 0;
    pause();
    source = src;
    document.body.classList.toggle('video-mode', src === 'video');
    videoBox.hidden = src !== 'video';
    const on = src === 'video';
    $('choirCard').classList.toggle('on', on);
    videoBtn.innerHTML = icon(on ? 'note' : 'headphones') + `<span>${on ? 'Revenir au piano' : 'Écouter le chœur'}</span>`;
    videoBtn.classList.toggle('primary', !on);
    $('ccTitle').textContent = on ? 'Vous écoutez l’enregistrement original' : 'Écoutez le chœur, la partition suit';
    $('ccSub').textContent = on
      ? 'Notes et paroles suivent le chant. Le casque d’une voix (en bas) la double au piano pour mieux l’entendre.'
      : 'Un enregistrement du chant est synchronisé : les notes et les paroles s’allument en rouge au moment où elles sont chantées.';
    document.querySelectorAll('.v-solo').forEach(b => {
      b.title = src === 'video' ? 'Doubler cette voix au piano' : 'Écouter cette voix seule';
    });
    plan = src === 'video' ? syncPlan : pianoPlan;
    if (src === 'video') dblEvents = C.perfEvents(model, plan);
    editor.setReadOnly(src === 'video', src === 'video' ? 'L’enregistrement impose son plan : voici les passages qu’il chante.' : '');
    if (src === 'video') editor.set({ verses: C.versesOfOrder(syncPlan.order), custom: syncPlan.order.map(x => x.slice()) });
    else editor.set(cfg);
    drawSegments(); updateStructBtn();
    if (src === 'video') { toast('Chargement de l’enregistrement…', 0); await loadVideo(); status.classList.remove('show'); }
    seek(Math.min(frac * plan.TOTAL, plan.TOTAL), wasPlaying);
  }
  if (hasVideo) {
    const o = document.createElement('option');
    o.value = 'video'; o.textContent = 'Chœur';
    instr.prepend(o);
    instr.value = 'piano';
    $('choirCard').hidden = false;
    $('ccIcon').innerHTML = icon('headphones');
    videoBtn.innerHTML = icon('headphones') + '<span>Écouter le chœur</span>';
    videoBtn.onclick = () => {
      Tone.start();
      instr.value = source === 'video' ? 'piano' : 'video';
      setSource(instr.value === 'video' ? 'video' : 'piano').then(() => { if (source === 'video' && !playing) play(); });
    };
  }
  instr.onchange = () => {
    Tone.start();
    const src = instr.value === 'video' ? 'video' : 'piano';
    if (src !== source) setSource(src);
    else if (playing) seek(pos);
  };

  addEventListener('keydown', e => {
    if (/INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName)) return;
    if (e.code === 'Space') { e.preventDefault(); playing ? pause() : play(); }
    else if (e.code === 'Home') { e.preventDefault(); seek(0); }
    else if (e.code === 'Escape' && !stPop.hidden) { stPop.hidden = true; stBtn.classList.remove('active'); }
  });

  $('dock').hidden = false;
  const dockH = () => document.body.style.setProperty('--dock-h', `${$('dock').offsetHeight}px`);
  addEventListener('resize', dockH); dockH();
  updatePlayBtn(); updateTempo(); updateStructBtn(); drawSegments(); render(0);
  if (hasVideo && qs.get('mode') === 'video') { instr.value = 'video'; setSource('video'); }
})();
