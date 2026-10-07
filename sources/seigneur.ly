\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

% Transcrit d'après les photos New/WhatsApp Image 2026-10-07 at 15.51.46.jpeg (refrain)
% et New/2.jpeg (couplets).
% Refrain : S et A à l'unisson, T et B à l'unisson en canon une mesure plus tard,
% puis les quatre voix se séparent. Basse des couplets, m. 4 : la ronde de l'original
% est notée en deux blanches pour porter « ro-le » / « peu-ple ».

\header {
  title = "Seigneur, ô Maître souverain"
  subtitle = "Titre original : Sei unser Heil (Nunc Dimittis)"
  category = "HYMNES ET CANTIQUES"
  number = "N° 14-44 · EDIT 15-68"
  poet = "Paroles d'après Lc 2, 29-32 et musique : Communauté de l'Emmanuel (M. Wittal)"
  copyright = "© 1991, Gemeinschaft Emmanuel · Traduction © 2012, Éditions de l'Emmanuel — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key a \minor
  \time 4/4
  \tempo 4 = 72
  \sectionLabel "REFRAIN"
  s1*5 \break s1*4 \bar "||" \break
  \sectionLabel "COUPLETS"
  s1*4 \break s1*4 \bar "|."
}

accords = {
  % refrain
  \ch "Lam" 2. \ch "Mi" 4 | \ch "Lam" 2. \ch "Mi" 4 | \ch "Lam" 2 \ch "Fa" 2 |
  \ch "Sol4" 4 \ch "3" 4 \ch "Do" 2 | \ch "Lam" 2. \ch "Mi" 4 | \ch "Lam" 2. \ch "Mi" 4 |
  \ch "Lam" 2 \ch "Rém6" 2 | \ch "Mi4" 4 \ch "3" 4 \ch "La" 2 | \ch "Ré/La" 2 \ch "La" 2 |
  % couplets
  \ch "Lam" 2 \ch "Fa" 2 | \ch "Sol" 2 \ch "Do4" 4 \ch "3" 4 | \ch "Rém" 1 | \ch "Mi" 1 |
  \ch "Lam" 2 \ch "Fa" 2 | \ch "Sol" 2 \ch "Do4" 4 \ch "3" 4 | \ch "Rém" 1 | \ch "Mi" 1 |
}

% ---------------------------------------------------------------- Soprano
sop = {
  % refrain
  e'4 a'8 b' c'' d'' b' b' | c''4 a'8 a' a' b' gis' gis' |
  a'8 e' e' e' a'4. a'8 | g'4 g' e'2 |
  e'4 a'8 b' c'' d'' b' b' | c''4 a'8 a' a' b' gis' gis' |
  a'4 e'8 e' d'4 e'8 f' | e'1~ | e'1 |
  % couplets
  e'8 e' a' b' c'' c'' b' a' | g'8 g' g' f' f'4 e' |
  d'8 d' d' d' d' d' b d' | e'2 e' |
  e'4 a'8 b' c''4 b'8 a' | g'8 g' g' f' f'4 e'8 e' |
  d'8 d' d' d' d'4 b8 d' | e'2 e'4 r |
}

% ---------------------------------------------------------------- Alto
alto = {
  e'4 a'8 b' c'' d'' b' b' | c''4 a'8 a' a' b' gis' gis' |
  a'8 e' e' e' f'4. f'8 | d'4 d' c'2 |
  e'4 a'8 b' c'' d'' b' b' | c''4 a'8 a' a' b' gis' gis' |
  a'4 c'8 c' b4 b8 b | b2 cis'8 cis' cis'4 | d'4 b cis'2 |
  % couplets
  e'8 e' e' e' a' a' g' f' | d'8 d' d' d' d'4 c' |
  a8 a a a a a a a | b4( a) b2 |
  c'4 e'8 e' a'4 g'8 f' | d'8 d' d' d' d'4 c'8 c' |
  a8 a a a a4 a8 a | b4( a) b r |
}

