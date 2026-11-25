"""Écrit les fichiers .ly à 4 voix des chants de la veillée de Noël (gabarit commun).
usage : python satb_gen.py"""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
V = [('sop', 'S', 'Soprano', ''), ('alto', 'A', 'Alto', ''), ('ten', 'T', 'Ténor', r'\clef "treble_8"'), ('bas', 'B', 'Basse', r'\clef bass')]


def nb(t):
    return t.replace(' !', '!').replace(' ?', '?')


def skips(t):
    """nombre de syllabes d'un texte (notes à sauter)"""
    return len([w for w in nb(t).split(' ') if w and w not in ('--', '__')])


def make(fn, header, glob, music, lyrics, chords='', hide_empty=False, size=17):
    """lyrics[voix] = lignes ; une ligne = liste de (couplet | None, texte | nombre de notes sautées)"""
    o = ['\\version "2.24.4"', '\\include "chorale.ily"', f'#(set-global-staff-size {size})', '', '\\header {']
    o += [f'  {k} = "{v}"' for k, v in header.items()] + ['}', '', 'global = {', glob.strip('\n'), '}', '']
    for (n, tag, name, clef), m in zip(V, music):
        o += [f'{n}Mus = {{', m.strip('\n'), '}', '']
    staves = []
    for (n, tag, name, clef), lines in zip(V, lyrics):
        ls = ''
        for i, line in enumerate(lines):
            txt = []
            for st, t in line:
                if isinstance(t, int):
                    txt.append(f'\\repeat unfold {t} \\skip 1')
                    continue
                txt.append(('\\unset stanza' if st is None else f'\\set stanza = "{st}."') + ' ' + nb(t))
            var = f'{n}Lyr{"ABCDEF"[i]}'
            o += [f'{var} = \\lyricmode {{', '  ' + '\n  '.join(txt), '}', '']
            it = '\\with \\italicVerse ' if i % 2 else ''
            ls += f'\n      \\new Lyrics {it}\\lyricsto "{n}" \\{var}'
        hide = r' \override VerticalAxisGroup.remove-first = ##t' if hide_empty else ''
        staves.append(f'''      \\new Staff \\with {{ instrumentName = "{name}" shortInstrumentName = "{tag}"{hide} }} <<
        \\global {clef}
        \\new Voice = "{n}" \\with \\voiceAttrs "{tag}" {{ \\{n}Mus }}
      >>{ls}''')
    ch = ''
    if chords:
        o += ['accords = \\chordmode {', chords.strip('\n'), '}', '']
        ch = '    \\new ChordNames \\accords\n'
    o += ['\\score {\n  <<\n' + ch + '    \\new ChoirStaff <<\n' + '\n'.join(staves)
          + '\n    >>\n  >>\n  \\layout {\n    \\chorusLayout\n    indent = 16\\mm\n    short-indent = 7\\mm',
          '    \\context { \\Lyrics \\override LyricText.font-size = #0 }']
    if hide_empty:
        o.append('    \\context { \\Staff \\RemoveEmptyStaves }')
    o.append('  }\n}\n')
    open(os.path.join(HERE, fn), 'w', encoding='utf-8').write('\n'.join(o))


TDR = 'Tous droits réservés · Chorale Scouts de Lyon'

