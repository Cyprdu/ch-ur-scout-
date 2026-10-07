\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

% Transcrit d'après New/Glorificamus te.pdf (harmonisation des couplets,
% refrain, doxologie) et la feuille « Veillée de prière des jeunes »
% (mélodie, paroles, répartition S1 / S2-A / T / B du refrain).

\header {
  title = "Glorificamus te"
  category = "ESPRIT SAINT"
  number = "EDIT 18-33"
  poet = "Paroles et musique : Benjamin Pavageau"
  copyright = "© 2010, Éditions de l'Emmanuel — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key a \major
  \time 4/4
  \tempo 4 = 108
  \sectionLabel "COUPLETS"
  s1*4 \break s1*4 \break s1*4 \break s1*4 \bar "||" \break
  \sectionLabel "REFRAIN"
  s1*4 \break s1*4 \bar "||" \break
  \sectionLabel "DOXOLOGIE"
  s1*8 \break s1*9 \bar "||" \break
  \sectionLabel "AMEN"
  s1*8 \bar "|."
}

bf = \markup \small \italic "bouche fermée"

% ---------------------------------------------------------------- Soprano (S1 au refrain)
sop = \relative c' {
  % couplets
  e2 cis8. e8. a8 | gis2 r8 gis fis e | fis2 \tuplet 3/2 { fis4 e d } | e2 e |
  d2 d8. e8. d8 | cis2 r8 cis d e | d2 \tuplet 3/2 { cis4 d e } | e2 e |
  a2 a8. b8. a8 | gis2 r8 gis fis gis | gis2 \tuplet 3/2 { eis4 fis gis } | a2 gis |
  fis2 fis8. gis8. a8 | gis2 \tuplet 3/2 { gis4 a b } | a2.( gis4) | a1 |
  % refrain
  fis4 e fis gis | a gis8 a~ a2 | a4 gis a b | cis b8 cis~ cis2 |
  a4 b d cis | b a8 a~ a2 | fis2 gis4 a | a4. gis8 gis2 |
  % doxologie
  d'2 d4 d | cis2 a | fis2. fis4 | fis1 |
  b2 b4 b | a2 fis | a2. b4 | b1 |
  d2 d4 d | a2 a | fis2. fis4 | fis1 |
  b2 b4 b | a2 fis | a1 | gis2.( a4) | a1 |
  % amen
  r2 b4( a) | a1 | r2 b4( a) | a1 | r2 b4( a) | a1 | r2 b4( a) | a1 |
}

% ---------------------------------------------------------------- Soprano 2 (refrain seul)
sopII = \relative c' {
  s1*16
  fis1~^\bf | fis2. gis4 | a1~ | a2 gis4 e |
  fis1~ | fis2. e4 | fis2 gis4 a | a4. gis8 gis2 |
  s1*25
}

% ---------------------------------------------------------------- Alto
alto = \relative c' {
  cis2 a8. cis8. e8 | e2 r8 e d cis | d2 \tuplet 3/2 { d4 cis d } | b2 b |
  d2 a8. b8. a8 | cis2 r8 a b cis | b2 \tuplet 3/2 { b4 b b } | b2 b |
  a2 e'8. e8. e8 | e2 r8 e e e | eis2 \tuplet 3/2 { cis4 dis eis } | fis2 gis |
  d2 d8. e8. fis8 | e2 \tuplet 3/2 { e4 fis gis } | fis1 | e1 |
  % refrain (bouche fermée, puis « Gloria »)
  a,1~^\bf | a2. b4 | cis1~ | cis1 |
  d1~ | d2. e4 | fis2 fis4 fis | fis4. e8 e2 |
  % doxologie
  fis2 fis4 gis | a( e) e2 | d2. d4 | d1 |
  fis2 fis4 fis | fis2 cis | fis2. gis4 | gis1 |
  fis2 fis4 gis | a( e) e2 | d2. d4 | d1 |
  fis2 fis4 fis | fis2 cis | fis1 | e1 | e1 |
  % amen
  R1 | r2 e2 | e1~ | e2 e | e1~ | e2 e | e1~ | e1 |
}

% ---------------------------------------------------------------- Ténor
tenor = \relative c {
  a'2 a8. b8. cis8 | cis2 r8 cis cis cis | a2 \tuplet 3/2 { a4 a b } | a2 gis |
  fis2 fis8. fis8. fis8 | e2 r8 e e e | g2 \tuplet 3/2 { g4 g b } | a2 gis |
  cis2 cis8. d8. cis8 | cis2 r8 cis cis cis | cis2 \tuplet 3/2 { cis4 fis eis } | cis2 e |
  a,2 d8. d8. cis8 | b2 \tuplet 3/2 { b4 b b } | d1 | cis1 |
  % refrain
  R1 | d,4 e fis gis8 a~ | a1 | e4 fis gis a8 a~ |
  a1 | a4 b d cis8 d~ | d1 | b4. b8 b2 |
  % doxologie
  b2 b4 b | a2 a | a2. a4 | a1 |
  d2 d4 d | cis( b) a2 | d2. e4 | e1 |
  b2 b4 b | a2 a | a2. a4 | a1 |
  d2 d4 d | cis( b) a2 | d1 | b2.( d4) | d( cis2.) |
  % amen
  r2 d4(-^ cis) | cis1 | r2 d4( cis) | cis1 | r2 d4( cis) | cis1 | r2 d4(-^ cis) | cis1 |
}

