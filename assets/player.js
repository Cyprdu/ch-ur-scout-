/* Lecteur de partition : lecture synchronisée, voix par voix. */
(async () => {
  const $ = id => document.getElementById(id);
  const VOICE_NAMES = { S: 'Soprano', A: 'Alto', T: 'Ténor', B: 'Basse', Solo: 'Solo' };
  const EPS = 1e-6;
  const SHORT = { S: 'Sop.', A: 'Alto', T: 'Tén.', B: 'Bas.', Solo: 'Solo' };

  // ---------- Chant demandé ----------
  const id = new URLSearchParams(location.search).get('c');
  const meta = (window.CHANTS || []).find(s => s.id === id);
  $('backBtn').innerHTML = icon('back') + '<span class="lbl">Chants</span>';
  if (!meta) {
    $('scoreInner').innerHTML ='<div class="loading">Chant introuvable. <a href="index.html" style="color:var(--red)">Retour à la liste</a></div>';
    return;
  }
  document.title = `${meta.title} — Chorale Scouts d'Europe Lyon 2026`;
  $('cat').textContent = meta.category || '';
  $('title').textContent = meta.title;
  $('authors').textContent = meta.authors || '';
  $('pdfBtn').href = `chants/${id}/${id}.pdf`;
  $('pdfBtn').innerHTML = icon('download') + '<span class="lbl">Partition PDF</span>';

  await new Promise((res, rej) => {
    const s = document.createElement('script');
    s.src = `chants/${id}/data.js`; s.onload = res; s.onerror = rej;
    document.head.appendChild(s);
  }).catch(() => null);
  const data = window.CHANT;
  if (!data) { $('scoreInner').innerHTML = '<div class="loading">Impossible de charger la partition.</div>'; return; }

  // ---------- Partition ----------
  const scroller = $('score');
  const score = $('scoreInner');
  score.innerHTML = '';
  // Zoom (mémorisé sur cet appareil)
  const ZOOMS = [0.6, 0.75, 0.9, 1, 1.25, 1.5, 1.75, 2, 2.5];
  let zoom;
  try { zoom = +localStorage.getItem('chorale.zoom'); } catch (e) {}
  if (!ZOOMS.includes(zoom)) zoom = innerWidth < 700 ? 1.75 : 1;
  const applyZoom = () => {
    score.style.setProperty('--zoom', zoom);
    $('zVal').textContent = `${Math.round(zoom * 100)} %`;
    try { localStorage.setItem('chorale.zoom', zoom); } catch (e) {}
  };
  $('zMinus').innerHTML = icon('minus'); $('zPlus').innerHTML = icon('plus');
  $('zMinus').onclick = () => { zoom = ZOOMS[Math.max(0, ZOOMS.indexOf(zoom) - 1)]; applyZoom(); render(pos, true); };
  $('zPlus').onclick = () => { zoom = ZOOMS[Math.min(ZOOMS.length - 1, ZOOMS.indexOf(zoom) + 1)]; applyZoom(); render(pos, true); };
  applyZoom();
  const NS = 'http://www.w3.org/2000/svg';
  const sheets = data.pages.map(svgText => {
    const div = document.createElement('div');
    div.className = 'sheet';
    div.innerHTML = svgText;
    score.appendChild(div);
    return div;
  });

  const notes = [];
  const cursors = [];
  sheets.forEach((sheet, pi) => {
    const svg = sheet.querySelector('svg');
    const ov = svg.querySelector('.overlay');
    const under = document.createElementNS(NS, 'g');
    if (ov.getAttribute('transform')) under.setAttribute('transform', ov.getAttribute('transform'));
    const cur = document.createElementNS(NS, 'rect');
    cur.setAttribute('class', 'cursor'); cur.setAttribute('rx', 0.6); cur.setAttribute('width', 3);
    cur.style.display = 'none';
    under.appendChild(cur);
    const defs = svg.querySelector('defs');
    svg.insertBefore(under, defs ? defs.nextSibling : svg.firstChild);
    cursors.push(cur);
    ov.querySelectorAll('.nh').forEach(el => {
      const b = el.getBBox();
      notes.push({
        el, page: pi, v: el.dataset.v, t: +el.dataset.t, p: +el.dataset.p, d: +el.dataset.d,
        m: +el.dataset.m || 0, tie: el.dataset.tie === '1', x: b.x + b.width / 2, y: b.y + b.height / 2,
      });
    });
  });
  notes.sort((a, b) => a.t - b.t || a.p - b.p);

  // Liaisons de prolongation : une seule attaque, durée cumulée
  const key = (v, p, t) => `${v}|${p}|${Math.round(t * 1e4)}`;
  const byKey = new Map(notes.map(n => [key(n.v, n.p, n.t), n]));
  notes.forEach(n => { n.root = n.root || n; n.sd = n.d; });
  notes.forEach(n => {
    if (!n.tie) return;
    const nx = byKey.get(key(n.v, n.p, n.t + n.d));
    if (nx) { nx.root = n.root; nx.silent = true; n.root.sd += nx.d; }
  });

  const END = Math.max(...notes.map(n => n.t + n.d));
  const voices = (meta.voices || [...new Set(notes.map(n => n.v))]).filter(v => notes.some(n => n.v === v));

  // Ordre de lecture (reprises) : segments du temps écrit
  const order = (data.order || [[0, END]]).map(([a, b]) => [a, b ?? END]);
  let acc = 0;
  const segs = order.map(([a, b]) => { const s = { a, b, off: acc }; acc += b - a; return s; });
  const TOTAL = acc;
  const toWritten = P => {
    for (const s of segs) if (P < s.off + (s.b - s.a) - EPS) return s.a + Math.max(0, P - s.off);
    const l = segs[segs.length - 1]; return l.b;
  };
  const toPerf = w => { for (const s of segs) if (w >= s.a - EPS && w < s.b - EPS) return s.off + (w - s.a); return 0; };

  // Systèmes (lignes) : x qui revient en arrière = nouvelle ligne
  const systems = [];
  {
    const times = [...new Set(notes.map(n => n.t))].sort((a, b) => a - b);
    let cur = null, prevX = -Infinity, prevPage = -1;
    for (const t of times) {
      const at = notes.filter(n => n.t === t);
      const page = at[0].page;
      const x = Math.min(...at.map(n => n.x));
      if (!cur || page !== prevPage || x < prevX - 10) { cur = { notes: [], page, t0: t }; systems.push(cur); }
      cur.notes.push(...at); prevX = x; prevPage = page;
    }
    systems.forEach((s, i) => {
      s.t1 = i + 1 < systems.length ? systems[i + 1].t0 : END;
      s.minY = Math.min(...s.notes.map(n => n.y)) - 5;
      s.maxY = Math.max(...s.notes.map(n => n.y)) + 5;
      const byT = new Map();
      s.notes.forEach(n => (byT.get(n.t) || byT.set(n.t, []).get(n.t)).push(n.x));
      s.pts = [...byT].map(([t, xs]) => [t, Math.min(...xs)]).sort((a, b) => a[0] - b[0]);
      const lastEnd = Math.max(...s.notes.map(n => n.t + n.d));
      s.pts.push([Math.max(lastEnd, s.t1), Math.max(...s.notes.map(n => n.x)) + 4]);
    });
  }
  const measures = [...new Set(notes.map(n => n.m))].sort((a, b) => a - b);
  const lastMeasure = measures[measures.length - 1] || 1;
  const measureStarts = new Map();
  notes.forEach(n => { if (!measureStarts.has(n.m) || n.t < measureStarts.get(n.m)) measureStarts.set(n.m, n.t); });
  const barTimes = [...measureStarts.values()];

  // ---------- État ----------
  const tempo0 = data.tempo || { bpm: 80, unit: 0.25 };
  let bpm = tempo0.bpm;
  const unit = tempo0.unit;
  const unitLabel = { 0.25: '♩', 0.375: '♩.', 0.5: '𝅗𝅥', 0.125: '♪' }[unit] || '♩';
  const vstate = Object.fromEntries(voices.map(v => [v, true]));
  let solo = null;
  let playing = false, pos = 0, startPos = 0, loop = false, metro = false, raf = 0;
  const audible = v => solo ? v === solo : vstate[v];
  const secPerWhole = () => 60 / bpm / unit;

  // ---------- Audio ----------
  const status = $('status');
  let toastTimer;
  const toast = (msg, ms = 2400) => {
    status.textContent = msg; status.classList.add('show');
    clearTimeout(toastTimer); if (ms) toastTimer = setTimeout(() => status.classList.remove('show'), ms);
  };
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
    for (const s of segs) {
      for (const n of notes) {
        if (n.silent || !audible(n.v) || n.t < s.a - EPS || n.t >= s.b - EPS) continue;
        const P = s.off + (n.t - s.a);
        if (P < from - EPS) continue;
        const f = Tone.Frequency(n.p, 'midi').toFrequency();
        const dur = Math.max(0.06, Math.min(n.sd, s.b - n.t) * spw - 0.03);
        const vel = n.v === 'S' || n.v === 'Solo' ? 0.72 : 0.6;
        T.schedule(time => inst.triggerAttackRelease(f, dur, time, vel), (P - from) * spw);
      }
    }
    if (metro) {
      const first = Math.ceil((from - EPS) / unit) * unit;
      for (let P = first; P < TOTAL - EPS; P += unit) {
        const w = toWritten(P);
        const accent = barTimes.some(b => Math.abs(b - w) < EPS);
        T.schedule(time => click.triggerAttackRelease(accent ? 'C6' : 'G5', 0.03, time, accent ? 0.9 : 0.5), (P - from) * spw);
      }
    }
    T.start('+0.06');
  }
  function stopAudio() {
    T.stop(); T.cancel();
    piano.releaseAll(); organ.releaseAll();
  }

  // ---------- Lecture ----------
  async function play() {
    await Tone.start();
    if (instr.value === 'piano' && !pianoReady) {
      toast('Chargement du piano…', 0);
      await Promise.race([pianoLoaded, new Promise(r => setTimeout(r, 8000))]);
      if (pianoReady) status.classList.remove('show'); else toast('Piano indisponible : son d’orgue utilisé.');
    }
    if (pos >= TOTAL - EPS) pos = 0;
    playing = true; updatePlayBtn();
    schedule(pos);
    cancelAnimationFrame(raf); raf = requestAnimationFrame(tick);
  }
  function pause() {
    if (!playing) return;
    playing = false; updatePlayBtn();
    cancelAnimationFrame(raf); stopAudio();
    render(pos);
  }
  function seek(P, resume = playing) {
    if (playing) { playing = false; cancelAnimationFrame(raf); stopAudio(); }
    pos = Math.max(0, Math.min(P, TOTAL));
    render(pos, true);
    if (resume) play(); else updatePlayBtn();
  }
  function tick() {
    if (!playing) return;
    // Position réellement entendue : le Transport est en avance du « lookAhead » de Tone
    // et de la latence de sortie audio ; on se cale sur l'horloge audio.
    const ctx = Tone.context, raw = ctx.rawContext || {};
    const heard = ctx.currentTime - (raw.outputLatency || raw.baseLatency || 0);
    pos = startPos + Math.max(0, T.getSecondsAtTime(heard)) / secPerWhole();
    if (pos >= TOTAL) {
      if (loop) { pos = 0; schedule(0); }
      else { playing = false; stopAudio(); updatePlayBtn(); pos = TOTAL; render(pos); return; }
    }
    render(pos);
    raf = requestAnimationFrame(tick);
  }

  // ---------- Affichage ----------
  let lastSys = null, lastOn = new Set();
  const fmt = s => `${Math.floor(s / 60)}:${String(Math.floor(s % 60)).padStart(2, '0')}`;
  function render(P, jump = false) {
    const w = Math.min(toWritten(P), END - EPS);
    const on = new Set();
    if (playing) for (const n of notes) if (audible(n.v) && w >= n.t - EPS && w < n.t + n.d - EPS) on.add(n.el);
    lastOn.forEach(el => { if (!on.has(el)) el.classList.remove('on'); });
    on.forEach(el => el.classList.add('on'));
    lastOn = on;

    let s = systems[0];
    for (const sy of systems) if (sy.t0 <= w + EPS) s = sy;
    let x = s.pts[0][1];
    for (let i = 0; i < s.pts.length - 1; i++) {
      const [t0, x0] = s.pts[i], [t1, x1] = s.pts[i + 1];
      if (w >= t0 && w <= t1) { x = x0 + (x1 - x0) * (w - t0) / (t1 - t0 || 1); break; }
      if (w > t1) x = x1;
    }
    cursors.forEach((c, i) => { c.style.display = i === s.page && (playing || P > 0) ? '' : 'none'; });
    const c = cursors[s.page];
    c.setAttribute('x', x - 1.5); c.setAttribute('y', s.minY); c.setAttribute('height', s.maxY - s.minY);

    const m = [...measureStarts].filter(([, t]) => t <= w + EPS).reduce((a, [mm, t]) => (t >= a.t ? { m: mm, t } : a), { m: measures[0] || 1, t: -1 }).m;
    const spw = secPerWhole();
    $('time').innerHTML = `<b>Mes. ${m}</b> / ${lastMeasure}<br>${fmt(P * spw)} / ${fmt(TOTAL * spw)}`;
    const frac = TOTAL ? P / TOTAL : 0;
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
  instr.onchange = () => { if (playing) seek(pos); };

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
    if (playing) seek(pos); else render(pos);
  }

  // Clic sur une note : reprendre à cet endroit
  notes.forEach(n => n.el.addEventListener('click', () => seek(toPerf(n.t), true)));

  // Barre de progression
  const prog = $('progress');
  const seekFromEvent = e => {
    const r = prog.getBoundingClientRect();
    return Math.max(0, Math.min(1, (e.clientX - r.left) / r.width)) * TOTAL;
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

  addEventListener('keydown', e => {
    if (/INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName)) return;
    if (e.code === 'Space') { e.preventDefault(); playing ? pause() : play(); }
    else if (e.code === 'Home') { e.preventDefault(); seek(0); }
  });

  $('dock').hidden = false;
  updatePlayBtn(); updateTempo(); render(0);
})();
