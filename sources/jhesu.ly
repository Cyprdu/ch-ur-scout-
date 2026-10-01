\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "Jhesu Maria*"
  poet = "Paroles : fr. David Perrin, op"
  composer = "Musique : fr. Clément Binachon, op"
  copyright = \markup \center-column {
    \line { "* Au cours de son procès, Jeanne d'Arc raconte qu'elle fit écrire les noms" \italic "Jhesus-Maria" "sur son étendard (cf. Procès d'office," }
    \line { "quatrième audience publique, mardi 27 février 1431). Nous avons voulu que ces noms résonnent comme la prière de Jeanne d'Arc" }
    \line { "à son Seigneur et à sa mère, ce qui explique le vocatif :" \italic "Jhesu, Maria." }
  }
}

global = {
  \key c \major
  \time 6/8
  \tempo "Résolu mais avec douceur" 4. = 80
  \sectionLabel "REFRAIN"
  s2.*8 \bar "||" \break
  \sectionLabel "COUPLETS"
  s2.*15 s2. \bar "||"
  s2.*15 s2. \bar "|."
}

% ---------- Soprano ----------
sopRefrain = \fixed c' {
  e4( f8) g4. | d4 c8 d4. | f4( g8) a4. | c'4 b8 a4. |
  c'4( b8) a4. | f4. g4. | g2.~ | g2. |
}
sopCouplet = \fixed c' {
  e4 f8 g[ d' c'] | g2. | a4 e8 e[ c' b] | a4. a4. |
  f4 g8 a[ g f] | e4. g4. | e4 c8 g4 e8 | d4. d4. |
  f4 e8 d[ f a] | a4. a4. | c'4 g8 g4 c'8 | d'4. d'4. |
  d'4 a8 a[ a b] | c'4. c'4. | a4 a8 g[ c' b] | c'2.\fermata |
}
sop = { \sopRefrain \sopCouplet \sopCouplet }

% ---------- Alto ----------
altoRefrain = \fixed c' {
  c4( d8) e4. | c4 c8 b,4. | d4. d4. | e8( d) e e4. |
  f4. f4. | c4( b,8) a,4( d8) | d2.~ | d2. |
}
altoCouplet = \fixed c' {
  c4 d8 e[ g e] | g2. | e4 c8 e[ g g] | f4. f4. |
  c4 c8 f[ e d] | c4. c4. | c4 c8 c4 c8 | c4. b,4. |
  d4 d8 d[ d d] | e4. c4. | e4 e8 e4 g8 | g4. g4. |
  f8[( e d]) d[ e f] | e4. e4. | f4 c8 d[ d d] | e2.\fermata |
}
alto = { \altoRefrain \altoCouplet \altoCouplet }

% ---------- Ténor ----------
tenorRefrain = \fixed c {
  g4. g4. | g8[ d'( c')] g4. | a4. f4. | a4 b8 c'4. |
  a4. c'4. | d'4. c'4. | c'2.( | b2.) |
}
tenorCouplet = \fixed c {
  g4 g8 c'[ g c'] | d'2. | c'4 a8 a[ e a] | c'4. c'4. |
  a4 a8 f[ g a] | g4. c'4. | c'4 g8 e4 g8 | g4. g4. |
  a4 g8 f[ a a] | c'4. a4. | g4 c'8 c'4 c'8 | c'4. b4. |
  a8[( g f]) f[ g a] | a4. a4. | c'4 a8 c'[ c' b] | g2.\fermata |
}
tenor = { \tenorRefrain \tenorCouplet \tenorCouplet }

% ---------- Basse ----------
basseRefrain = \fixed c {
  c4. c4. | g,8[( b, d]) g4. | f4 e8 d4. | a4 e8 a4. |
  f4 g8 f4 e8 | d4. f4. | g2.~ | g2. |
}
basseCouplet = \fixed c {
  c4 c8 c[ d c] | b,2. | a,4 a,8 a,[ c e] | f4. f4. |
  f4 f8 f[ c f] | c4. e4. | g4 e8 c4 c8 | g,4. g,4. |
  d4 d8 d[ d f] | a4. e4. | c4 c8 c4 c8 | g4. g4. |
  d4 d8 d[ d d] | a,4. a,4. | f4 f8 g[ g g] | c2.\fermata |
}
basse = { \basseRefrain \basseCouplet \basseCouplet }

% ---------- Nuances ----------
dynRefrain = { s4.\mf s4. | s2. | s4.\f s4. | s2. | s4.\ff\< s4. | s2. | s2.\! | s2.\> | }
dynCouplet = { s4.\mf s4. | s2.*7 | s4.\f s4. | s2. | s4.\ff\< s4. | s2.\! | s2. | s2. | s4.\f s4. | s2. | }
dyn = { \dynRefrain \dynCouplet \dynCouplet }