% ---------------------------------------------------------------- Basse
basse = \relative c {
  a2 a8. a8. a8 | cis2 r8 cis cis cis | d2 \tuplet 3/2 { d4 d d } | e2 e |
  d2 d8. d8. d8 | a2 r8 a a a | g2 \tuplet 3/2 { g4 g g } | e'2 e |
  a,2 a8. a8. a8 | cis2 r8 cis cis cis | cis2 \tuplet 3/2 { cis4 cis cis } | fis2 e |
  d2 d8. d8. d8 | e2 \tuplet 3/2 { e4 e e } | d1 | a1 |
  % refrain
  d2. d4 | d d2. | a2. a4 | a a2. |
  d2. d4 | d d2. | b2 b4 b | e4. e8 e2 |
  % doxologie
  b2 b4 b | cis2 cis | d2. d4 | d1 |
  b2 b4 b | fis'2 fis | e2. e4 | e1 |
  b2 b4 b | cis2 cis | d2. d4 | d1 |
  b2 b4 b | fis'2 fis | d1 | e1 | a,1 |
  % amen
  r2 e'2 | a,1 | r2 e'2 | a,1 | r2 e'2 | a,1 | r2 e'2 | a,1 |
}

% ---------------------------------------------------------------- Paroles
cplA = \lyricmode {
  \set stanza = "1."
  Viens, Es -- prit de Dieu, et nous se -- rons hum -- bles et pau -- vres.
  Viens nous ap -- prê -- ter à hé -- ri -- ter de ton Roy -- au -- me.
  Viens nous for -- ti -- fier dans la dou -- leur et dans l'é -- preu -- ve.
  Viens nous a -- breu -- ver de ton eau vi -- ve.
}
cplB = \lyricmode {
  \set stanza = "2."
  Viens, Es -- prit de Dieu, met -- tre ta paix dans la dis -- cor -- de.
  Viens, nous se -- rons doux, nous ob -- tien -- drons mi -- sé -- ri -- cor -- de.
  Viens et nous se -- rons des ar -- ti -- sans de paix sur ter -- re.
  Viens don -- ner la joie qui vient du Pè -- re.
}
cplC = \lyricmode {
  \set stanza = "3."
  Viens, Es -- prit de Dieu, et sanc -- ti -- fie nos sa -- cri -- fi -- ces.
  Viens nous sou -- te -- nir dans nos com -- bats pour la jus -- ti -- ce.
  Viens, rends nos cœurs purs et nous ver -- rons l'é -- clat du Pè -- re.
  Viens, é -- clai -- re -- nous de sa lu -- miè -- re.
}
doxo = \lyricmode {
  De -- o Pa -- tri sit glo -- ri -- a,
  et Fi -- lio, qui a mor -- tu -- is
  sur -- re -- xit, ac Pa -- ra -- cli -- to
  in sæ -- cu -- lo -- rum sæ -- cu -- la.
}
amenIV = \lyricmode { A -- men. A -- men. A -- men. A -- men. }
amenIII = \lyricmode { A -- men. A -- men. A -- men. }
gloria = \lyricmode { Glo -- ri -- "a !" }

sopLyr = \lyricmode {
  \cplA
  Ve -- ni Sanc -- te Spi -- ri -- tus, __
  Ve -- ni Sanc -- te Spi -- ri -- tus, __
  Ve -- ni Sanc -- te Spi -- ri -- tus, __
  Glo -- ri -- fi -- ca -- mus "te !"
  \doxo \amenIV
}
sopIILyr = \lyricmode { \repeat unfold 10 \skip 1 \gloria }
altoLyr = \lyricmode { \cplA \repeat unfold 8 \skip 1 \gloria \doxo \amenIII }
tenorLyr = \lyricmode {
  \cplA
  Sanc -- te Spi -- ri -- tus, __
  Sanc -- te Spi -- ri -- tus, __
  Sanc -- te Spi -- ri -- tus, __
  \gloria \doxo \amenIV
}
basseLyr = \lyricmode {
  \cplA
  Ve -- ni Sanc -- te, Ve -- ni Sanc -- te, Ve -- ni Sanc -- te,
  Glo -- ri -- fi -- ca -- mus "te !"
  \doxo \amenIV
}

% ---------------------------------------------------------------- Partition
\score {
  <<
    \new ChoirStaff <<
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \sop }
      >>
      \new Lyrics \lyricsto "sop" \sopLyr
      \new Lyrics \with \italicVerse \lyricsto "sop" \cplB
      \new Lyrics \lyricsto "sop" \cplC
      \new Staff \with {
        instrumentName = "Soprano 2" shortInstrumentName = "S2"
        \RemoveAllEmptyStaves
      } <<
        \global
        \new Voice = "sopII" \with \voiceAttrs "S2" { \sopII }
      >>
      \new Lyrics \lyricsto "sopII" \sopIILyr
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global
        \new Voice = "alto" \with \voiceAttrs "A" { \alto }
      >>
      \new Lyrics \lyricsto "alto" \altoLyr
      \new Lyrics \with \italicVerse \lyricsto "alto" \cplB
      \new Lyrics \lyricsto "alto" \cplC
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenor }
      >>
      \new Lyrics \lyricsto "ten" \tenorLyr
      \new Lyrics \with \italicVerse \lyricsto "ten" \cplB
      \new Lyrics \lyricsto "ten" \cplC
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basse }
      >>
      \new Lyrics \lyricsto "bas" \basseLyr
      \new Lyrics \with \italicVerse \lyricsto "bas" \cplB
      \new Lyrics \lyricsto "bas" \cplC
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