% ---------------------------------------------------------------- Ténor
tenor = {
  R1 | e4 a8 b c' d' b b |
  c'4 c'8 c' c'4. c'8 | c'4 c'8( b) g2 |
  R1 | e4 a8 b c' d' b b |
  c'4 a8 a a4 a8 a | a4( gis) a8 e e4 | fis4 d e2 |
  % couplets
  c'8 c' c' c' c' c' c' c' | b8 b g g g4 g |
  f8 f f f f f f a | gis4( fis) gis2 |
  a4 c'8 c' c'4 c'8 c' | b8 b g g g4 g8 g |
  f8 f f f f4 f8 a | gis4( fis) gis r |
}

% ---------------------------------------------------------------- Basse
basse = {
  R1 | e4 a8 b c' d' b b |
  a4 a8 a f4. f8 | g4 g c2 |
  R1 | e4 a8 b c' d' b b |
  c'4 a8 a f4 e8 d | e2( a,2)~ | a,1 |
  % couplets
  a8 a a g f f f f | g8 g b, b, c4 c |
  d8 d c c b, b, d f | e2 e |
  a4 a8 g f4 f8 f | g8 g b, b, c4 c8 c |
  d8 d c c b,4 d8 f | e2 e4 r |
}

% ---------------------------------------------------------------- Paroles
refHaut = \lyricmode {
  Sei -- gneur, ô Maî -- tre sou -- ve -- rain,
  sau -- ve -- nous quand nous veil -- lons
  et gar -- de -- nous quand nous dor -- mons_;
  nous veil -- le -- rons a -- vec le Christ
  et re -- po -- se -- rons en paix,
  gar -- de -- nous dans ta
}
refBas = \lyricmode {
  Sei -- gneur, ô Maî -- tre sou -- ve -- rain,
  gar -- de -- nous quand nous dor -- mons_;
  nous veil -- le -- rons a -- vec le Christ,
  gar -- de -- nous dans ta
}
cplA = \lyricmode {
  \set stanza = "1."
  Main -- te -- nant, Sei -- gneur, tu peux lais -- ser ton ser -- vi -- teur, __ _
  al -- ler en paix se -- lon ta pa -- ro -- le.
  Mes yeux ont vu le sa -- lut que tu pré -- pares à la
  fa -- ce d'Is -- ra -- ël, ton __ _ peu -- ple.
}
cplB = \lyricmode {
  \set stanza = "2."
  Lu __ _ miè -- re pour __ _ é -- clai -- rer __ _ les na -- tions, et
  gloi -- re d'Is -- ra -- ël, __ _ ton __ _ peu -- ple.
  Gloire au Pè -- re, gloire au Fils, au Saint Es -- prit, main -- te --
  nant et dans les siè -- cles des siè -- cles.
}

sopLyr = \lyricmode { \refHaut paix. \cplA }
altoLyr = \lyricmode { \refHaut paix. gar -- de -- nous dans ta paix. \cplA }
tenorLyr = \lyricmode { \refBas paix. gar -- de -- nous dans ta paix. \cplA }
basseLyr = \lyricmode { \refBas paix. \cplA }

% les 2es couplets démarrent après le refrain : on saute ses notes
skipS = \repeat unfold 44 \skip 1
skipA = \repeat unfold 50 \skip 1
skipT = \repeat unfold 35 \skip 1
skipB = \repeat unfold 29 \skip 1

% ---------------------------------------------------------------- Partition
\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \sop }
      >>
      \new Lyrics \lyricsto "sop" \sopLyr
      \new Lyrics \with \italicVerse \lyricsto "sop" { \skipS \cplB }
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global
        \new Voice = "alto" \with \voiceAttrs "A" { \alto }
      >>
      \new Lyrics \lyricsto "alto" \altoLyr
      \new Lyrics \with \italicVerse \lyricsto "alto" { \skipA \cplB }
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenor }
      >>
      \new Lyrics \lyricsto "ten" \tenorLyr
      \new Lyrics \with \italicVerse \lyricsto "ten" { \skipT \cplB }
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basse }
      >>
      \new Lyrics \lyricsto "bas" \basseLyr
      \new Lyrics \with \italicVerse \lyricsto "bas" { \skipB \cplB }
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