# ================================================================= Maintenant, Seigneur
REF = 'Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser m’en al -- ler dans la paix. '
FIN = 'Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser re -- po -- ser. '
m_s = REF + FIN
m_t = 'Main -- te -- nant, tu peux me lais -- ser m’en al -- ler dans la paix. ' + FIN
m_b = 'Main -- te -- nant, tu peux me lais -- ser dans la paix. ' + FIN
make('maintenant.ly', dict(title='Maintenant, Seigneur', poet='Paroles : d’après Lc 2, 29-32', composer='Musique : Sœur Luce Martens',
     copyright='© Éditions de l’Emmanuel — ' + TDR),
r'''  \key a \minor
  \time 2/4
  \tempo 4 = 66
  \sectionLabel "REFRAIN"
  \partial 4 s4 | s2*5 \break s2*6 \bar "||" \break
  \sectionLabel "COUPLETS" s2*8 \break s2*8 s4 \bar "|."''',
[r'''  e'8 e' | a'4. g'8 | e'4 e' | f' e'8 d' | c'4 a8 a | b4 d'8 c' |
  b4 e'8 e' | a'4. b'8 | c''4 c'' | b' c''8 a' | gis'4 fis'8 e' | a'2 |
  % couplets
  r4 e' | f' f' | f' e'8 d' | e' e' e' f' | e'4. c'8 | d'4 d'8 d' | d'4 c'8 d' | e'2 |
  e'4 c'8 c' | d'4 d'8 d' | d'4 c'8 b | e' e' e' f' | e'4 r | a' a' | c'' a'8 b' | gis'4( fis') | e' ''',
 r'''  r4 | r a8 a | c' b c' c' | d'4 b8 b | a4 a8 a | d'4 d'8 e' |
  e'4 r | c'8 e' fis' gis' | a'4 e' | f' fis' | gis'8 e' d' e' | e'2 |
  R2*16 | r4''',
 r'''  r4 | R2 | e8 e a4 | a8 b gis gis | a4 f8 f | f4 gis8 fis |
  gis4 r | c'8 c' d' d' | c'4 c' | d' a8 c' | b4 d'8 d' | c'2 |
  R2*16 | r4''',
 r'''  r4 | R2 | R2 | d8 d e4 | a,8 c d4 | d8 b, e e |
  e4 r | a8 a d e | a4 a | d dis8 dis | e4 e8 e | a,2 |
  R2*16 | r4'''],
[[[(None, m_s), ('1', 'Tu peux lais -- ser s’en al -- ler ton ser -- vi -- teur en paix __ _ se -- lon ta pa -- ro -- le, car mes yeux ont __ _ vu le sa -- lut que tu pré -- pares à la fa -- ce des peu -- ples.')],
  [(None, skips(m_s)), ('2', 'Lu -- miè -- re pour é -- clai -- rer __ _ les na -- tions et gloire d’Is -- ra -- ël ton __ _ peu -- ple. Gloire au Père, et au Fils, et au Saint -- _ Es -- _ prit pour les siè -- cles des siè -- cles.')]],
 [[(None, m_s)]], [[(None, m_t)]], [[(None, m_b)]]],
chords=r'''  s4 | \ch "Lam" 2 s2 | \ch "Rém" 4 \ch "Mi" 4 | \ch "Lam" 4 \ch "Rém" 4 | \ch "Mi7" 2 |
  s2 | \ch "Lam" 4. \ch "Mi7" 8 | \ch "Lam" 2 | \ch "Rém6" 2 | \ch "Mi7" 2 | \ch "Lam" 2 |
  s2 | \ch "Rém" 2 s2 | \ch "Lam" 2 s2 | \ch "Mi7" 2 s2 | \ch "Lam" 2 |
  s2 | \ch "Rém" 2 s2 | \ch "Lam" 2 s2 | \ch "Fa" 2 s2 | \ch "Mi7" 2 | s4''', hide_empty=True)

# ================================================================= Venez tous, accourez
c = ['Tout le ciel s’em -- plit d’u -- ne joie nou -- velle; __ _ On en -- tend la nuit di -- re la mer -- veil -- le. Fê -- te sans pa -- reil -- le; Le Sau -- veur est né; ',
     'Le Sei -- gneur pa -- raît, Ver -- be de lu -- mière; __ _ L’u -- ni -- vers con -- naît la bon -- té du Pè -- re. Dieu sur no -- tre ter -- re; Vient tra -- cer la voie; ',
     'A -- vec les ber -- gers, a -- vec tous les sages; __ _ C’est le monde en -- tier qui vers Lui s’en -- ga -- ge Pour voir le vi -- sa -- ge de l’A -- mour vi -- vant; ',
     'Gloire à Jé -- sus Christ, Gloire au Fils du Père; __ _ Gloire à son Es -- prit dont l’A -- mour é -- clai -- re. L’é -- cla -- tant mys -- tè -- re qui rem -- plit le Ciel; ']
