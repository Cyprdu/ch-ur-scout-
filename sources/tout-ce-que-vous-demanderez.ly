\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 22)

% Transcrit d'après une photo (« tout ce que vous demanderez.jpg », mélodie et accords).
% Partition seule : ce chant n'est pas publié sur le site (absent de chants.json).

\header {
  title = "Tout ce que vous demanderez"
  copyright = "Tous droits réservés · Cyprien Veyret"
}

% Pied de page propre à ce chant (remplace celui de chorale.ily)
\paper {
  oddFooterMarkup = \markup \if \on-last-page \column {
    \fill-line { \fontsize #-3 \italic \fromproperty #'header:copyright }
    \vspace #0.4
    \fill-line { \override #'(font-name . "Nimbus Sans") \fontsize #-3.5 \with-color #(rgb-color 0.55 0.55 0.55) "Paroisse de Montrevel-en-Bresse — 2026" }
  }
  evenFooterMarkup = \oddFooterMarkup
}

global = {
  \key g \major
  \time 4/4
}

melodie = {
  b'4 b'8 b' a' c'' a' fis' |
  g'4 g'8 g' fis' g' a'( g'~ | g'1) | \break
  b'8[ g'] e'[ g'] g'4 a'8 fis' | g'1 \bar "|."
}

accords = {
  \ch "Sol" 2 \ch "Ré" 2 |
  \ch "Mim" 2 \ch "Lam" 4 \ch "Ré" 4 | s1 |
  \ch "Do" 2 \ch "Ré" 2 | \ch "Sol" 1 |
}

paroles = \lyricmode {
  Tout ce que vous de -- man -- de -- rez
  dans la pri -- è -- re, __
  le Sei -- gneur vous le don -- ne -- ra.
}

\score {
  <<
    \new ChordNames \accords
    \new Staff << \global \new Voice = "mel" { \melodie } >>
    \new Lyrics \lyricsto "mel" \paroles
  >>
  \layout {
    \chorusLayout
    \context { \Score \remove "Bar_number_engraver" }
  }
}
