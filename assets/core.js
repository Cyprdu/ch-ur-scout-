/* Noyau commun du lecteur et du studio de synchronisation :
   partition (notes, paroles, lignes), plan de lecture (couplets, reprises),
   correspondance temps vidéo <-> partition, lecteur YouTube, éditeur de structure. */
window.Chorale = (() => {
  const EPS = 1e-6;
  const NS = 'http://www.w3.org/2000/svg';
  const VOICE_NAMES = { S: 'Soprano', S2: 'Soprano 2', A: 'Alto', T: 'Ténor', B: 'Basse', Solo: 'Solo' };
  const VERSE_COLORS = ['#c8231f', '#2563eb', '#059669', '#d97706', '#7c3aed', '#db2777', '#0891b2', '#65a30d'];
  const verseColor = v => VERSE_COLORS[((v || 1) - 1) % VERSE_COLORS.length];
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const fmt = (s, tenths = false) => {
    if (s == null || !isFinite(s)) return '—';
    const neg = s < 0; s = Math.abs(s);
    const m = Math.floor(s / 60), r = s - m * 60;
    return (neg ? '−' : '') + `${m}:` + (tenths ? r.toFixed(1).padStart(4, '0') : String(Math.floor(r)).padStart(2, '0'));
  };
  const fmtBeats = x => {
    const r = Math.round(x * 100) / 100;
    return ({ 0.5: '½', 1.5: '1½', 2.5: '2½', 0.25: '¼', 0.75: '¾' }[r]) || String(r).replace('.', ',');
  };

  // ======================================================================
  // Plan de lecture : liste de passages [a, b, couplet] du temps écrit
  // ======================================================================
  const inRange = (key, v) => {
    if (key === '*') return true;
    const m = String(key).match(/^(\d+)(?:-(\d+))?$/);
    return m && v >= +m[1] && v <= +(m[2] || m[1]);
  };
  const pick = (map, v) => {
    if (!map) return null;
    if (map[String(v)]) return map[String(v)];
    const k = Object.keys(map).find(k => k !== '*' && inRange(k, v));
    return k ? map[k] : map['*'] || null;
  };
  const allVerses = st => Array.from({ length: (st && st.verses) || 1 }, (_, i) => i + 1);

  /** Plan généré à partir de la structure du chant et des couplets choisis. */
  function generateOrder(st, verses) {
    verses = (verses && verses.length ? verses : allVerses(st)).slice().sort((a, b) => a - b);
    const out = [];
    const push = (segs, v) => (segs || []).forEach(([a, b]) => out.push([a, b, v]));
    push(st.intro, verses[0]);
    verses.forEach((v, i) => {
      const last = i === verses.length - 1;
      push((last && pick(st.lastCouplet, v)) || pick(st.couplet, v), v);
      push(last ? (st.last || st.between) : st.between, v);
    });
    push(st.outro, verses[verses.length - 1]);
    return mergeOrder(out);
  }
  function mergeOrder(order) {
    const out = [];
    for (const [a, b, v] of order) {
      const l = out[out.length - 1];
      if (l && Math.abs(l[1] - a) < EPS && l[2] === v) l[1] = b;
      else if (b - a > EPS) out.push([a, b, v]);
    }
    return out;
  }
  function defaultOrder(meta, data, END) {
    if (meta && meta.structure) return generateOrder(meta.structure);
    const o = (data && data.order) || (meta && meta.order) || [[0, END]];
    return o.map(([a, b, v]) => [a, b ?? END, v || 1]);
  }
  const versesOfOrder = order => [...new Set(order.map(s => s[2] || 1))].sort((a, b) => a - b);

  /** Plan : temps « joué » P (en rondes, reprises dépliées) <-> temps écrit w. */
  function makePlan(order, END) {
    let acc = 0;
    const count = {};
    const segs = order.map(([a, b, v], i) => {
      b = Math.min(b ?? END, END);
      const base = `${a}-${b}-${v || 1}`;
      count[base] = (count[base] || 0) + 1;
      const s = { i, a, b, v: v || 1, off: acc, sig: `${base}#${count[base]}` };
      acc += b - a;
      return s;
    });
    const TOTAL = acc;
    const segAt = P => {
      for (const s of segs) if (P < s.off + (s.b - s.a) - EPS) return s;
      return segs[segs.length - 1];
    };
    const toWritten = P => {
      const s = segAt(P);
      return Math.min(s.b, s.a + Math.max(0, P - s.off));
    };
    // Occurrences jouées d'un instant écrit (une par passage qui le contient)
    const toPerfAll = w => segs.filter(s => w >= s.a - EPS && w < s.b - EPS).map(s => s.off + (w - s.a));
    const toPerf = (w, near = 0) => {
      const all = toPerfAll(w);
      if (!all.length) return null;
      return all.reduce((x, y) => (Math.abs(y - near) < Math.abs(x - near) ? y : x));
    };
    return { segs, TOTAL, segAt, toWritten, toPerf, toPerfAll, order };
  }

  // ======================================================================
  // Partition : notes, paroles, lignes (systèmes), mesures
  // ======================================================================
  function mountScore(container, data, meta) {
    container.innerHTML = '';
    const sheets = data.pages.map(svgText => {
      const div = document.createElement('div');
      div.className = 'sheet';
      div.innerHTML = svgText;
      container.appendChild(div);
      return div;
    });
    const notes = [], lyrics = [], layers = [], mels = [];
    sheets.forEach((sheet, pi) => {
      const svg = sheet.querySelector('svg');
      const ov = svg.querySelector('.overlay');
      const under = document.createElementNS(NS, 'g');
      if (ov.getAttribute('transform')) under.setAttribute('transform', ov.getAttribute('transform'));
      const defs = svg.querySelector('defs');
      svg.insertBefore(under, defs ? defs.nextSibling : svg.firstChild);
      layers.push(under);
      ov.querySelectorAll('.nh').forEach(el => {
        const b = el.getBBox();
        notes.push({
          el, page: pi, v: el.dataset.v, t: +el.dataset.t, p: +el.dataset.p, d: +el.dataset.d,
          m: +el.dataset.m || 0, tie: el.dataset.tie === '1', x: b.x + b.width / 2, y: b.y + b.height / 2,
        });
      });
      // « _ » : vocalise, la syllabe précédente de la ligne est tenue sur cette note
      ov.querySelectorAll('.ly.mel').forEach(el => mels.push({ ln: +el.dataset.ln, t: +el.dataset.t }));
      ov.querySelectorAll('.ly:not(.mel)').forEach(el => {
        const b = el.getBBox();
        // Zone cliquable invisible sur toute la syllabe (pas seulement les traits des lettres)
        const hit = document.createElementNS(NS, 'rect');
        hit.setAttribute('class', 'ly-hit');
        hit.setAttribute('x', b.x - 1); hit.setAttribute('y', b.y - 1.5);
        hit.setAttribute('width', b.width + 2); hit.setAttribute('height', b.height + 3);
        el.insertBefore(hit, el.firstChild);
        lyrics.push({
          el, page: pi, ln: +el.dataset.ln, st: el.dataset.st || '', v: el.dataset.v, m: +el.dataset.m || 0,
          t: +el.dataset.t, tx: el.dataset.tx, hy: el.dataset.hy === '1', ex: el.dataset.ex === '1', x: b.x, y: b.y, w: b.width, h: b.height,
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
    const voices = ((meta && meta.voices) || [...new Set(notes.map(n => n.v))]).filter(v => notes.some(n => n.v === v));

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
        s.i = i;
        s.t1 = i + 1 < systems.length ? systems[i + 1].t0 : END;
        s.minY = Math.min(...s.notes.map(n => n.y)) - 5;
        s.maxY = Math.max(...s.notes.map(n => n.y)) + 5;
        const byT = new Map();
        s.notes.forEach(n => (byT.get(n.t) || byT.set(n.t, []).get(n.t)).push(n.x));
        s.pts = [...byT].map(([t, xs]) => [t, Math.min(...xs)]).sort((a, b) => a[0] - b[0]);
        const lastEnd = Math.max(...s.notes.map(n => n.t + n.d));
        s.pts.push([Math.max(lastEnd, s.t1), Math.max(...s.notes.map(n => n.x)) + 4]);
      });
      // Les paroles agrandissent la zone d'une ligne vers le bas
      lyrics.forEach(l => {
        const s = systems.find(sy => sy.page === l.page && l.t >= sy.t0 - EPS && l.t < sy.t1 - EPS);
        if (s) { s.lyMaxY = Math.max(s.lyMaxY || -Infinity, l.y + l.h); }
      });
    }
    const xAt = (s, w) => {
      let x = s.pts[0][1];
      for (let i = 0; i < s.pts.length - 1; i++) {
        const [t0, x0] = s.pts[i], [t1, x1] = s.pts[i + 1];
        if (w >= t0 && w <= t1) return x0 + (x1 - x0) * (w - t0) / (t1 - t0 || 1);
        if (w > t1) x = x1;
      }
      return x;
    };
    const systemAt = w => { let s = systems[0]; for (const sy of systems) if (sy.t0 <= w + EPS) s = sy; return s; };

    const measureStarts = new Map();
    notes.forEach(n => { if (!measureStarts.has(n.m) || n.t < measureStarts.get(n.m)) measureStarts.set(n.m, n.t); });
    const measureList = [...measureStarts].map(([m, t]) => ({ m, t })).sort((a, b) => a.t - b.t);
    const measureAt = w => {
      let best = measureList[0];
      for (const x of measureList) if (x.t <= w + EPS) best = x;
      return best;
    };

    // ---------- Paroles ----------
    const notesByVoice = {};
    notes.forEach(n => (notesByVoice[n.v] = notesByVoice[n.v] || []).push(n));
    const lineMap = new Map();
    lyrics.forEach(l => {
      if (!lineMap.has(l.ln)) lineMap.set(l.ln, { ln: l.ln, v: l.v, syl: [] });
      lineMap.get(l.ln).syl.push(l);
    });
    const lines = [...lineMap.values()].sort((a, b) => a.ln - b.ln);
    lines.forEach(line => {
      line.syl.sort((a, b) => a.t - b.t);
      line.syl.forEach((s, i) => {
        s.line = line;
        // Mots : une syllabe suivie d'un trait d'union continue sur la suivante
        const prev = line.syl[i - 1];
        s.word = prev && prev.hy ? prev.word : { syl: [], line };
        s.word.syl.push(s);
      });
    });
    const groups = [];
    lines.forEach(line => {
      let g = groups.find(x => x.v === line.v);
      if (!g) groups.push(g = { v: line.v, name: VOICE_NAMES[line.v] || line.v, lines: [] });
      line.idx = g.lines.length;
      g.lines.push(line);
    });
    // Fin de chaque syllabe. Prolongée (trait « ___ ») : toute la vocalise jusqu'à la syllabe
    // suivante. Sinon : sa note (liaisons comprises) et les notes suivantes tant qu'aucune autre
    // ligne de la même voix n'attaque une syllabe — une ligne qui « saute » des notes laisse
    // ainsi la place aux paroles du dessus.
    const tk = t => Math.round(t * 1e4);
    groups.forEach(g => {
      const vn = (notesByVoice[g.v] || []).filter(n => true).sort((a, b) => a.t - b.t);
      const onsets = g.lines.map(l => new Set(l.syl.map(s => tk(s.t))));
      const held = g.lines.map(l => new Set(mels.filter(m => m.ln === l.ln).map(m => tk(m.t))));
      held.forEach((set, k) => set.forEach(x => onsets[k].add(x)));
      g.lines.forEach((line, li) => {
        const foreign = new Set();
        onsets.forEach((set, k) => { if (k !== li) set.forEach(x => { if (!onsets[li].has(x)) foreign.add(x); }); });
        line.syl.forEach((s, i) => {
          const next = line.syl[i + 1];
          const lim = next ? next.t : Infinity;
          let end = s.t;
          for (const n of vn) {
            if (n.t < s.t - EPS) continue;
            if (n.t >= lim - EPS) break;
            if (!s.ex && n.t > s.t + EPS && !held[li].has(tk(n.t)) && (foreign.has(tk(n.t)) || n.t > end + EPS)) break;
            end = Math.max(end, n.t + n.d);
          }
          s.tEnd = end > s.t ? Math.min(end, lim) : Math.min(lim, s.t + 0.25);
          if (s.tEnd <= s.t) s.tEnd = s.t + 0.0625;
        });
      });
    });
    groups.sort((a, b) => voices.indexOf(a.v) - voices.indexOf(b.v));

    /** Ligne de paroles chantée au couplet `verse` à l'instant écrit w. */
    // Dernière syllabe d'une ligne commençant au plus tard en w (recherche dichotomique)
    const lastSyl = (syl, w) => {
      let lo = 0, hi = syl.length - 1, r = -1;
      while (lo <= hi) { const m = (lo + hi) >> 1; if (syl[m].t <= w + EPS) { r = m; lo = m + 1; } else hi = m - 1; }
      return r >= 0 ? syl[r] : null;
    };
    /**
     * Ligne chantée au couplet `verse` à l'instant écrit w. Candidates : les lignes qui ont
     * vraiment une syllabe à cet endroit (nouvelle syllabe, ou syllabe encore tenue).
     * Priorité : la ligne de ce couplet (numéro « 2. »), puis la ligne de même rang
     * (2e ligne au 2e passage), puis la plus proche AU-DESSUS (une ligne vide à la
     * reprise = on chante les paroles du dessus), enfin la première.
     */
    function chooseLine(g, verse, w) {
      let t0 = -Infinity;
      const at = g.lines.map(line => { const s = lastSyl(line.syl, w); if (s && s.t > t0) t0 = s.t; return s; });
      if (!isFinite(t0)) return null;
      const cands = [];
      g.lines.forEach((line, k) => { const s = at[k]; if (s && (Math.abs(s.t - t0) < EPS || w < s.tEnd - EPS)) cands.push({ line, s }); });
      if (!cands.length) return null;
      const byStanza = cands.find(c => c.s.st && +c.s.st === verse);
      if (byStanza) return byStanza.line;
      const byIdx = cands.find(c => c.line.idx === verse - 1);
      if (byIdx) return byIdx.line;
      const above = cands.filter(c => c.line.idx < verse - 1);
      if (above.length) return above[above.length - 1].line;
      // Une ligne plus bas seulement si la ligne de ce couplet n'a aucune parole dans la mesure
      // (refrain écrit sur une seule ligne) : sinon ce sont les paroles d'un autre passage.
      const own = g.lines[Math.min(verse, g.lines.length) - 1];
      const ms = measureAt(w), i = measureList.indexOf(ms);
      const mEnd = i + 1 < measureList.length ? measureList[i + 1].t : END;
      if (own && own.syl.some(x => x.t >= ms.t - EPS && x.t < mEnd - EPS)) return null;
      return cands[0].line;
    }
    /** Syllabes chantées à l'instant w (couplet verse), pour les voix demandées. */
    function lyricsAt(w, verse, filter) {
      const out = [];
      for (const g of groups) {
        if (filter && !filter(g.v)) continue;
        const line = chooseLine(g, verse, w);
        if (!line) continue;
        const s = line.syl.find(x => w >= x.t - EPS && w < x.tEnd - EPS);
        if (s) out.push(s);
      }
      return out;
    }

    const result = {
      sheets, layers, notes, lyrics, lines, groups, systems, END, voices,
      xAt, systemAt, measureStarts, measureList, measureAt, chooseLine, lyricsAt,
    };
    window.__chorale = result;
    return result;
  }

  // ======================================================================
  // Étapes à marquer (mesures, paroles) dans l'ordre chanté
  // ======================================================================
  function measureSteps(model, plan) {
    const steps = [];
    for (const s of plan.segs) {
      const inside = model.measureList.filter(x => x.t > s.a + EPS && x.t < s.b - EPS).map(x => x.t);
      const starts = [s.a, ...inside];
      starts.forEach((w, i) => {
        const wEnd = i + 1 < starts.length ? starts[i + 1] : s.b;
        if (wEnd - w <= EPS) return;
        const m = model.measureAt(w).m;
        steps.push({ kind: 'm', key: `m|${s.sig}|${w}`, P: s.off + (w - s.a), w, wEnd, seg: s, m, label: `Mes. ${m}` });
      });
    }
    // Numéro de passage : « 2e fois » quand une mesure revient
    const seen = {};
    steps.forEach((st, i) => {
      st.i = i;
      seen[st.m] = (seen[st.m] || 0) + 1;
      st.pass = seen[st.m];
    });
    return steps;
  }
  // Pronom accolé par un vrai trait d'union (« Réponds-moi », « dit-il »)
  const PRONOUN = /^(moi|toi|nous|vous|lui|leur|je|tu|il|elle|ils|elles|ci|là)[\s,.;:!?»"]*$/i;
  function lyricUnits(model, plan, voice, mode = 'word') {
    const g = model.groups.find(x => x.v === voice);
    if (!g) return [];
    const units = [];
    for (const s of plan.segs) {
      const onsets = [...new Set(g.lines.flatMap(l => l.syl.filter(x => x.t >= s.a - EPS && x.t < s.b - EPS).map(x => x.t)))].sort((a, b) => a - b);
      let prev = null;
      for (const t of onsets) {
        const line = model.chooseLine(g, s.v, t);
        const syl = line && line.syl.find(x => Math.abs(x.t - t) < EPS);
        if (!syl) { prev = null; continue; }
        if (mode === 'word' && prev && prev.last.hy && prev.last.line === syl.line && prev.last.word === syl.word) {
          prev.tx += (PRONOUN.test(syl.tx) && !syl.hy ? '-' : '') + syl.tx;
          prev.syl.push(syl); prev.last = syl; prev.wEnd = syl.tEnd;
          continue;
        }
        prev = { kind: 'l', voice, key: `l|${voice}|${s.sig}|${t}`, P: s.off + (t - s.a), w: t, wEnd: syl.tEnd, seg: s, syl: [syl], last: syl, tx: syl.tx };
        units.push(prev);
      }
    }
    units.forEach((u, i) => { u.i = i; u.label = u.tx; });
    return units;
  }

  // Notes d'une voix dans l'ordre chanté (attaques seulement : pas les suites de liaison)
  const NOTE_NAMES = ['Do', 'Do♯', 'Ré', 'Mi♭', 'Mi', 'Fa', 'Fa♯', 'Sol', 'La♭', 'La', 'Si♭', 'Si'];
  const noteName = p => `${NOTE_NAMES[p % 12]}${Math.floor(p / 12) - 1}`;
  function noteUnits(model, plan, voice) {
    const units = [];
    for (const s of plan.segs) {
      const byT = new Map();
      for (const n of model.notes) {
        if (n.v !== voice || n.silent || n.t < s.a - EPS || n.t >= s.b - EPS) continue;
        (byT.get(n.t) || byT.set(n.t, []).get(n.t)).push(n);
      }
      [...byT].sort((a, b) => a[0] - b[0]).forEach(([t, ns]) => {
        ns.sort((a, b) => b.p - a.p);
        units.push({
          kind: 'n', voice, key: `n|${voice}|${s.sig}|${t}`, P: s.off + (t - s.a), w: t,
          wEnd: Math.min(s.b, t + Math.max(...ns.map(n => n.sd))), seg: s, notes: ns,
          tx: ns.map(n => noteName(n.p)).join('+'),
        });
      });
    }
    units.forEach((u, i) => { u.i = i; u.label = u.tx; });
    return units;
  }
  /** Correspondance propre à une voix : ses repères de notes d'abord, puis paroles et mesures. */
  function voiceTimeMap(points, voice, TOTAL) {
    return timeMap(points.filter(p => p.kind !== 'n' || p.voice === voice), TOTAL);
  }

  /** Correction de justesse (cents) à l'instant t de l'enregistrement : interpolation linéaire
   *  entre les points clés [{t, c}], constante avant le premier et après le dernier. */
  function tuneAt(tune, t) {
    if (!tune || !tune.length) return 0;
    const k = [...tune].sort((a, b) => a.t - b.t);
    if (t <= k[0].t) return k[0].c;
    for (let i = 1; i < k.length; i++) {
      if (t <= k[i].t) return k[i - 1].c + (k[i].c - k[i - 1].c) * (t - k[i - 1].t) / (k[i].t - k[i - 1].t || 1);
    }
    return k[k.length - 1].c;
  }
  /** Fréquence d'une note MIDI corrigée de c cents. */
  const tunedFreq = (midi, c) => 440 * Math.pow(2, (midi - 69) / 12 + (c || 0) / 1200);

  /** Notes d'une voix avec leurs instants dans l'enregistrement (t0, t1), d'après la correspondance de cette voix. */
  function voiceEvents(events, voice, map, offset = 0) {
    return events.filter(e => e.n.v === voice).map(e => {
      const t0 = map.pToV(e.P), t1 = map.pToV(e.P + e.dP);
      return { ...e, t0: t0 - offset, t1: t1 - offset };
    }).filter(e => isFinite(e.t0) && isFinite(e.t1)).sort((a, b) => a.t0 - b.t0);
  }
  /** Programme les notes du piano un peu à l'avance pour qu'elles tombent pile avec l'enregistrement. */
  function doubler(lookahead = 0.15) {
    let until = null;
    return {
      reset() { until = null; },
      tick(v, rate, voices, eventsOf, trigger) {
        if (until == null || v < until - lookahead * rate - 0.3 || v > until + 1.5) until = v;   // saut dans l'audio
        const horizon = v + lookahead * rate;
        if (horizon <= until) return;
        for (const vc of voices) for (const e of eventsOf(vc)) {
          if (e.t0 <= until || e.t0 > horizon) continue;
          trigger(e, Math.max(0, (e.t0 - v) / rate), Math.max(0.08, (e.t1 - e.t0) / rate - 0.03));
        }
        until = horizon;
      },
    };
  }

  // ======================================================================
  // Correspondance temps vidéo <-> position jouée
  // ======================================================================
  // Priorité à position égale : note (la plus fine) > parole > mesure
  const PRIO = { n: 3, l: 2, m: 1, end: 1 };
  /** points: [{P, t, key, kind}] -> plus longue suite cohérente (P et t croissants). */
  function timeMap(points, TOTAL, prio = p => PRIO[p.kind] || 0) {
    const byP = new Map();
    for (const p of points) {
      if (!isFinite(p.P) || !isFinite(p.t)) continue;
      const k = Math.round(p.P * 1e6);
      const o = byP.get(k);
      if (!o || prio(p) > prio(o)) byP.set(k, p);
    }
    const pts = [...byP.values()].sort((a, b) => a.P - b.P);
    // Plus longue sous-suite strictement croissante en t (patience sorting)
    const tails = [], prev = new Array(pts.length);
    pts.forEach((p, i) => {
      let lo = 0, hi = tails.length;
      while (lo < hi) { const mid = (lo + hi) >> 1; if (pts[tails[mid]].t < p.t - 0.005) lo = mid + 1; else hi = mid; }
      prev[i] = lo > 0 ? tails[lo - 1] : -1;
      tails[lo] = i;
    });
    const keep = new Set();
    for (let i = tails.length ? tails[tails.length - 1] : -1; i >= 0; i = prev[i]) keep.add(i);
    const anchors = pts.filter((_, i) => keep.has(i));
    const rejected = new Set(pts.filter((_, i) => !keep.has(i)).map(p => p.key));
    const A = anchors;
    const slopeAt = k => (A[k + 1].P - A[k].P) / (A[k + 1].t - A[k].t);
    function vToP(v) {
      if (!A.length || v < A[0].t) return null;
      for (let k = 0; k < A.length - 1; k++) if (v < A[k + 1].t) return A[k].P + slopeAt(k) * (v - A[k].t);
      const L = A[A.length - 1];
      if (L.P >= TOTAL - EPS) return TOTAL;
      const sl = A.length > 1 ? slopeAt(A.length - 2) : 0.5;
      return Math.min(TOTAL, L.P + sl * (v - L.t));
    }
    function pToV(P) {
      if (!A.length) return null;
      if (A.length === 1) return A[0].t;
      if (P <= A[0].P) return Math.max(0, A[0].t - (A[0].P - P) / slopeAt(0));
      for (let k = 0; k < A.length - 1; k++) if (P <= A[k + 1].P) return A[k].t + (P - A[k].P) / slopeAt(k);
      const L = A[A.length - 1];
      return L.t + (P - L.P) / slopeAt(A.length - 2);
    }
    return { anchors, rejected, vToP, pToV };
  }

  // ======================================================================
  // Lecteur YouTube (commun)
  // ======================================================================
  let ytApi = null;
  function loadYouTubeApi() {
    if (window.YT && window.YT.Player) return Promise.resolve();
    if (!ytApi) {
      ytApi = new Promise(res => {
        const prev = window.onYouTubeIframeAPIReady;
        window.onYouTubeIframeAPIReady = () => { if (prev) prev(); res(); };
        const s = document.createElement('script');
        s.src = 'https://www.youtube.com/iframe_api';
        document.head.appendChild(s);
      });
    }
    return ytApi;
  }
  /** Lecteur YouTube avec un temps précis (getCurrentTime() n'avance que par paliers). */
  function youtube(elementId, videoId, { onState, onError } = {}) {
    const p = { ready: false, state: -1, videoId };
    let yt = null, rawT = 0, rawAt = 0, pending = null;
    p.whenReady = loadYouTubeApi().then(() => new Promise(res => {
      yt = new YT.Player(elementId, {
        videoId,
        playerVars: { controls: 0, disablekb: 1, rel: 0, playsinline: 1, iv_load_policy: 3, origin: location.origin },
        events: {
          onReady: () => { p.ready = true; res(p); },
          onStateChange: e => { p.state = e.data; rawT = yt.getCurrentTime(); rawAt = performance.now(); if (onState) onState(e.data); },
          onError: e => { if (onError) onError(e.data); res(p); },
        },
      });
    }));
    p.playing = () => p.state === 1;
    p.time = () => {
      if (!p.ready) return 0;
      const t = yt.getCurrentTime(), now = performance.now();
      // Juste après un saut, YouTube renvoie encore l'ancien temps : on garde la cible
      if (pending) {
        if (Math.abs(t - pending.t) < 0.6 || now - pending.at > 2500) pending = null;
        else return pending.t + (p.state === 1 ? (now - pending.at) / 1000 * (yt.getPlaybackRate() || 1) : 0);
      }
      if (t !== rawT) { rawT = t; rawAt = now; return t; }
      return p.state === 1 ? t + Math.min(0.5, (now - rawAt) / 1000) * (yt.getPlaybackRate() || 1) : t;
    };
    p.duration = () => (p.ready && yt.getDuration()) || 0;
    p.play = () => p.ready && yt.playVideo();
    p.pause = () => p.ready && yt.pauseVideo();
    p.seek = t => {
      if (!p.ready) return;
      t = Math.max(0, t);
      // seekTo() lancerait une vidéo jamais démarrée : on la « prépare » à cet instant à la place
      if (p.state === -1 || p.state === 5) {
        if (Math.abs(t - (yt.getCurrentTime() || 0)) > 0.05) yt.cueVideoById({ videoId, startSeconds: t });
      } else yt.seekTo(t, true);
      rawT = t; rawAt = performance.now();
      pending = { t, at: rawAt };
    };
    p.rate = r => { if (!p.ready) return 1; if (r) yt.setPlaybackRate(r); return yt.getPlaybackRate() || 1; };
    p.volume = v => { if (p.ready && v != null) yt.setVolume(v); return p.ready ? yt.getVolume() : 100; };
    return p;
  }

  /** Enregistrement joué par Web Audio, sur la même horloge que le piano : les notes doublées sont
   *  programmées à l'échantillon près, quel que soit l'appareil. Même interface que audioFile(),
   *  plus posAt(t) : position dans l'enregistrement à l'instant t de l'horloge audio. */
  function bufferAudio(url, ctx, { onState, onError } = {}) {
    const p = { ready: false, state: -1, buffer: null };
    const gain = ctx.createGain();
    gain.connect(ctx.destination);
    let src = null, t0 = 0, off = 0;   // en lecture : position = off + (horloge - t0)
    const set = st => { p.state = st; if (onState) onState(st); };
    const lat = () => ctx.outputLatency || ctx.baseLatency || 0;
    // Décodé en mono 32 kHz : 3 fois moins de mémoire qu'en stéréo 48 kHz (vieux téléphones)
    const decode = ab => new Promise((res, rej) => {
      const O = window.OfflineAudioContext || window.webkitOfflineAudioContext;
      let dc;
      try { dc = new O(1, 1, 32000); } catch (e) { dc = ctx; }
      dc.decodeAudioData(ab, res, rej);
    }).then(b => {
      const m = ctx.createBuffer(1, b.length, b.sampleRate), d = m.getChannelData(0);
      for (let c = 0; c < b.numberOfChannels; c++) {
        const x = b.getChannelData(c);
        for (let i = 0; i < d.length; i++) d[i] += x[i] / b.numberOfChannels;
      }
      return m;
    });
    p.whenReady = fetch(url).then(r => { if (!r.ok) throw new Error(r.status); return r.arrayBuffer(); })
      .then(decode).then(b => { p.buffer = b; p.ready = true; return p; })
      .catch(e => { if (onError) onError(e); return p; });
    const clamp = t => Math.max(0, Math.min(t, p.duration()));
    const stop = () => { const s = src; src = null; s.onended = null; try { s.stop(); } catch (e) {} };
    p.posAt = t => (src ? off + (t - t0) : off);
    p.playing = () => !!src;
    p.time = () => clamp(p.posAt(ctx.currentTime - lat()));   // ce qui sort du haut-parleur
    p.duration = () => (p.buffer ? p.buffer.duration : 0);
    p.play = () => {
      if (!p.buffer || src) return;
      if (ctx.state !== 'running') ctx.resume();
      if (off >= p.duration() - 0.01) off = 0;
      const s = src = ctx.createBufferSource();
      s.buffer = p.buffer; s.connect(gain);
      t0 = ctx.currentTime + 0.05;
      s.start(t0, off);
      s.onended = () => { if (src === s) { src = null; off = p.duration(); set(0); } };
      set(1);
    };
    p.pause = () => { if (!src) return; off = clamp(p.posAt(ctx.currentTime)); stop(); set(2); };
    p.seek = t => { const was = !!src; if (was) stop(); off = clamp(t); if (was) p.play(); };
    p.rate = () => 1;
    p.volume = v => { if (v != null) gain.gain.value = v / 100; return gain.gain.value * 100; };
    return p;
  }

  /** iPhone / iPad : sans ça, le bouton « silencieux » coupe tout le son Web Audio. */
  function iosPlayback() {
    if (navigator.audioSession) { try { navigator.audioSession.type = 'playback'; } catch (e) {} return; }
    if (!/iP(hone|ad|od)/.test(navigator.userAgent) && !(/Mac/.test(navigator.userAgent) && 'ontouchend' in document)) return;
    // Anciennes versions : un son HTML muet en boucle fait passer la page en mode « lecture »
    const n = 4000, b = new DataView(new ArrayBuffer(44 + n));
    const str = (o, s) => [...s].forEach((c, i) => b.setUint8(o + i, c.charCodeAt(0)));
    str(0, 'RIFF'); b.setUint32(4, 36 + n, true); str(8, 'WAVEfmt '); b.setUint32(16, 16, true);
    b.setUint16(20, 1, true); b.setUint16(22, 1, true); b.setUint32(24, 8000, true); b.setUint32(28, 8000, true);
    b.setUint16(32, 1, true); b.setUint16(34, 8, true); str(36, 'data'); b.setUint32(40, n, true);
    for (let i = 0; i < n; i++) b.setUint8(44 + i, 128);
    const a = new Audio(URL.createObjectURL(new Blob([b], { type: 'audio/wav' })));
    a.loop = true; a.setAttribute('playsinline', '');
    const go = () => a.play().then(() => ['touchend', 'click'].forEach(e => removeEventListener(e, go, true))).catch(() => {});
    ['touchend', 'click'].forEach(e => addEventListener(e, go, true));
  }
  iosPlayback();

  /** Listes déroulantes sur écran tactile : menu dessiné par la page au lieu du sélecteur natif
   *  (celui d'iOS fait planter Safari sur ces pages chargées). */
  function touchSelects() {
    if (!matchMedia('(pointer: coarse)').matches) return;
    let menu = null;
    const close = () => { if (menu) { menu.remove(); menu = null; } };
    const open = sel => {
      close();
      menu = document.createElement('div');
      menu.className = 'tmenu';
      [...sel.options].forEach(o => {
        const b = document.createElement('button');
        b.type = 'button'; b.textContent = o.textContent; b.disabled = o.disabled;
        if (o.selected) b.className = 'sel';
        b.onclick = e => {
          e.stopPropagation(); close();
          if (sel.value === o.value) return;
          sel.value = o.value;
          sel.dispatchEvent(new Event('input', { bubbles: true }));
          sel.dispatchEvent(new Event('change', { bubbles: true }));
        };
        menu.appendChild(b);
      });
      (sel.closest('dialog') || document.body).appendChild(menu);
      const r = sel.getBoundingClientRect(), h = menu.offsetHeight, w = Math.max(r.width, menu.offsetWidth);
      menu.style.left = `${Math.max(8, Math.min(r.left, innerWidth - w - 8))}px`;
      menu.style.minWidth = `${r.width}px`;
      menu.style.top = `${r.bottom + 4 + h < innerHeight ? r.bottom + 4 : Math.max(8, r.top - 4 - h)}px`;
      const cur = menu.querySelector('.sel');
      if (cur) menu.scrollTop = cur.offsetTop - menu.clientHeight / 2;
    };
    const grab = e => {
      if (menu && menu.contains(e.target)) return;
      close();
      const sel = e.target.closest && e.target.closest('select');
      if (!sel || sel.disabled || sel.multiple) return;
      e.preventDefault();   // pas de sélecteur natif
      open(sel);
    };
    addEventListener('touchstart', grab, { capture: true, passive: false });
    addEventListener('mousedown', grab, true);
    addEventListener('scroll', e => { if (menu && !menu.contains(e.target)) close(); }, true);
  }
  touchSelects();

  /** Lecteur d'un fichier audio (copie MP3 de l'enregistrement), même interface que youtube(). */
  function audioFile(url, { onState, onError } = {}) {
    const a = new Audio();
    a.preload = 'auto';
    const p = { ready: false, state: -1, audio: a };
    const set = st => { p.state = st; if (onState) onState(st); };
    p.whenReady = new Promise(res => {
      a.addEventListener('loadedmetadata', () => { p.ready = true; res(p); }, { once: true });
      a.addEventListener('error', () => { if (onError) onError(a.error && a.error.code); res(p); }, { once: true });
    });
    a.addEventListener('playing', () => set(1));
    a.addEventListener('pause', () => set(a.ended ? 0 : 2));
    a.addEventListener('waiting', () => set(3));
    // Fichier chargé en entier puis lu depuis la mémoire : les sauts marchent même si
    // l'hébergeur ne gère pas les requêtes partielles (« Range »)
    fetch(url).then(r => { if (!r.ok) throw new Error(r.status); return r.blob(); })
      .then(blob => { a.src = URL.createObjectURL(blob); })
      .catch(() => { a.src = url; });
    p.playing = () => p.state === 1;
    p.time = () => a.currentTime || 0;
    p.duration = () => (isFinite(a.duration) ? a.duration : 0);
    p.play = () => a.play().catch(() => {});
    p.pause = () => a.pause();
    p.seek = t => { if (p.ready) a.currentTime = Math.max(0, Math.min(t, p.duration() || t)); };
    p.rate = r => { if (r) a.playbackRate = r; return a.playbackRate || 1; };
    p.volume = v => { if (v != null) a.volume = v / 100; return a.volume * 100; };
    return p;
  }

  // ======================================================================
  // Éditeur de structure (couplets + passages)
  // ======================================================================
  /**
   * cfg = { verses: [1,2,3], custom: null | [[a,b,v],...] }
   * opts = { model, meta, readOnly, note, onChange(cfg), duration(order) -> secondes }
   */
  function structureEditor(root, opts) {
    const { model, meta } = opts;
    const st = meta.structure;
    const N = st ? st.verses : 1;
    const names = (st && st.names) || {};
    const verseName = v => names[v] || `Couplet ${v}`;
    let cfg = opts.cfg;
    const orderOf = c => c.custom || (st ? generateOrder(st, c.verses) : defaultOrder(meta, null, model.END));
    const positions = () => {
      const set = new Set(model.measureList.map(x => x.t));
      set.add(model.END);
      const addFrom = o => (o || []).forEach(([a, b]) => { set.add(a); set.add(b); });
      if (st) {
        ['intro', 'between', 'last', 'outro'].forEach(k => addFrom(st[k]));
        ['couplet', 'lastCouplet'].forEach(k => Object.values(st[k] || {}).forEach(addFrom));
      }
      addFrom(orderOf(cfg));
      return [...set].filter(x => x >= -EPS && x <= model.END + EPS).sort((a, b) => a - b);
    };
    const beat = (meta.tempo && meta.tempo.unit) || 0.25;
    const fromLabel = w => {
      const ms = model.measureAt(w);
      if (Math.abs(ms.t - w) < EPS) return `début mes. ${ms.m}`;
      return `mes. ${ms.m}, temps ${fmtBeats((w - ms.t) / beat + 1)}`;
    };
    const toLabel = w => {
      if (w >= model.END - EPS) return 'fin du chant';
      const i = model.measureList.findIndex(x => Math.abs(x.t - w) < EPS);
      if (i > 0) return `fin mes. ${model.measureList[i - 1].m}`;
      const ms = model.measureAt(w);
      return `mes. ${ms.m}, fin du temps ${fmtBeats((w - ms.t) / beat)}`;
    };
    function emit(c) { cfg = c; render(); if (opts.onChange) opts.onChange(cfg, orderOf(cfg)); }

    function render() {
      const order = orderOf(cfg);
      const pos = positions();
      const ro = opts.readOnly;
      let h = '';
      if (opts.note) h += `<p class="st-note">${opts.note}</p>`;
      if (st && N > 1) {
        h += `<div class="st-row"><span class="st-lbl">${st.names ? 'Passages' : 'Couplets'}</span><div class="st-chips">`;
        for (let v = 1; v <= N; v++) {
          const on = cfg.custom ? versesOfOrder(order).includes(v) : cfg.verses.includes(v);
          h += `<button class="chip${on ? ' on' : ''}" data-verse="${v}" style="--c:${verseColor(v)}" ${ro || cfg.custom ? 'disabled' : ''} title="${esc(verseName(v))}">${st.names ? esc(verseName(v)) : v}</button>`;
        }
        h += `</div>`;
        if (!ro && !cfg.custom) h += `<button class="st-link" data-all>${cfg.verses.length === N ? '1 seul' : 'Tous'}</button>`;
        h += `</div>`;
      }
      if (cfg.custom && !ro) h += `<div class="st-custom">Plan personnalisé. <button class="st-link" data-reset>Revenir au plan des couplets</button></div>`;
      h += `<ol class="st-list">`;
      order.forEach(([a, b, v], i) => {
        const opt = (sel, lab, filt) => pos.filter(filt).map(w => `<option value="${w}"${Math.abs(w - sel) < EPS ? ' selected' : ''}>${lab(w)}</option>`).join('');
        const vopts = Array.from({ length: Math.max(N, v) }, (_, k) => k + 1).map(k => `<option value="${k}"${k === v ? ' selected' : ''}>${esc(verseName(k))}</option>`).join('');
        h += `<li class="st-seg" data-i="${i}" style="--c:${verseColor(v)}">
          <span class="st-n">${i + 1}</span>
          <div class="st-fields">
            <div class="st-range">
              <select class="st-sel" data-f="a" ${ro ? 'disabled' : ''}>${opt(a, fromLabel, w => w < model.END - EPS)}</select>
              <span class="st-arrow">→</span>
              <select class="st-sel" data-f="b" ${ro ? 'disabled' : ''}>${opt(b, toLabel, w => w > 0)}</select>
            </div>
            <select class="st-sel st-verse" data-f="v" ${ro ? 'disabled' : ''}>${vopts}</select>
          </div>
          ${ro ? '' : `<div class="st-tools">
            <button data-act="up" title="Monter" ${i === 0 ? 'disabled' : ''}>↑</button>
            <button data-act="down" title="Descendre" ${i === order.length - 1 ? 'disabled' : ''}>↓</button>
            <button data-act="dup" title="Dupliquer (répéter ce passage)">⧉</button>
            <button data-act="del" title="Supprimer" ${order.length < 2 ? 'disabled' : ''}>✕</button>
          </div>`}
        </li>`;
      });
      h += `</ol>`;
      if (!ro) h += `<button class="st-add" data-add>+ Ajouter un passage</button>`;
      const P = order.reduce((s, [a, b]) => s + (b - a), 0);
      const nm = measureSteps(model, makePlan(order, model.END)).length;
      const dur = opts.duration ? opts.duration(order) : null;
      h += `<p class="st-sum">${order.length} passage${order.length > 1 ? 's' : ''} · ${nm} mesures jouées${dur ? ` · ${fmt(dur)}` : ''}${P <= EPS ? ' · plan vide' : ''}</p>`;
      root.innerHTML = h;
    }
    root.addEventListener('click', e => {
      const b = e.target.closest('button');
      if (!b || b.disabled || opts.readOnly) return;
      if (b.dataset.verse) {
        const v = +b.dataset.verse;
        let vs = cfg.verses.includes(v) ? cfg.verses.filter(x => x !== v) : [...cfg.verses, v].sort((x, y) => x - y);
        if (!vs.length) vs = [v];
        emit({ verses: vs, custom: null });
      } else if ('all' in b.dataset) {
        emit({ verses: cfg.verses.length === N ? [1] : allVerses(st), custom: null });
      } else if ('reset' in b.dataset) {
        emit({ verses: cfg.verses, custom: null });
      } else if ('add' in b.dataset) {
        const o = orderOf(cfg).map(x => x.slice());
        const l = o[o.length - 1];
        o.push(l ? l.slice() : [0, model.END, 1]);
        emit({ verses: cfg.verses, custom: o });
      } else if (b.dataset.act) {
        const i = +b.closest('.st-seg').dataset.i;
        const o = orderOf(cfg).map(x => x.slice());
        if (b.dataset.act === 'up') [o[i - 1], o[i]] = [o[i], o[i - 1]];
        if (b.dataset.act === 'down') [o[i + 1], o[i]] = [o[i], o[i + 1]];
        if (b.dataset.act === 'dup') o.splice(i + 1, 0, o[i].slice());
        if (b.dataset.act === 'del') o.splice(i, 1);
        emit({ verses: cfg.verses, custom: o });
      }
    });
    root.addEventListener('change', e => {
      const s = e.target.closest('.st-sel');
      if (!s) return;
      const i = +s.closest('.st-seg').dataset.i;
      const o = orderOf(cfg).map(x => x.slice());
      const f = s.dataset.f, val = +s.value;
      if (f === 'a') { o[i][0] = val; if (o[i][1] <= val) o[i][1] = positions().find(w => w > val + EPS) ?? model.END; }
      if (f === 'b') { o[i][1] = val; if (o[i][0] >= val) o[i][0] = [...positions()].reverse().find(w => w < val - EPS) ?? 0; }
      if (f === 'v') o[i][2] = val;
      emit({ verses: cfg.verses, custom: o });
    });
    render();
    return {
      set(c) { cfg = c; render(); },
      get: () => cfg,
      order: () => orderOf(cfg),
      setReadOnly(ro, note) { opts.readOnly = ro; opts.note = note; render(); },
    };
  }
  /** Configuration de structure par défaut / validée. */
  function structureConfig(meta, saved) {
    const st = meta.structure;
    const N = st ? st.verses : 1;
    const ok = c => c && Array.isArray(c.verses) && c.verses.every(v => v >= 1 && v <= N);
    if (ok(saved)) return { verses: saved.verses.length ? saved.verses : allVerses(st), custom: Array.isArray(saved.custom) && saved.custom.length ? saved.custom : null };
    return { verses: allVerses(st), custom: null };
  }
  const orderFromConfig = (meta, cfg, END) => cfg.custom || (meta.structure ? generateOrder(meta.structure, cfg.verses) : defaultOrder(meta, null, END));

  // ======================================================================
  // Divers
  // ======================================================================
  function loadScript(src) {
    return new Promise((res, rej) => {
      const s = document.createElement('script');
      s.src = src; s.onload = res; s.onerror = rej;
      document.head.appendChild(s);
    });
  }
  const store = {
    get(k) { try { return JSON.parse(localStorage.getItem(k)); } catch (e) { return null; } },
    set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} },
    del(k) { try { localStorage.removeItem(k); } catch (e) {} },
  };
  function toaster(el) {
    let timer;
    return (msg, ms = 2600) => {
      el.textContent = msg; el.classList.add('show');
      clearTimeout(timer); if (ms) timer = setTimeout(() => el.classList.remove('show'), ms);
    };
  }
  /** Notes jouées par le piano, dans l'ordre joué. */
  function perfEvents(model, plan) {
    const ev = [];
    for (const s of plan.segs) for (const n of model.notes) {
      if (n.silent || n.t < s.a - EPS || n.t >= s.b - EPS) continue;
      ev.push({ P: s.off + (n.t - s.a), dP: Math.min(n.sd, s.b - n.t), n, seg: s });
    }
    return ev.sort((a, b) => a.P - b.P);
  }
  /** Ancien plan sans couplets : un passage qui revient sur des mesures déjà jouées = couplet suivant. */
  function legacyVerses(order) {
    let v = 1;
    const done = [];
    return order.map(([a, b]) => {
      if (done.some(([x, y]) => a < y - EPS && b > x + EPS)) { v++; done.length = 0; }
      done.push([a, b]);
      return [a, b, v];
    });
  }
  /** Lit un fichier de synchro (v1 ou v2) et le ramène au format v2. */
  function normalizeSync(obj, meta, END) {
    if (!obj || !Array.isArray(obj.marks)) return null;
    // Format 1 (sans plan) : positions calculées sur l'ancien plan du chant, un seul passage
    const order = Array.isArray(obj.order) && obj.order.length
      ? obj.order.map(([a, b, v]) => [a, b ?? END, v || 1])
      : legacyVerses(((meta && meta.legacyOrder) || [[0, END]]).map(([a, b]) => [a, b ?? END]));
    const marks = obj.marks.filter(m => typeof m.P === 'number' && typeof m.t === 'number')
      .map(m => ({ key: m.key || null, kind: m.k || m.kind || (m.fin ? 'end' : 'm'), P: m.P, t: m.t, voice: m.voice || m.v }));
    return { ...obj, order, marks, offset: typeof obj.offset === 'number' ? obj.offset : 0 };
  }

  return {
    EPS, NS, VOICE_NAMES, verseColor, esc, fmt, fmtBeats,
    generateOrder, mergeOrder, defaultOrder, versesOfOrder, allVerses, makePlan,
    mountScore, measureSteps, lyricUnits, noteUnits, noteName, timeMap, voiceTimeMap, voiceEvents, tuneAt, tunedFreq, doubler, youtube, audioFile, loadYouTubeApi,
    structureEditor, structureConfig, orderFromConfig, loadScript, bufferAudio, store, toaster, perfEvents, normalizeSync,
  };
})();