% ---------- Accords ----------
accordsCouplet = {
  \ch "Do" 2. | \ch "Sol/Si" 2. | \ch "Lam" 2. | \ch "Fa" 2. | s2. | \ch "Do" 2. | s2. | \ch "Sol4–3" 2. |
  \ch "Rém" 2. | \ch "Lam" 2. | \ch "Do" 2. | \ch "Sol4–3" 2. | \ch "Rém" 2. | \ch "Lam" 2. |
  \ch "Fa" 4. \ch "Sol4–3" 4. | \ch "Do" 2. |
}
accords = {
  \ch "Do" 2. | \ch "Sol4–3" 2. | \ch "Rém" 2. | \ch "Lam" 2. | \ch "Fa" 2. |
  \ch "Rém7" 4. \ch "Fa2" 4. | \ch "Sol4–3" 2. | s2. |
  \accordsCouplet \accordsCouplet
}

% ---------- Paroles ----------
refrainText = \lyricmode {
  Jhe -- su, Ma -- ri -- "a !" Jhe -- su, Ma -- ri -- "a !" Jhe -- su, Ma -- ri -- "a !"
}
refrainSkip = \repeat unfold 15 \skip 1

ligneA = \lyricmode {
  \refrainText
  \set stanza = "1."
  C'est pour vous, doux Sei -- gneur, que je vins de Lor -- rai -- ne
  au roy -- au -- me de Fran -- ce sa -- crer le Dau -- phin. _
  C'est pour vous, sain -- te Vier -- ge, qui ê -- tes ma rei -- ne,
  que je fis ces ex -- ploits _ qui si -- gnè -- rent ma fin.
  \set stanza = "5."
  Le Sei -- gneur a vou -- lu dans sa gran -- de clé -- men -- ce
  que prit fin, par le bras d'u -- ne fem -- me pu -- cel -- le,
  la pi -- tié qui se trouve au roy -- au -- me de Fran -- ce,
  comme il fit en son temps _ pour son peuple Is -- ra -- ël.
}
ligneB = \lyricmode {
  \refrainSkip
  \set stanza = "2."
  Je vou -- lais vous ser -- vir dès le jour où je vis _
  au jar -- din la clar -- té et que j'ouïs cet -- te voix. _
  A la vue de l'arch -- an -- ge mon coeur dé -- fail -- lit _
  mais j'of -- fris ma per -- son -- ne âme et corps à mon Roi.
  \set stanza = "6."
  À pré -- sent dans les fers, mal -- me -- née par ces hom -- mes
  qui pré -- ten -- dent par -- ler de par Dieu et l'É -- gli -- se
  har -- di -- ment, je ré -- ponds, et sans crain -- te je som -- me
  ces faux ju -- ges d'en -- ten -- dre ce que mes voix me disent.
}
ligneC = \lyricmode {
  \refrainSkip
  \set stanza = "3."
  Al -- ler à Vau -- cou -- leurs et le -- ver des ar -- mées, _
  li -- bé -- rer Or -- lé -- ans puis re -- pren -- dre la Loi -- re,
  cou -- ron -- ner le Dau -- phin, sur mes voix je pro -- mets, _
  tout ce -- la, je l'ai fait _ de par Dieu, pour sa gloire.
  \set stanza = "7."
  Si je suis dans la "grâce ?" Mais com -- ment le sau -- rais -- "je ?"
  Si j'y suis, Dieu m'y tien -- ne, voi -- là ma pri -- è -- re.
  Mais si je n'y suis pas, qu'il m'y mette et al -- lè -- ge
  de ses fau -- tes ce coeur _ qui veut voir sa lu -- mière.
}
ligneD = \lyricmode {
  \refrainSkip
  \set stanza = "4."
  Je n'a -- vais nul -- le haine à l'é -- gard des an -- glais, _
  mon é -- pée au cô -- té, l'é -- ten -- dard à la main, _
  je cla -- mais à grands cris et par let -- tre la paix _
  a -- fin que nul ne tom -- be au pou -- voir du Ma -- lin.
  \set stanza = "8."
  Mon seul juge est mon Dieu. De mes faits, de mes di -- res,
  je m'en rap -- porte à lui. Me -- nez -- moi au bû -- "cher !" _
  Je suis prête à mou -- rir, à souf -- frir le mar -- ty -- re.
  Don -- nez -- moi, ô Jé -- sus, _ vo -- tre for -- ce ca -- "chée !"
}

\score {
  <<
    \new ChordNames \accords
    \new PianoStaff \with { \override StaffGrouper.staff-staff-spacing.padding = #2 } <<
      \new Staff <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \voiceOne \sop }
        \new Voice = "alto" \with \voiceAttrs "A" { \voiceTwo \alto }
      >>
      \new Dynamics \dyn
      \new Lyrics \lyricsto "sop" \ligneA
      \new Lyrics \lyricsto "sop" \ligneB
      \new Lyrics \lyricsto "sop" \ligneC
      \new Lyrics \lyricsto "sop" \ligneD
      \new Staff <<
        \global \clef bass
        \new Voice = "ten" \with \voiceAttrs "T" { \voiceOne \tenor }
        \new Voice = "bas" \with \voiceAttrs "B" { \voiceTwo \basse }
      >>
    >>
  >>
  \layout { \chorusLayout }
}

