\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 20)

\header {
  title = "Approchons-nous de la table"
  category = "COMMUNION"
  number = "11-08"
  poet = "Paroles et musique : M. Dannaud"
  copyright = "© 1994, Éditions de l'Emmanuel, 26 rue de l'Abbé Grégoire, 75006 Paris"
}

global = {
  \key g \major
  \time 4/4
  \numericTimeSignature
}

sop = \relative c'' {
  b4 b a a | g g fis fis | g g b b8 b | c4 b8 g a2 | \break
  b4 b a a | g g fis fis | g g b b8 b | a g g fis g2 \bar "|."
}

alto = \relative c' {
  g'4 g fis fis | e e fis fis | e e d d8 e | e4 e8 e fis2
  g4 g fis fis | e e fis fis | e e d d8 e | e e d d d2
}

tenor = \relative c' {
  d4 d d d | b b d d | c c b b8 b | a4 b8 b d2
  d4 d d d | b b d d | c c b b8 b | c c c c b2
}

basse = \relative c {
  g'4 g d d | e e b b | e e g g8 g | a4 g8 e d2
  g4 g d d | e e b b | e e g g8 g | a a d, d <g g,>2
}

accords = {
  \ch "Sol" 2 \ch "Ré" 2 | \ch "Mim" 2 \ch "Sim" 2 | \ch "Do" 2 \ch "Sol" 2 |
  \ch "Lam" 4 \ch "Mim" 4 \ch "Ré" 2 |
  \ch "Sol" 2 \ch "Ré" 2 | \ch "Mim" 2 \ch "Sim" 2 | \ch "Do" 2 \ch "Sol" 2 |
  \ch "Lam" 4 \ch "Ré" 4 \ch "Sol" 2 |
}

coupletA = \lyricmode {
  \set stanza = "1."
  Ap -- pro -- chons -- nous de la ta -- ble
  où le Christ va s'of -- frir par -- mi nous.
  \set stanza = "1."
  Of -- frons -- lui ce que nous som -- mes
  car le Christ va nous trans -- for -- mer en lui.
}
coupletB = \lyricmode {
  \set stanza = "2."
  Voi -- ci l'ad -- mi -- ra -- ble~é -- chan -- ge
  où le Christ prend sur lui nos pé -- chés.
  \set stanza = "2."
  Met -- tons -- nous en sa pré -- sen -- ce,
  il nous re -- vêt de sa di -- vi -- ni -- té.
}
coupletC = \lyricmode {
  \set stanza = "3."
  Pè -- re nous te ren -- dons grâ -- ce
  pour ton fils Jé -- sus Christ le Sei -- gneur.
  \set stanza = "3."
  Par ton Es -- prit de puis -- san -- ce,
  rends -- nous di -- gnes de vi -- vre de tes dons.
}

\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff \with { instrumentName = \markup \center-column { S. A. } } <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \voiceOne \sop }
        \new Voice = "alto" \with \voiceAttrs "A" { \voiceTwo \alto }
      >>
      \new Lyrics \lyricsto "sop" \coupletA
      \new Lyrics \lyricsto "sop" \coupletB
      \new Lyrics \lyricsto "sop" \coupletC
      \new Staff \with { instrumentName = \markup \center-column { T. B. } } <<
        \global \clef bass
        \new Voice = "ten" \with \voiceAttrs "T" { \voiceOne \tenor }
        \new Voice = "bas" \with \voiceAttrs "B" { \voiceTwo \basse }
      >>
    >>
  >>
  \layout {
    \chorusLayout
    indent = 7\mm
    \context { \Score \override NonMusicalPaperColumn.line-break-permission = ##f }
  }
}