fd = ['L’En -- fant Dieu nous est don -- né !', 'Où che -- mi -- ne -- ront nos pas !', 'qui pour nous s’est fait en -- fant !', 'Gloire à l’Hom -- me Dieu, No -- ël !']
assert {skips(x) for x in c} == {33} and {skips(x) for x in fd} == {7}, [skips(x) for x in c + fd]
far = 'Ve -- nez tous, ac -- cou -- rez, à la crèche, ve -- nez a -- do -- rer, car l’en -- fant qui y est cou -- ché, est le Roi du Ciel. Il vient pour nous sau -- ver de la mort et du pé -- ché, car Il vient pour nous em -- me -- ner vers la Vie é -- ter -- nel -- le !'
LU = [[(str(i + 1), c[i] + fd[i])] + ([(None, far)] if i == 0 else []) for i in range(4)]
LD = [[(None, 9), (str(i + 1), fd[i])] + ([(None, far)] if i == 0 else []) for i in range(4)]
bf = r'^\markup \italic "B.F."'
make('venez.ly', dict(title='Venez tous, accourez…', composer='Musique : Benoît Collet', copyright='Édition ParFreeTion — ' + TDR),
r'''  \key g \major
  \time 4/4
  \tempo 4 = 115
  \sectionLabel "COUPLETS"
  s1*4 \break s1*3 \time 2/4 s2 \bar "||" \break
  \sectionLabel "FARANDOLE" s2*8 \break s2*8 \bar "|."''',
[r'''  b8 dis' e' fis' g'2 | a'8 g' fis' e' dis'4 dis' | b8 dis' fis' g' a'2 | b'8 a' g' fis' e'4 e' |
  c''8 c'' b' a' b'4 b' | c''8 c'' b' a' b'2 | a'4 c'' b'8 a' g' fis' | e'2 |
  b'8 b' b' a'16 b' | c''4. c''16 b' | a'8 a' a' g'16 a' | b'4. b'16 a' | g'8 g' g' fis'16 g' | a'4 c'' | dis' b'8 a' | g'2 |
  b'8 b' b' a'16 b' | c''4. c''16 b' | a'8 a' a' g'16( a') | b'4. b'16 a' | g'8 g' g' fis'16 g' | a'4 c'' | fis'8 fis' fis' e' | e'4 e' |''',
 r'''  b8 dis' e' fis' g'2 | a'8 g' fis' e' dis'4 dis' | b8 dis' fis' g' a'2 | b'8 a' g' fis' e'4 e' |
  a'8 a' g' fis' g'4 g' | a'8 a' g' fis' g'2 | fis'4 a' g'8 fis' e' dis' | e'2 |
  g'8 g' g' fis'16 g' | a'4. a'16 g' | fis'8 fis' fis' e'16 fis' | g'4. g'16 fis' | e'8 e' e' dis'16 e' | fis'4 fis' | fis' fis'8 fis' | e'2 |
  g'8 g' g' fis'16 g' | a'4. a'16 g' | fis'8 fis' fis' e'16( fis') | g'4. g'16 fis' | e'8 e' e' dis'16 e' | fis'4 a' | dis'8 dis' dis' b | b4 b |''',
 r'  fis1' + bf + r''' | fis | fis | fis2 g | c' b | c' b | c'4 b b8 b b a | g2 |
  e'8 e' e' e'16 e' | e'4. e'16 e' | d'8 d' d' d'16 d' | d'4. d'16 c' | c'8 c' c' c'16 c' | c'4 c' | b b8 b | b2 |
  e'8 e' e' e'16 e' | e'4. e'16 e' | d'8 d' d' d' | d'4. d'16 d' | c'8 c' c' c'16 c' | c'4 c' | b8 b a g | g4 g |''',
 r'  b,1' + bf + r''' | b, | b, | b,2 e | a, e | a, e | a,4 a, b,8 b, b, b, | e2 |
  e8 e e e16 e | a4. a16 a | d8 d d d16 d | g4. g16 g | c8 c c c16 b, | a,4 a, | b, cis8 dis | e2 |
  e8 e e e16 e | a4. a16 a | d8 d d d | g4. g16 g | c8 c c c16 b, | a,4 a, | b,8 b, b, b, | e4 e |'''],
[LU, LU, LD, LD])

