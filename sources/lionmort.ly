\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

% Transcrit d'après « Le lion est mort.pdf » (manuscrit, transcription et arrangement : Alain Camps).
% Plan du manuscrit : m. 1-36 (refrain m. 33-36 bissé), m. 41-48, puis 2 fois le refrain
% des m. 33-36 (repère A), m. 57-60 bissées (Ah na na na), m. 65-76.
% Les m. 2-3 reprennent le rythme, plus lisible, des m. 7-8 (même formule « Ô wim-a-way »).

\header {
  title = "Le lion est mort"
  subtitle = "(Pow-Wow)"
  poet = "D'après « Mbube » (Solomon Linda) · Paroles françaises : Henri Salvador"
  arranger = "Transcription et arrangement : Alain Camps"
  copyright = "Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key g \major
  \time 4/4
  \tempo 4 = 120
  s1*8 \break
  \sectionLabel "Couplet 1" s1*8 \break
  \sectionLabel "Refrain" s1*8 \break
  \sectionLabel "Couplet 2" s1*8 \break
  \mark \markup \box "A" \sectionLabel "Refrain" \repeat volta 2 { s1*4 } \break
  \sectionLabel "Couplet 3" s1*4 s1*3
  s1 \mark \markup \small \italic "puis 2 fois le refrain A (m. 33)" \break
  \repeat volta 2 { s1*4 } \break
  \sectionLabel "Couplet 4" s1*4 \break
  \sectionLabel "Refrain" s1*4 \break
  s1*4 \bar "|."
}

% ---------------------------------------------------------------- motifs
weS = { d''4 d''8 r r2 }
weA = { g'4 g'8 r r2 | e'4 e'8 r r2 | g'4 g'8 r r2 | fis'4 fis'8 r r2 | }
weB = { g,4 g,8 r r2 | c4 c8 r r2 | g,4 g,8 r r2 | d4 d8 r r2 | }
pair = #(define-music-function (p) (ly:pitch?) #{ \repeat unfold 4 { $p 8. $p 16 } #})

