"""Assemble messe-2026-11-01.ly (livret de la messe) puis le grave en PDF.
usage : python messe_book.py"""
import os, re, subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'Partitions remasterisées', 'Messe du 1er novembre 2026 - Toussaint')


def defs(fname, start, prefix, names):
    s = open(os.path.join(HERE, fname), encoding='utf-8').read()
    s = s[s.index(start):s.index('\\score')]
    for n in names:
        s = re.sub(r'\\' + n + r'\b', '\\\\' + prefix + n[0].upper() + n[1:], s)
        s = re.sub(r'^' + n + r' =', prefix + n[0].upper() + n[1:] + ' =', s, flags=re.M)
    return s


gloria = defs('missa-pro-europa-gloria.ly', 'reprise =', 'gl', ['reprise', 'melodie', 'accords', 'paroles'])
alleluia = defs('missa-pro-europa-alleluia.ly', 'refrain = {', 'al',
                ['refrain', 'verset', 'refrainParoles', 'versetParoles', 'accordsRefrain', 'accordsVerset']).replace(r'\bold "D.C."', r'\italic "D.C."')


def score(parts):
    """parts : (accords, musique, [paroles...])"""
    acc, mus, lyr = parts
    vid = 'v' + str(abs(hash(mus)) % 10**6)
    # psalmodie du Gloria (sans mesure) : pas de numéros de mesure
    nobar = '\\context { \\Score \\remove "Bar_number_engraver" }' if mus == 'glMelodie' else ''
    ly = '\n'.join(f'      \\new Lyrics \\lyricsto "{vid}" \\{l}' for l in lyr)
    return f'''  \\score {{
    <<
      \\new ChordNames \\{acc}
      \\new Staff \\new Voice = "{vid}" \\{mus}
{ly}
    >>
    \\layout {{ \\chorusLayout {nobar} }}
  }}
'''


SONGS = [
    ('Les saints et les saintes de Dieu', 'Hymnes et cantiques', '', '',
     [('lsRefAcc', 'lsRef', ['lsRefTxt']), ('lsCplAcc', 'lsCpl', ['lsV', 'lsVb', 'lsVc'])]),
    ('Kyrie', 'Missa Pro Europa', 'Texte : Missel romain', 'Musique : Jacques Berthier',
     [('kyAcc', 'kyMel', ['kyTxt'])]),
    ('Gloria', 'Missa Pro Europa', 'Texte : Missel romain', 'Musique : Jacques Berthier',
     [('glAccords', 'glMelodie', ['glParoles'])]),
    ('Alleluia', 'Missa Pro Europa', 'Paroles : Frère David (En Calcat)', 'Musique : Jacques Berthier',
     [('alAccordsRefrain', 'alRefrain', ['alRefrainParoles']), ('alAccordsVerset', 'alVerset', ['alVersetParoles'])]),
    ('Heureux, bienheureux', 'Toussaint · Mt 5, 1-12', 'Texte et musique : Communauté de l’Emmanuel',
     'Harmonisation : Alain Langrée',
     [('heRefAcc', 'heRef', ['heRefTxt']), ('heStrAcc', 'heStr', ['heSa', 'heSb', 'heSc', 'heSd']),
      ('heCinqAcc', 'heCinq', ['heCinqTxt'])]),
    ('Sanctus', 'Missa Pro Europa', 'Texte : Missel romain', 'Musique : Jacques Berthier',
     [('saAcc', 'saMel', ['saTxt'])]),
    ('Agnus Dei', 'Missa Pro Europa', 'Texte : Missel romain', 'Musique : Jacques Berthier',
     [('agAAcc', 'agA', ['agATxt']), ('agMAcc', 'agM', ['agMa', 'agMb']), ('agMAcc', 'agD', ['agDTxt'])]),
    ('Céleste Jérusalem', '', 'Paroles d’après l’Apocalypse', 'Musique : S.-E. Vongue',
     [('ceRefAcc', 'ceRef', ['ceRefTxt']), ('ceCplAcc', 'ceCpl', ['ceVa', 'ceVb', 'ceVc'])]),
    ('Il est temps de quitter vos tombeaux', 'Louange', 'Paroles et musique : Chants de l’Emmanuel (V. Hendricks)',
     '© 2007 Éditions de l’Emmanuel',
     [('itRefAcc', 'itRef', ['itRefTxt']), ('itCplAcc', 'itCpl', ['itVa', 'itVb', 'itVc', 'itVd'])]),
]

# Déroulé (les lectures n'ont pas de partition)
ORDER = [
    (0, None), (1, None), (2, None),
    (None, 'Première lecture — Ap 7, 2-4.9-14'), (None, 'Psaume — Ps 23 (24), 1-2, 3-4ab, 5-6'),
    (None, 'Deuxième lecture — 1 Jn 3, 1-3'),
    (3, None), (None, 'Évangile — Mt 5, 1-12a'), (None, 'Prière universelle'),
    (4, None), (5, None), (6, None), (7, None), (8, None),
]


def esc(t):
    return t.replace('"', '\\"')