# ================================================================= Il est au milieu de nous
rs = 'Il est pré -- sent par -- mi nous puis -- qu’Il nous aime, Il s’est sa -- cri -- fié pour nous, '
baps = 'Il est au mi -- lieu de nous. '
RS = rs + 'res -- su -- ci -- té, Il nous ré -- vè -- le Sa vie par Son Bap -- tême. ' + baps
RA = rs + 'Dieu res -- su -- sci -- té! Oui, par Son Bap -- tême, ' + baps
RB = 'Il est pré -- sent par -- mi nous, Il s’est sa -- cri -- fié pour nous, res -- su -- sci -- té! Oui, par Son Bap -- tême, ' + baps
C = ['Bap -- ti -- sé par Saint Jean -- Bap -- tiste, Il in -- vite à la con -- ver -- sion. Par ce bap -- tême, Jé -- sus, le Christ, nous mon -- tre qu’Il est a -- vec nous. Ce bap -- tême d’eau, vient an -- non -- cer l’heure de la Croix où par a -- mour, Il fran -- chi -- ra, l’eau de la mort pour nous faire vi -- vre pour tou -- jours.',
     'Par le Bap -- tême d’Eau et d’Es -- prit, Il nous fait tra -- ver -- ser les eaux. Par ce bap -- tême, nous de -- ve -- nons en -- fants de Dieu, par Son Es -- prit. Il veut nous faire par -- ti -- ci -- per au mys -- tè -- re de Sa Pas -- sion. Il veut nous faire par -- ti -- ci -- per à Sa sain -- te Ré -- sur -- rec -- tion.',
     'Lors du Re -- pas, Il ins -- ti -- tue, le mys -- tère de l’Eu -- cha -- ris -- tie. Il fit ce -- la, pour que ma foi puisse tou -- jours s’a -- breu -- ver de Lui. Mort sur la Croix, pour nous sau -- ver, en por -- tant nos nom -- breux pé -- chés, Lui qui est roi, Il nous ra -- chète, Il est vrai -- ment res -- su -- sci -- té.']
assert len({skips(x) for x in C}) == 1, [skips(x) for x in C]


def lyr(R, lead):
    return [[(None, R), ('1', C[0]), (None, lead)]] + [[(None, skips(R)), (str(i + 1), C[i])] for i in (1, 2)]


LS = 'Il est pré -- sent par -- mi'
make('milieu.ly', dict(title='Il est au milieu de nous', composer='Paroles et musique : Thibault Fromant', copyright='Ad Dei Gloriam — ' + TDR),
r'''  \key g \major
  \time 4/4
  \tempo 4 = 120
  \sectionLabel "REFRAIN"
  s1*4 \break s1*5 \bar "||" \break
  \sectionLabel "COUPLETS" s1*4 \break s1*4 \break s1*4 \break s1*4
  \mark \markup \small \italic "puis refrain (m. 2)" s1 \bar "|."''',
[r'''  r4 e'8 e' b' a' g' a' | b'4 e' g' b' | c'' e'8 e' c'' b' a' g' | a'4 d' fis' a' |
  b' fis'8 fis' b' a' g' a' | g'4 e' fis' g' | a' fis'8 fis' a' a' g' a' | b'1~ | b' |
  r8 g' g' fis' g'2 | r8 g' g' fis' g'2 | r8 g' g' g' fis'4 fis' | fis' e' fis'2 |
  r8 b' b' a' b'2 | r8 b' b' a' b'2 | r8 b' b' b' a'4 a' | a' b' a'2 |
  r8 g' g' fis' g'2 | r8 g' g' fis' g'2 | r8 g' g' g' fis'4 fis' | fis' g' a'2 |
  r8 b' b' a' b'2~ | b'8 b' b' a' b'2~ | b'8 g' g' a' b'4 b' | b' c'' b'2~ |
  b'4 e'8 e' b' a' g' a' |''',
 r'''  r4 e'8 e' g' fis' e' fis' | g'4 b e' g' | a' c'8 c' a' g' fis' e' | fis'4 d' d' fis' |
  fis'2 fis' | e'4 e' e' e' | e' e'8 e' e' e' e' e' | fis'1~ | fis' |
  r8 g' fis' e' e'2 | r8 g' fis' e' e'2 | r8 e' e' e' d'4 d' | d' d' d'2 |
  r8 b' a' a' g'2 | r8 b' a' a' g'2 | r8 g' g' g' fis'4 fis' | fis' g' fis'2 |
  r8 g' fis' e' e'2 | r8 g' fis' e' e'2 | r8 e' e' e' d'4 d' | d' e' fis'2 |
  r8 b' a' a' a'4( g' | g'8) b' a' a' g'4( fis' | e'8) g' g' g' g'4 g' | g' g' fis'2~ |
  fis'4 e'8 e' g' fis' e' fis' |''',
 r'''  r4 b8 b b b b b | b4 g b b | a a8 b c' d' e' e' | d'4 b d' d' |
  dis'2 dis' | e'4 d' d' c' | a b8 b c' d' e' e' | e'1( | dis') |
  r8 b b b b2 | r8 b b b b2 | r8 e fis g a4 a | fis b a2 |
  r8 d' d' d' d'2 | r8 d' d' d' d'2 | r8 g a b d'4 d' | a a a2 |
  r8 b b b b2 | r8 b b b b2 | r8 e fis g a4 a | b b a2 |
  r8 d' d' d' d'2~ | d'8 d' d' d' d'2~ | d'8 g g g g4 g | c' e' e'2( |
  dis'4) b8 b b b b b |''',
 r'''  r2 e4 e | e e e e | c a, d a, | d g fis d |
  b, b, dis b, | c c c c | c a,8 a, a, a, c c | b,1~ | b, |
  r8 e e e e2 | r8 e e e e2 | r8 c c b, d4 b, | a, b, d2 |
  r8 g g g g2 | r8 g g g g2 | r8 e e d d4 d | d d d2 |
  r8 e e e e2 | r8 e e e e2 | r8 c c b, d4 b, | b, b, d2 |
  r8 g g g g2~ | g8 g g g g2~ | g8 e e e c4 c | a, a, b,2~ |
  b,4 r e e |'''],
[lyr(RS, LS), lyr(RA, LS), lyr(RA, LS), lyr(RB, 'Il est')])