refS = { \pair g'' | \pair e'' | \pair g'' | fis''8. fis''16 fis''2 d'4 | }
hiS = { d''1~ | d''8 d''4 e'' d'' c''8~ | c''8 d'4 d' d'8 d'4~ | }
refT = { \pair b | \pair g | \pair b | }
refA = { \pair g' | \pair e' | \pair g' | }
refB = { \pair g, | \pair c | \pair g, | }
finT = { c'8. c'16 c'2 a4 | }
finA = { fis'8. fis'16 fis'2 fis'4 | }
finB = { d8. d16 d2 d4 | }

% ---------------------------------------------------------------- Soprano
sop = {
  R1 | r2 r4 r8 c''8 | d''8 d'' d''2 r4 | R1 |
  d''1\< | R1\! | r2 r4 r8 c''8 | d''8 d'' d''2 r4 |
  \repeat unfold 7 \weS | d''2. d''8 d'' |
  \refS
  \hiS d'2 r2 |
  \repeat unfold 7 \weS | d''2.~ d''8 d'8 |
  \repeat volta 2 { \hiS d'2 r4 d'4 | }
  R1 | r2 r4 r8 g''8 | g''4 g''8 g''4. g''8 fis''8~ | fis''1 |
  g''4 g''8 g''4 g'' g''8 | g''4 g''8 g''4 g'' g''8 | g''4 g''8 g''4. g''8 fis''8~ | fis''1 |
  \repeat volta 2 { b'8 b'4 b' b' r8 | b'8 b'4 b' b' r8 | b'8 b'4 b' b' r8 | c''8 c''4 c'' c'' r8 | }
  b'8 b'4 b' b' b'8 | c''8 c''4 c'' c'' c''8 | b'8 b'4 b'~ b'8 b' a'~ | a'2. d''4 |
  \refS
  \hiS d'2 r4 d'4\fermata |
}

% ---------------------------------------------------------------- Ténor
tenor = {
  R1*8
  g4 a8 b4 a b8 | c'4 b8 a4 g a8 | b4 a8 g4. b8 a~ | a2. r4 |
  d'4 b8 a4 b d'8 | c'4 b8 a4 g a8 | b4 a8 g4. b8 a~ | a2.~ a8 a |
  \refT \finT
  \refT a8. a16 a2 r4 |
  g4 a8 b4 a b8 | c'4 b8 a4 g a8 | b4 a8 g4. b8 a~ | a2. r4 |
  d'4 b8 a4 b d'8 | c'4 b8 a4 g a8 | b4 a8 g4. b8 a~ | a2.~ a8 a |
  \repeat volta 2 { \refT \finT }
  r2 r4 r8 d'8 | e'4 d'8 c'4 b a8 | b4 a8 g4. b8 a~ | a1 |
  d'4 b8 a4 b d'8 | c'4 b8 a4 g a8 | b4 a8 g4. b8 a~ | a1 |
  \repeat volta 2 { d'8 d'4 d' d' r8 | d'8 d'4 d' d' r8 | d'8 d'4 d' d' r8 | c'8 c'4 c' c' r8 | }
  d'8 d'4 d' d' d'8 | d'8 d'4 d' d' d'8 | d'8 d'4 d'~ d'8 d' d'~ | d'2. c'4 |
  \refT \finT
  \refT c'8. c'16 c'2 a4\fermata |
}

% ---------------------------------------------------------------- Alto
alto = {
  \weA \weA \weA
  g'4 g'8 r r2 | e'4 e'8 r r2 | g'4 g'8 r r2 | fis'2. fis'8 fis' |
  \refA \finA
  \refA fis'8. fis'16 fis'2 r4 |
  \repeat unfold 7 { \xNote { g'4 } r4 \xNote { g'2 } | } r2 r4 r8 fis'8 |
  \repeat volta 2 { \refA \finA }
  R1 | r2 r4 r8 b'8 | b'4 b'8 b'4. b'8 c''~ | c''1 |
  b'4 b'8 b'4 b' b'8 | g'4 g'8 g'4 g' g'8 | b'4 b'8 b'4. b'8 a'~ | a'1 |
  \repeat volta 2 { g'8 g'4 g' g' r8 | g'8 g'4 g' g' r8 | g'8 g'4 g' g' r8 | fis'8 fis'4 fis' fis' r8 | }
  g'8 g'4 g' g' g'8 | g'8 g'4 g' g' g'8 | g'8 g'4 g'~ g'8 g' fis'~ | fis'2. fis'4 |
  \refA \finA
  \refA fis'8. fis'16 fis'2 fis'4\fermata |
}

% ---------------------------------------------------------------- Basse
basse = {
  \weB \weB \weB
  g,4 g,8 r r2 | c4 c8 r r2 | g,4 g,8 r r2 | fis2. fis8 fis |
  \refB \finB
  \refB d8. d16 d2 r4 |
  \weB g,4 g,8 r r2 | c4 c8 r r2 | g,4 g,8 r r2 | d2. d8 d |
  \repeat volta 2 { \refB \finB }
  g,4 a,8 b,4 a, b,8 | c4 b,8 a,4 g, b,8 | d4 c8 b,4. d8 c~ | c1 |
  d4 b,8 a,4 b, d8 | c4 b,8 a,4 g, b,8 | d4 c8 b,4. d8 c~ | c1 |
  \repeat volta 2 { g,4^\markup \italic "2e fois" g,8 r r2 | c4 c8 r r2 | g,4 g,8 r r2 | d4 d8 r r2 | }
  g,4 g,8 r r2 | c4 c8 r r2 | g,4 g,8 r r2 | d4 d8 r r4 d4 |
  \refB \finB
  \refB d8. d16 d2 d4\fermata |
}

% ---------------------------------------------------------------- Paroles
weap = \lyricmode { Wé ap! }
wimR = \lyricmode { \repeat unfold 6 { wim -- a -- way ô } wim -- a -- way Ô }
wimH = \lyricmode { \repeat unfold 6 { ô wim -- a -- way } wim -- a -- way }
hiR = \lyricmode { Hi __ i i i i Ô wim -- a -- way }
coupletA = \lyricmode {
  Dans la jun -- gle ter -- ri -- ble jun -- gle le lion est mort ce soir __
  Et les hom -- mes tran -- quil’ s’en -- dor -- ment le lion est mort ce soir __ Ô
}
coupletB = \lyricmode {
  Tout est sa -- ge dans le vil -- la -- ge le lion est mort ce soir __
  Plus de ra -- ge plus de car -- na -- ge le lion est mort ce soir __ Ô
}
viens = \lyricmode { Viens ma bel -- le viens ma ga -- zel -- le le lion est mort ce soir }
dernier = \lyricmode { Dans la jun -- gle ter -- ri -- ble jun -- gle le lion est mort ce soir Ô }
ahna = \lyricmode { \repeat unfold 4 { Ah na na na } }

sopLyr = \lyricmode {
  Ô wim -- a -- way Hi Ô wim -- a -- way
  \repeat unfold 7 \weap Wé é Ô
  \wimR \hiR
  \repeat unfold 7 \weap Wé Ô
  \hiR Ô
  Le lion est mort ce soir \viens
  \ahna \dernier \wimR \hiR Ô
}
tenorLyr = \lyricmode {
  \coupletA \wimR \wimH \coupletB
  \wimH Ô
  Le re -- dou -- ta -- ble le lion est mort ce soir \viens
  \ahna \dernier \wimR \wimH Ô
}
altoLyr = \lyricmode {
  \repeat unfold 15 \weap Wé é Ô
  \wimR \wimH
  \repeat unfold 7 { Poum Ah } Ô
  \wimH Ô
  Le lion est mort ce soir \viens
  \ahna \dernier \wimR \wimH Ô
}
basseLyr = \lyricmode {
  \repeat unfold 15 \weap Wé é Ô
  \wimR \wimH
  \repeat unfold 7 \weap Wé ap! Ô
  \wimH Ô
  L’in -- domp -- ta -- ble, le re -- dou -- ta -- ble le lion est mort ce soir \viens
  \repeat unfold 7 \weap Wé ap! Ô
  \wimR \wimH Ô
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
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global
        \new Voice = "alto" \with \voiceAttrs "A" { \alto }
      >>
      \new Lyrics \lyricsto "alto" \altoLyr
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenor }
      >>
      \new Lyrics \lyricsto "ten" \tenorLyr
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basse }
      >>
      \new Lyrics \lyricsto "bas" \basseLyr
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
