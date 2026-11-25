\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 20)

% Mélodie (soprano du refrain, soliste du verset) d'après « Alleluia - Missa Pro Europa PDF.pdf ».
% Accords à venir : les écrire dans « accords » (ex. \ch "La♭" 4) aux mêmes durées que la mélodie.
% Partition seule : ce chant n'est pas publié sur le site (absent de chants.json).

\header {
  title = "Alleluia"
  subtitle = "Missa Pro Europa"
  poet = "Paroles : Frère David (En Calcat)"
  composer = "Musique : Jacques Berthier"
  copyright = "Tous droits réservés"
}

\paper {
  oddFooterMarkup = \markup \if \on-last-page \column {
    \fill-line { \fontsize #-3 \italic \fromproperty #'header:copyright }
    \vspace #0.4
    \fill-line { \override #'(font-name . "Nimbus Sans") \fontsize #-3.5 \with-color #(rgb-color 0.55 0.55 0.55) "Paroisse de Montrevel-en-Bresse — 2026" }
  }
  evenFooterMarkup = \oddFooterMarkup
  markup-system-spacing.basic-distance = #20
  score-markup-spacing.padding = #8
  score-system-spacing.padding = #6
  system-system-spacing.basic-distance = #18
}

refrain = {
  \key aes \major
  \time 2/2
  \tempo "Vivace" 4 = 100
  \sectionLabel "Refrain"
  \repeat volta 2 {
    \partial 4 es'8\f es' |
    aes'4( g') f' des''8 c'' | bes'8( aes' bes'4) c'' es'8 es' | \break
    aes'4( g') f' des''8 c'' | bes'8( aes' g'4) aes'2 |
  }
}

verset = {
  \key aes \major
  \time 4/4
  \tempo "Lento"
  \sectionLabel \markup { "Verset de la Visitation" \normal-text \italic " (soliste ou petit chœur)" }
  r4\p \tuplet 3/2 { g'8 g' g' } g'4 \tuplet 3/2 { c''8 c'' g' } |
  aes'4 aes'8 aes' bes'4 bes'8 bes' |
  des''8 des'' des'' des'' c''4 g'8 g' |
  \tuplet 3/2 { aes'8 aes' aes' } \tuplet 3/2 { aes'8 g' aes' } bes'2
  \bar "|." \mark \markup \bold "D.C."
}

refrainParoles = \lyricmode {
  Al -- le -- lu -- ia Al -- le -- lu -- ia! Al -- le -- lu -- ia Al -- le -- lu -- ia!
}
versetParoles = \lyricmode {
  Heu -- reuse es -- tu, Vier -- ge Ma -- rie_: Tu as cru que s'ac --
  com -- pli -- rait pour toi la Pa -- ro -- le re -- çue du Sei -- gneur_!
}

accordsRefrain = {
  s4 |
  \ch "La♭" 2 \ch "Ré♭" 2 | \ch "Mi♭" 2 \ch "La♭" 2 |
  \ch "La♭" 2 \ch "Ré♭" 2 | \ch "Mi♭sus4" 4 \ch "3" 4 \ch "Ré♭" 2 |
}
accordsVerset = {
  s4 \ch "Do" 2. | \ch "Fam" 2 \ch "Mi♭" 2 |
  \ch "Sol♭" 2 \ch "Do" 2 | \ch "Fam" 2 \ch "Mi♭" 2 |
}

\score {
  <<
    \new ChordNames \accordsRefrain
    \new Staff \new Voice = "r" { \refrain }
    \new Lyrics \lyricsto "r" \refrainParoles
  >>
  \layout { \chorusLayout }
}

\score {
  <<
    \new ChordNames \accordsVerset
    \new Staff \new Voice = "v" { \verset }
    \new Lyrics \lyricsto "v" \versetParoles
  >>
  \layout { \chorusLayout }
}