# ================================================================= L'éveil du Salut
EREF = 'Ber -- cé par la ten -- dres -- se de Ma -- rie, de Jo -- seph, l’en -- fant Jé -- sus s’en -- dort et le sa -- lut s’é -- veil -- le ! Glo -- ri -- a in ex -- cel -- sis De -- o ! '
A1 = 'Tou -- te peur, tout es -- poir de -- vant ta paix s’ef -- fa -- ce, plus de trouble en mon cœur: ta gran -- deur me dé -- pas -- se !'
A3 = 'Si pauvre par -- mi les pauvres, vê -- tu d’hu -- mi -- li -- té, __ _ tu men -- dies mon a -- mour Jé -- sus je veux t’ai -- mer ! __ _'
A5 = 'Sei -- gneur com -- ment te suivre ? si pe -- tit dé -- mu -- ni, __ _ seul ton re -- gard me sauve car il est in -- fi -- ni ! __ _'
L5 = 'Sei -- gneur com -- ment te suivre ? si pe -- tit dé -- mu -- ni, seul ton re -- gard __ _ me sauve car il est in -- fi -- ni ! __ _'
assert len({skips(x) for x in (A1, A3, A5, L5)}) == 1, [skips(x) for x in (A1, A3, A5, L5)]
B2 = 'N’aie crain -- te mon en -- fant, con -- tem -- ple le mys -- tè -- re d’un Dieu fait tout pe -- tit pour por -- ter ta mi -- sè -- re.'
B4 = 'Re -- gar -- de bien ma mère, é -- cou -- te son si -- len -- ce, tou -- te plei -- ne de grâce, vers Dieu son cœur s’é -- lan -- ce.'
CO = 'Con -- tre toute é -- vi -- dence, je suis ton es -- pé -- ran -- ce, l’É -- ter -- nel en si -- lence est en -- tré dans le temps !'


def ev(a5):
    n = skips(EREF)
    return [[(None, EREF), ('1', A1), ('2', B2), (None, CO)], [(None, n), ('3', A3), ('4', B4)], [(None, n), ('5', a5)]]


