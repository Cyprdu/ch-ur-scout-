"""Complète une synchro faite à la main : une seule courbe de tempo pour toutes les voix.

usage : python regulariser.py <chant> [synchro_source.json]
Part des repères existants (paroles, notes, mesures, toutes voix) : à une même position
de la partition, toutes les voix chantent au même instant, donc leurs taps sont fusionnés
(médiane) et les taps incohérents écartés. On en tire une courbe temps <-> partition lisse
(spline de lissage : le tempo varie progressivement, les valeurs rythmiques écrites sont
respectées), puis on pose un repère de note sur chaque attaque de chaque voix.
Les repères de paroles d'origine sont conservés ; l'ancienne synchro est archivée.
"""
import collections, json, os, re, shutil, sys, time
import numpy as np
from scipy.interpolate import make_smoothing_spline

HERE = os.path.dirname(os.path.abspath(__file__))
SITE = os.path.join(os.path.dirname(HERE), 'site')


def load_notes(cid):
    """Notes du lecteur (data.js) ; les suites de liaison sont fusionnées comme dans le lecteur."""
    txt = open(os.path.join(SITE, 'chants', cid, 'data.js'), encoding='utf-8').read()
    notes = []
    for m in re.finditer(r'class=\\"nh\\"([^>]*)', txt):
        a = dict(re.findall(r'data-(\w+)=\\"([^\\]*)\\"', m.group(1)))
        notes.append({'v': a['v'], 't': float(a['t']), 'p': int(a['p']), 'd': float(a['d']),
                      'm': int(a.get('m', 0)), 'tie': a.get('tie') == '1'})
    key = {(n['v'], n['p'], round(n['t'], 4)): n for n in notes}
    for n in sorted(notes, key=lambda n: n['t']):
        n.setdefault('root', n)
        n['root'].setdefault('sd', n['root']['d'])
        if n['tie']:
            nx = key.get((n['v'], n['p'], round(n['t'] + n['d'], 4)))
            if nx:
                nx['root'] = n['root']; nx['silent'] = True; n['root']['sd'] += nx['d']
    return [n for n in notes if not n.get('silent')]


def perf_events(notes, order):
    """Attaques dans l'ordre chanté : position jouée P (rondes), voix, position écrite w."""
    ev, off, segs = [], 0.0, []
    for a, b, v in order:
        segs.append((a, b, v, off))
        for n in notes:
            if a - 1e-6 <= n['t'] < b - 1e-6:
                ev.append({'P': off + n['t'] - a, 'v': n['v'], 'w': n['t'], 'seg': len(segs) - 1})
        off += b - a
    return sorted(ev, key=lambda e: e['P']), off, segs

TAP_RMS = 0.05        # imprécision visée d'un tap (s) : règle la force du lissage
OUTLIER = 0.25        # écart (s) au-delà duquel un tap est écarté
VOICE_DRIFT = 0.20    # écart (s) d'une voix avec les autres voix au-delà duquel son tap est écarté


SURE_MAX = 0.10      # écart max (s) toléré sur un repère fiable (note tapée, ou voix d'accord)


def fit(P, T, W, sure):
    """Spline de lissage la plus lisse possible qui reste à TAP_RMS en moyenne de tous les taps
    et à SURE_MAX au plus des repères fiables (points d'orgue, ralentis compris)."""
    best = None
    for lam in np.logspace(-8, 0, 33):
        f = make_smoothing_spline(P, T, w=W, lam=lam)
        r = f(P) - T
        if np.sqrt(np.average(r ** 2, weights=W)) <= TAP_RMS and (not sure.any() or np.abs(r[sure]).max() <= SURE_MAX):
            best = f
        else:
            break
    return best or make_smoothing_spline(P, T, w=W, lam=1e-8)


