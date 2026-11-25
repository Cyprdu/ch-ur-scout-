\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 18)

% Mélodie (Soprano 1) et accords d'après « Partition de la Missa Pro Europa.pdf ».
% Refrain : accords de l'original. Psalmodie : accords déduits des 4 voix (alto, ténor, basse).
% Partition seule : ce chant n'est pas publié sur le site (absent de chants.json).

\header {
  title = "Missa Pro Europa – Gloria"
  subtitle = "Mélodie et accords"
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
  system-system-spacing.basic-distance = #13
}

% « // » de l'original : reprise du refrain
reprise = \mark \markup \fontsize #-1 \bold "//"

melodie = {
  \key f \major
  \time 4/4
  \tempo 4 = 92
  \sectionLabel "Refrain"
  c''8 d'' c''4 a'8 bes' a'4 | f'8 f' bes' a' g'4 a' |
  c''8 d'' c''4 a'8 bes' a'4 | f'8 f' bes' a' g'4 f' \bar "|." \break

  \sectionLabel "Psalmodie"
  \cadenzaOn \omit Staff.TimeSignature
  a'1 c'' a'4 a'1 g'4 \bar "||"
  f'1 e'4 \bar "|" f'1 e'4 \bar "|" \break
  f'1 e'4 \bar "|" f'1 g'4 \bar "|"
  a'1 a'4 a'1 c''1 a'4 a' \bar "|" \break
  \reprise
  g'1 g'4 \bar "|" bes'1 bes'4 \bar "|" g'1 f'8 g'4 \bar "||"
  a'1 a'4 \bar "|" \break
  \reprise
  c''1 a'4 a' \bar "|" a'1 a'4 a'1 a'4 c''1 a'4 a' \bar "|" \break
  \reprise
  bes'1 bes'4 \bar "|" g'1 f'8 g'4 g' \bar "|" bes'1 bes'4 \bar "|" \break
  g'1 e'8 g'4 g' \bar "|" bes'1 bes'4 \bar "|"
  c''8 c'' bes' bes' c''4 c'' \bar "||" \break
  \reprise
  d''1 c''8 c'' a'4 a' \bar "|" d''1 c''4 c''8 c'' a'4 \bar "|" d''1 c''8 c'' a'4 \bar "|" \break
  \reprise
  a'4 a' g' g' \bar "|" f'1 e'4 \bar "|" f'1 g'4 g' \bar "|" a'2( c'') c''1 \bar "|."
}

accords = {
  % refrain (original)
  \ch "Fa" 4 \ch "Do" 4 \ch "Rém" 4 \ch "Lam" 4 | \ch "Si♭" 2 \ch "Do" 4 \ch "Fa" 4 |
  \ch "Fa" 4 \ch "Do" 4 \ch "Rém" 4 \ch "Lam" 4 | \ch "Si♭" 2 \ch "Do" 4 \ch "Fa" 4 |
  % psalmodie (d'après les 4 voix)
  \ch "Fa" 1 \ch "Do" 1 \ch "Fa" 4 s1 \ch "Do" 4
  \ch "Rém" 1 \ch "La" 4 \ch "Rém" 1 \ch "La" 4
  \ch "Rém" 1 \ch "La" 4 \ch "Rém" 1 \ch "Do" 4
  \ch "Fa" 1 s4 s1 \ch "Do" 1 \ch "Fa" 4 s4
  \ch "Do" 1 s4 \ch "Solm" 1 s4 \ch "Do" 1 s8 s4
  \ch "Rém7" 1 s4
  \ch "Do" 1 \ch "Fa" 4 s4 \ch "Fa" 1 s4 s1 s4 \ch "Do" 1 \ch "Fa" 4 s4
  \ch "Solm" 1 s4 \ch "Do" 1 s8 s4 s4 \ch "Solm" 1 s4
  \ch "Do" 1 s8 s4 s4 \ch "Solm" 1 s4
  \ch "Do7" 1
  \ch "Si♭" 1 \ch "Do" 4 \ch "Fa" 4 s4
  \ch "Si♭" 1 s4 \ch "Do" 4 \ch "Fa" 4
  \ch "Si♭" 1 \ch "Do" 4 \ch "Fa" 4
  \ch "Fa" 2 \ch "Do" 2 \ch "Rém" 1 \ch "La" 4 \ch "Rém" 1 \ch "Do" 4 s4
  \ch "Fa" 2 \ch "Do" 2 \ch "Fa" 1
}

paroles = \lyricmode {
  Glo -- ri -- a, glo -- ri -- a, in ex -- cel -- sis De -- o!
  Glo -- ri -- a, glo -- ri -- a, in ex -- cel -- sis De -- o!
  % psalmodie : le texte d'une ronde se récite sur cette note
  \override LyricText.self-alignment-X = #LEFT
  "Et in terra" "pax homini" -- bus "bonae volunta" -- tis.
  "Laudamus" te, "Benedicimus" te,
  "Adoramus" te, "Glorificamus" te,
  "Gratias agimus ti" -- bi "propter magnam" "gloriam" tu -- am,
  "Domine De" -- us, "Rex caeles" -- tis, "Deus Pater omni" -- po -- tens,
  "Domine Fili unigeni" -- te,
  "Jesu" Chris -- te, "Domine De" -- us, "Agnus De" -- i "Filius" Pa -- tris.
  "Qui tollis peccata mun" -- di, "misere" -- re no -- bis.
  "Qui tollis peccata mun" -- di,
  "Suscipe deprecatio" -- nem nos -- tram.
  "Qui sedes ad dexteram Pa" -- tris, mi -- se -- re -- re no -- bis.
  "Quoniam tu" so -- lus sanc -- tus, "Tu so" -- lus Do -- mi -- nus,
  "Tu solus al" -- tis -- si -- mus,
  Je -- su Chris -- te, "cum Sancto Spiri" -- tu "in gloria Dei" Pa -- tris. A -- men!
}

\score {
  <<
    \new ChordNames \accords
    \new Staff \new Voice = "mel" { \melodie }
    \new Lyrics \lyricsto "mel" \paroles
  >>
  \layout {
    \chorusLayout
    \context { \Score \remove "Bar_number_engraver" }
  }
}