def build(pages):
    lines = []
    for i, txt in ORDER:
        if i is None:
            lines.append(f'    \\fill-line {{ \\line {{ \\hspace #4 \\fontsize #-1 \\italic \\with-color #(rgb-color 0.45 0.45 0.45) "{esc(txt)}" }} \\null }}')
        else:
            t = SONGS[i][0] + (f' — {SONGS[i][1]}' if SONGS[i][1] == 'Missa Pro Europa' else '')
            lines.append(f'    \\fill-line {{ \\line {{ \\hspace #4 \\fontsize #1 "{esc(t)}" }} \\line {{ \\fontsize #1 "{pages[i]}" \\hspace #4 }} }}')
    cover = '\n    \\vspace #0.8\n'.join(lines)
    parts = []
    for i, (title, sub, poet, comp, scores) in enumerate(SONGS):
        body = ''.join(score(p) for p in scores)
        parts.append(f'''\\bookpart {{
  \\header {{
    title = "{esc(title)}"
    subtitle = "{esc(sub)}"
    poet = "{esc(poet)}"
    composer = "{esc(comp)}"
  }}
{body}}}
''')
    return f'''\\version "2.24.4"
\\include "chorale.ily"
#(set-global-staff-size 19)
\\include "messe-parts.ly"

% ---- Gloria et Alleluia (repris de missa-pro-europa-*.ly)
{gloria}
{alleluia}

\\paper {{
  print-first-page-number = ##t
  ragged-bottom = ##t
  system-system-spacing.basic-distance = #15
  score-system-spacing.padding = #4
  score-markup-spacing.padding = #5
  markup-system-spacing.padding = #3
  oddHeaderMarkup = \\markup \\fill-line {{
    \\unless \\on-first-page-of-part \\fontsize #-2 \\italic \\fromproperty #'header:title
    \\null
    \\unless \\on-first-page-of-part \\fontsize #-2 "Dimanche 1er novembre 2026"
  }}
  evenHeaderMarkup = \\oddHeaderMarkup
  oddFooterMarkup = \\markup \\column {{
    \\fill-line {{
      \\override #'(font-name . "Nimbus Sans") \\fontsize #-3.5 \\with-color #(rgb-color 0.45 0.45 0.45)
        "Tous droits réservés · Cyprien Veyret · Paroisse Saint-Nizier, Lyon"
    }}
    \\vspace #0.2
    \\fill-line {{ \\fontsize #-2 \\fromproperty #'page:page-number-string }}
  }}
  evenFooterMarkup = \\oddFooterMarkup
}}

\\book {{
\\bookpart {{
  \\paper {{ oddFooterMarkup = \\markup \\fill-line {{
      \\override #'(font-name . "Nimbus Sans") \\fontsize #-3.5 \\with-color #(rgb-color 0.45 0.45 0.45)
        "Tous droits réservés · Cyprien Veyret · Paroisse Saint-Nizier, Lyon" }} }}
  \\markup \\column {{
    \\vspace #6
    \\fill-line {{ \\override #'(font-name . "Nimbus Sans Bold") \\fontsize #-1 \\with-color #(rgb-color 0.6 0.1 0.1) "PAROISSE SAINT-NIZIER · LYON" }}
    \\vspace #1.5
    \\fill-line {{ \\override #'(font-name . "C059 Bold") \\fontsize #8 "Dimanche 1er novembre 2026" }}
    \\vspace #0.6
    \\fill-line {{ \\override #'(font-name . "C059 Italic") \\fontsize #3 "Tous les saints et les saintes de Dieu" }}
    \\vspace #1
    \\fill-line {{ \\fontsize #-1 "Mélodies et accords pour les musiciens" }}
    \\vspace #5
    \\fill-line {{ \\override #'(font-name . "Nimbus Sans Bold") \\fontsize #-1 "DÉROULÉ" }}
    \\vspace #1.5
    {cover}
  }}
}}
{''.join(parts)}}}
'''


def lilypond():
    lp = os.environ.get('LILYPOND') or os.path.join(os.environ['LOCALAPPDATA'], 'lilypond-2.24.4', 'bin', 'lilypond.exe')
    src = os.path.join(HERE, 'messe-2026-11-01.ly')
    r = subprocess.run([lp, '-o', OUT, src], cwd=HERE, capture_output=True, text=True, encoding='utf-8', errors='replace')
    print('\n'.join(l for l in r.stderr.splitlines() if re.search(r'rreur|vertissement|rror|arning', l)))
    return r.returncode


def page_starts():
    import fitz
    d = fitz.open(OUT + '.pdf')
    starts, k = [], 0
    for n, p in enumerate(d):
        t = p.get_text()
        if k < len(SONGS) and n > 0 and SONGS[k][0] in t.split('\n')[:12] and 'Dimanche 1er novembre' not in t.split('\n')[0]:
            starts.append(n + 1); k += 1
    return starts, d.page_count


if __name__ == '__main__':
    pages = ['…'] * len(SONGS)
    for _ in range(2):
        open(os.path.join(HERE, 'messe-2026-11-01.ly'), 'w', encoding='utf-8').write(build(pages))
        if lilypond(): raise SystemExit('échec de la gravure')
        st, n = page_starts()
        print('débuts :', st, '/', n, 'pages')
        if len(st) == len(SONGS): pages = st