def main():
    cid = sys.argv[1]
    path = os.path.join(SITE, 'chants', cid, 'synchro.json')
    src = json.load(open(sys.argv[2] if len(sys.argv) > 2 else path, encoding='utf-8'))
    order = src['order']
    marks = [m for m in src['marks'] if m.get('k') in ('l', 'n', 'm')]
    end = next((m for m in src['marks'] if m.get('k') == 'end'), None)

    # 1. fusion par position (toutes voix), puis rejet des taps incohérents (2 passes)
    by, notes_tapped = collections.defaultdict(list), collections.defaultdict(list)
    for m in marks:
        by[round(m['P'], 6)].append(m['t'])
        if m['k'] == 'n':
            notes_tapped[round(m['P'], 6)].append(m['t'])
    P = np.array(sorted(by))
    good = {p: list(by[p]) for p in P}          # taps retenus par position

    def summary(ps):
        T = np.array([np.median(good[p]) for p in ps])
        W = np.array([len(good[p]) for p in ps], float)
        # fiable : note tapée retenue, ou au moins deux taps d'accord à 0,15 s près
        sure = np.array([any(t in good[p] for t in notes_tapped[p]) or
                         (len(good[p]) >= 2 and max(good[p]) - min(good[p]) < 0.15) for p in ps])
        return T, W, sure

    # a) chaque source (paroles S, paroles A, notes S…) est comparée aux AUTRES sources
    #    autour d'elle (±1 ronde) : une voix qui décroche est écartée, même seule à sa position
    src_of = lambda m: (m['k'], m.get('v'))
    drop = set()
    for s in {src_of(m) for m in marks if m['k'] != 'n'}:     # les notes tapées font foi
        others = collections.defaultdict(list)
        for m in marks:
            if src_of(m) != s:
                others[round(m['P'], 6)].append(m['t'])
        oP = np.array(sorted(others))
        if len(oP) < 2:
            continue
        oT = np.array([np.median(others[p]) for p in oP])
        for i, m in enumerate(marks):
            if src_of(m) != s:
                continue
            l, r = oP[oP <= m['P']], oP[oP >= m['P']]
            near = sum(len(others[p]) for p in oP[np.abs(oP - m['P']) <= 0.5])
            if len(l) and len(r) and m['P'] - l[-1] <= 1 and r[0] - m['P'] <= 1 and near >= 2:
                if abs(m['t'] - np.interp(m['P'], oP, oT)) > VOICE_DRIFT:
                    drop.add(i)
    by = collections.defaultdict(list)
    for i, m in enumerate(marks):
        if i not in drop:
            by[round(m['P'], 6)].append(m['t'])
    for p in list(by):
        good[p] = list(by[p])
    for p in [p for p in good if p not in by]:
        good[p] = []
    # b) puis chaque tap restant face à la courbe de la majorité
    for _ in range(3):
        Pk = np.array([p for p in P if good[p]])
        f = fit(Pk, *summary(Pk))
        good = {p: [t for t in by.get(p, []) if abs(t - f(p)) < OUTLIER] for p in P}
    keep = np.array([bool(good[p]) for p in P])
    T = np.array([np.median(good[p]) if good[p] else np.nan for p in P])
    f = fit(P[keep], *summary(P[keep]))
    res = f(P[keep]) - T[keep]
    rejected = [m for m in marks if m['t'] not in good[round(m['P'], 6)]]
    print(f'{len(marks)} taps -> {len(P)} positions ; {len(rejected)} taps écartés ; '
          f'écart moyen des autres {np.sqrt(np.mean(res ** 2)) * 1000:.0f} ms')
    for m in sorted(rejected, key=lambda m: m['P']):
        print(f"  écarté : P={m['P']:g} {m['k']} {m.get('v', '')} « {m.get('tx', '')} » tap {m['t']:.2f} s, courbe {float(f(m['P'])):.2f} s")

    # 2. courbe monotone (sécurité) sur une grille fine
    grid = np.linspace(0, max(P.max(), 1e-3), 20000)
    tg = np.maximum.accumulate(f(grid))
    to_t = lambda x: float(np.interp(x, grid, tg)) if x <= grid[-1] else float(tg[-1] + (x - grid[-1]) * (tg[-1] - tg[-200]) / (grid[-1] - grid[-200]))

    # 3. un repère par attaque de chaque voix (+ mesures), paroles d'origine conservées
    notes = load_notes(cid)
    END = max(n['t'] + n['sd'] for n in notes)
    order = [[a, END if b is None else b, v] for a, b, v in order]
    ev, total, segs = perf_events(notes, order)
    js = lambda x: repr(float(x))[:-2] if float(x).is_integer() else repr(float(x))
    sig = lambda s: f'{js(segs[s][0])}-{js(segs[s][1])}-{segs[s][2]}#1'
    # paroles : tes taps sont gardés, sauf ceux écartés (recalés sur la courbe)
    out, seen = [], set()
    for m in src['marks']:
        if m.get('k') == 'l':
            m = dict(m)
            if m['t'] not in good.get(round(m['P'], 6), ()):
                m['t'] = round(to_t(m['P']), 3)
            out.append(m)
    for e in ev:
        k = f"n|{e['v']}|{sig(e['seg'])}|{js(e['w'])}"
        if k not in seen:
            seen.add(k)
            out.append({'key': k, 'k': 'n', 'P': round(e['P'], 6), 't': round(to_t(e['P']), 3), 'v': e['v'], 'tx': ''})
    mstarts = sorted({min(n['t'] for n in notes if n['m'] == m) for m in {n['m'] for n in notes}})
    for s, (a, b, v, off) in enumerate(segs):
        for w in [a] + [x for x in mstarts if a + 1e-6 < x < b - 1e-6]:
            out.append({'key': f'm|{sig(s)}|{js(w)}', 'k': 'm', 'P': round(off + w - a, 6), 't': round(to_t(off + w - a), 3)})
    out.append(end or {'key': 'end', 'k': 'end', 'P': total, 't': round(to_t(total), 3)})

    arch = os.path.join(HERE, 'synchro-archive', f"{cid}-{time.strftime('%Y%m%d-%H%M%S')}.json")
    shutil.copy(path, arch)
    data = dict(src, order=order, marks=out, created=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()))
    data.pop('auto', None)
    json.dump(data, open(path, 'w', encoding='utf-8'), ensure_ascii=False)
    print(f'{len(out)} repères écrits ; ancienne version archivée : {os.path.relpath(arch, HERE)}')


if __name__ == '__main__':
    main()
