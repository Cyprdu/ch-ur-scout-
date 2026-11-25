\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "Maintenant, Seigneur"
  poet = "Paroles : d’après Lc 2, 29-32"
  composer = "Musique : Sœur Luce Martens"
  copyright = "© Éditions de l’Emmanuel — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key a \minor
  \time 2/4
  \tempo 4 = 66
  \sectionLabel "REFRAIN"
  \partial 4 s4 | s2*5 \break s2*6 \bar "||" \break
  \sectionLabel "COUPLETS" s2*8 \break s2*8 s4 \bar "|."
}

sopMus = {
  e'8 e' | a'4. g'8 | e'4 e' | f' e'8 d' | c'4 a8 a | b4 d'8 c' |
  b4 e'8 e' | a'4. b'8 | c''4 c'' | b' c''8 a' | gis'4 fis'8 e' | a'2 |
  % couplets
  r4 e' | f' f' | f' e'8 d' | e' e' e' f' | e'4. c'8 | d'4 d'8 d' | d'4 c'8 d' | e'2 |
  e'4 c'8 c' | d'4 d'8 d' | d'4 c'8 b | e' e' e' f' | e'4 r | a' a' | c'' a'8 b' | gis'4( fis') | e' 
}

altoMus = {
  r4 | r a8 a | c' b c' c' | d'4 b8 b | a4 a8 a | d'4 d'8 e' |
  e'4 r | c'8 e' fis' gis' | a'4 e' | f' fis' | gis'8 e' d' e' | e'2 |
  R2*16 | r4
}

tenMus = {
  r4 | R2 | e8 e a4 | a8 b gis gis | a4 f8 f | f4 gis8 fis |
  gis4 r | c'8 c' d' d' | c'4 c' | d' a8 c' | b4 d'8 d' | c'2 |
  R2*16 | r4
}

basMus = {
  r4 | R2 | R2 | d8 d e4 | a,8 c d4 | d8 b, e e |
  e4 r | a8 a d e | a4 a | d dis8 dis | e4 e8 e | a,2 |
  R2*16 | r4
}

sopLyrA = \lyricmode {
  \unset stanza Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser m’en al -- ler dans la paix. Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser re -- po -- ser. 
  \set stanza = "1." Tu peux lais -- ser s’en al -- ler ton ser -- vi -- teur en paix __ _ se -- lon ta pa -- ro -- le, car mes yeux ont __ _ vu le sa -- lut que tu pré -- pares à la fa -- ce des peu -- ples.
}

sopLyrB = \lyricmode {
  \repeat unfold 29 \skip 1
  \set stanza = "2." Lu -- miè -- re pour é -- clai -- rer __ _ les na -- tions et gloire d’Is -- ra -- ël ton __ _ peu -- ple. Gloire au Père, et au Fils, et au Saint -- _ Es -- _ prit pour les siè -- cles des siè -- cles.
}

altoLyrA = \lyricmode {
  \unset stanza Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser m’en al -- ler dans la paix. Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser re -- po -- ser. 
}

tenLyrA = \lyricmode {
  \unset stanza Main -- te -- nant, tu peux me lais -- ser m’en al -- ler dans la paix. Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser re -- po -- ser. 
}

basLyrA = \lyricmode {
  \unset stanza Main -- te -- nant, tu peux me lais -- ser dans la paix. Main -- te -- nant, Sei -- gneur, tu peux me lais -- ser re -- po -- ser. 
}

accords = \chordmode {
  s4 | \ch "Lam" 2 s2 | \ch "Rém" 4 \ch "Mi" 4 | \ch "Lam" 4 \ch "Rém" 4 | \ch "Mi7" 2 |
  s2 | \ch "Lam" 4. \ch "Mi7" 8 | \ch "Lam" 2 | \ch "Rém6" 2 | \ch "Mi7" 2 | \ch "Lam" 2 |
  s2 | \ch "Rém" 2 s2 | \ch "Lam" 2 s2 | \ch "Mi7" 2 s2 | \ch "Lam" 2 |
  s2 | \ch "Rém" 2 s2 | \ch "Lam" 2 s2 | \ch "Fa" 2 s2 | \ch "Mi7" 2 | s4
}

\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" \override VerticalAxisGroup.remove-first = ##t } <<
        \global 
        \new Voice = "sop" \with \voiceAttrs "S" { \sopMus }
      >>
      \new Lyrics \lyricsto "sop" \sopLyrA
      \new Lyrics \with \italicVerse \lyricsto "sop" \sopLyrB
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" \override VerticalAxisGroup.remove-first = ##t } <<
        \global 
        \new Voice = "alto" \with \voiceAttrs "A" { \altoMus }
      >>
      \new Lyrics \lyricsto "alto" \altoLyrA
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" \override VerticalAxisGroup.remove-first = ##t } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenMus }
      >>
      \new Lyrics \lyricsto "ten" \tenLyrA
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" \override VerticalAxisGroup.remove-first = ##t } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basMus }
      >>
      \new Lyrics \lyricsto "bas" \basLyrA
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
    \context { \Staff \RemoveEmptyStaves }
  }
}