make('eveil.ly', dict(title='L’éveil du Salut', poet='Texte : Baudouin Tertrais', composer='Musique : Jean de la Charie', copyright='Édition ParFreeTion — ' + TDR),
r'''  \key a \minor
  \time 4/4
  \tempo 4 = 85
  \sectionLabel "REFRAIN"
  \partial 4 s4 | s1*6 \break s1*5 s2. \bar "||" \break
  \sectionLabel "L’étonnement des Hommes (couplets 1, 3, 5)" s4 | s1*4 \break s1*3 s2. \bar "||" \break
  \sectionLabel "La réponse de l’enfant Jésus (couplets 2, 4)" s4 | s1*4 \break s1*4 s4 \bar "||" \break
  \sectionLabel "CODA (après le dernier refrain)" \partial 4 s4 | s1*4 \break s1*4 \bar "|."''',
[r'''  a'4\p | e'' c'' b' c'' | b'2 b'4 a'8 g' | a'2 a'4 b' | c''2. a'4 | bes' bes' c'' d'' | c''2~ c''8 c''\< c'' c'' |
  b'4 b' a'2\! | a'1\mf | c''4.\f c''8 c''4 c''8 c'' | b'2 b' | c''1\ff | c''2.
  c''4\mp | a'4. a'8 b'4 c'' | b'2 b'4 c''8 d'' | c''2 g' | a' a' |
  f'4. f'8 f'4 g'8 a' | b'2 b'4 b'8 b' | b'4 b' b'2 | a'2.
  c''4\p | b' b' c'' d'' | c''2. c''4 | f' g' a' g' | g'2 g'4 g'8 g' |
  d''2 c''4 b' | c''2. c''4 | f' a' b' c'' | d''2 d''~ | d''4
  c''\mp | b' b' c'' d'' | c''2. c''4 | f' g' a' g' | g'2 g'4 g'8 g' |
  d''2 c''4\> b' | c''2.\p c''4\< | a' a' a' b' | c''1\mp |''',
 r'''  a'4 | a' a' g' g' | g'2 g'4 e'8 e' | fis'2 fis'4 gis' | a'2. e'4 | d' d' d' d' | f'2~ f'8 f' f' a' |
  a'4 g' e'2 | e' e'8( a' b') a' | a'2. a'8 a' | a'2 g' | g'1 | g'2.
  g'4 | f'4. f'8 g'4 a' | g'2 g'4 g'8 g' | g'2 g' | g'4. g'8 f'4 a' |
  d'2 d'4 d' | d'2 d'4 d'8 d' | e'4 e' e'2 | e'2.
  g'4 | g' g' a' b' | g'2. g'4 | f' f' f' f' | f'2 e'4 e'8 e' |
  g'2 g'4 g' | g'2. g'4 | f' f' f' f' | f'2 g'~ | g'4
  g' | g' g' a' b' | g'2. g'4 | f' f' f' f' | f'2 e'4 e'8 e' |
  g'2 g'4 g' | g'2. g'4 | f' f' f' f' | g'1 |''',
 r'''  a4 | c' e' e' e' | d'2 d'4 d'8 d' | d'2 d'4 d' | e'2. c'4 | bes bes bes bes | a2~ a8 a a a |
  b4 d' d'2 | cis' e8( a b) e' | f'2. c'8 d' | d'2 d'4( e'8 f') | f'1 | e'2.
  e'4 | c'4. c'8 c'4 f' | d'2 d'4 d'8 d' | e'2 e' | c' c' |
  a4. a8 a4 b8 c' | b2 d'4 d'8 d' | b4 b d'2 | c'2.
  e'4 | d' d' d' d' | e'2. e'4 | c' c' c' c' | c'2 c'4 c'8 c' |
  b2 d'4 d' | c'2. c'4 | c' c' d' e'8( d') | c'2 b~ | b4
  e' | d' d' d' d' | e'2. e'4 | c' c' c' c' | c'2 c'4 c'8 c' |
  b2 d'4 d' | c'2. c'4 | c'2 b4( d') | f' d' e'2 |''',
 r'''  a4 | a a e c | g2 g4 g8 g | d2 c4 b, | a,2. a4 | f f f f | f2~ f8 f f f |
  g4 e a2 | a1 | r4 f8 f f4 d8 d | g2 g | c1 | c2.
  c4 | f4. f8 f4 d | g2 g4 g8 g | c2 c | f4. f8 f4 e |
  d2 d4 d | g2 g4 g8 g | gis4 gis a2 | a2.
  c4 | g g g g | c2. c4 | f f f f | c2 c4 c8 c |
  g2 g4 g8( f) | e2. e4 | f f d d | g2 g~ | g4
  c | g g g g | c2. c4 | f f f f | c2 c4 c8 c |
  g2 g4 g8( f) | e2. e4 | f f g g | c1 |'''],
[ev(A5), ev(L5), ev(A5), ev(L5)], size=16)
