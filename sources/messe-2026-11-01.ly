\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 19)
\include "messe-parts.ly"

% ---- Gloria et Alleluia (repris de missa-pro-europa-*.ly)
glReprise = \mark \markup \fontsize #-1 \bold "//"

glMelodie = {
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
  \glReprise
  g'1 g'4 \bar "|" bes'1 bes'4 \bar "|" g'1 f'8 g'4 \bar "||"
  a'1 a'4 \bar "|" \break
  \glReprise
  c''1 a'4 a' \bar "|" a'1 a'4 a'1 a'4 c''1 a'4 a' \bar "|" \break
  \glReprise
  bes'1 bes'4 \bar "|" g'1 f'8 g'4 g' \bar "|" bes'1 bes'4 \bar "|" \break
  g'1 e'8 g'4 g' \bar "|" bes'1 bes'4 \bar "|"
  c''8 c'' bes' bes' c''4 c'' \bar "||" \break
  \glReprise
  d''1 c''8 c'' a'4 a' \bar "|" d''1 c''4 c''8 c'' a'4 \bar "|" d''1 c''8 c'' a'4 \bar "|" \break
  \glReprise
  a'4 a' g' g' \bar "|" f'1 e'4 \bar "|" f'1 g'4 g' \bar "|" a'2( c'') c''1 \bar "|."
}

glAccords = {
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

glParoles = \lyricmode {
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


alRefrain = {
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

alVerset = {
  \key aes \major
  \time 4/4
  \tempo "Lento"
  \sectionLabel \markup { "Verset de la Visitation" \normal-text \italic " (soliste ou petit chœur)" }
  r4\p \tuplet 3/2 { g'8 g' g' } g'4 \tuplet 3/2 { c''8 c'' g' } |
  aes'4 aes'8 aes' bes'4 bes'8 bes' |
  des''8 des'' des'' des'' c''4 g'8 g' |
  \tuplet 3/2 { aes'8 aes' aes' } \tuplet 3/2 { aes'8 g' aes' } bes'2
  \bar "|." \mark \markup \italic "D.C."
}

alRefrainParoles = \lyricmode {
  Al -- le -- lu -- ia Al -- le -- lu -- ia! Al -- le -- lu -- ia Al -- le -- lu -- ia!
}
alVersetParoles = \lyricmode {
  Heu -- reuse es -- tu, Vier -- ge Ma -- rie_: Tu as cru que s'ac --
  com -- pli -- rait pour toi la Pa -- ro -- le re -- çue du Sei -- gneur_!
}

alAccordsRefrain = {
  s4 |
  \ch "La♭" 2 \ch "Ré♭" 2 | \ch "Mi♭" 2 \ch "La♭" 2 |
  \ch "La♭" 2 \ch "Ré♭" 2 | \ch "Mi♭sus4" 4 \ch "3" 4 \ch "Ré♭" 2 |
}
alAccordsVerset = {
  s4 \ch "Do" 2. | \ch "Fam" 2 \ch "Mi♭" 2 |
  \ch "Sol♭" 2 \ch "Do" 2 | \ch "Fam" 2 \ch "Mi♭" 2 |
}



\paper {
  print-first-page-number = ##t
  ragged-bottom = ##t
  system-system-spacing.basic-distance = #15
  score-system-spacing.padding = #4
  score-markup-spacing.padding = #5
  markup-system-spacing.padding = #3
  oddHeaderMarkup = \markup \fill-line {
    \unless \on-first-page-of-part \fontsize #-2 \italic \fromproperty #'header:title
    \null
    \unless \on-first-page-of-part \fontsize #-2 "Dimanche 1er novembre 2026"
  }
  evenHeaderMarkup = \oddHeaderMarkup
  oddFooterMarkup = \markup \column {
    \fill-line {
      \override #'(font-name . "Nimbus Sans") \fontsize #-3.5 \with-color #(rgb-color 0.45 0.45 0.45)
        "Tous droits réservés · Cyprien Veyret · Paroisse Saint-Nizier, Lyon"
    }
    \vspace #0.2
    \fill-line { \fontsize #-2 \fromproperty #'page:page-number-string }
  }
  evenFooterMarkup = \oddFooterMarkup
}

\book {
\bookpart {
  \paper { oddFooterMarkup = \markup \fill-line {
      \override #'(font-name . "Nimbus Sans") \fontsize #-3.5 \with-color #(rgb-color 0.45 0.45 0.45)
        "Tous droits réservés · Cyprien Veyret · Paroisse Saint-Nizier, Lyon" } }
  \markup \column {
    \vspace #6
    \fill-line { \override #'(font-name . "Nimbus Sans Bold") \fontsize #-1 \with-color #(rgb-color 0.6 0.1 0.1) "PAROISSE SAINT-NIZIER · LYON" }
    \vspace #1.5
    \fill-line { \override #'(font-name . "C059 Bold") \fontsize #8 "Dimanche 1er novembre 2026" }
    \vspace #0.6
    \fill-line { \override #'(font-name . "C059 Italic") \fontsize #3 "Tous les saints et les saintes de Dieu" }
    \vspace #1
    \fill-line { \fontsize #-1 "Mélodies et accords pour les musiciens" }
    \vspace #5
    \fill-line { \override #'(font-name . "Nimbus Sans Bold") \fontsize #-1 "DÉROULÉ" }
    \vspace #1.5
        \fill-line { \line { \hspace #4 \fontsize #1 "Les saints et les saintes de Dieu" } \line { \fontsize #1 "2" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Kyrie — Missa Pro Europa" } \line { \fontsize #1 "3" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Gloria — Missa Pro Europa" } \line { \fontsize #1 "4" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #-1 \italic \with-color #(rgb-color 0.45 0.45 0.45) "Première lecture — Ap 7, 2-4.9-14" } \null }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #-1 \italic \with-color #(rgb-color 0.45 0.45 0.45) "Psaume — Ps 23 (24), 1-2, 3-4ab, 5-6" } \null }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #-1 \italic \with-color #(rgb-color 0.45 0.45 0.45) "Deuxième lecture — 1 Jn 3, 1-3" } \null }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Alleluia — Missa Pro Europa" } \line { \fontsize #1 "5" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #-1 \italic \with-color #(rgb-color 0.45 0.45 0.45) "Évangile — Mt 5, 1-12a" } \null }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #-1 \italic \with-color #(rgb-color 0.45 0.45 0.45) "Prière universelle" } \null }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Heureux, bienheureux" } \line { \fontsize #1 "6" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Sanctus — Missa Pro Europa" } \line { \fontsize #1 "7" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Agnus Dei — Missa Pro Europa" } \line { \fontsize #1 "8" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Céleste Jérusalem" } \line { \fontsize #1 "9" \hspace #4 } }
    \vspace #0.8
    \fill-line { \line { \hspace #4 \fontsize #1 "Il est temps de quitter vos tombeaux" } \line { \fontsize #1 "10" \hspace #4 } }
  }
}
\bookpart {
  \header {
    title = "Les saints et les saintes de Dieu"
    subtitle = "Hymnes et cantiques"
    poet = ""
    composer = ""
  }
  \score {
    <<
      \new ChordNames \lsRefAcc
      \new Staff \new Voice = "v229775" \lsRef
      \new Lyrics \lyricsto "v229775" \lsRefTxt
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \lsCplAcc
      \new Staff \new Voice = "v853652" \lsCpl
      \new Lyrics \lyricsto "v853652" \lsV
      \new Lyrics \lyricsto "v853652" \lsVb
      \new Lyrics \lyricsto "v853652" \lsVc
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Kyrie"
    subtitle = "Missa Pro Europa"
    poet = "Texte : Missel romain"
    composer = "Musique : Jacques Berthier"
  }
  \score {
    <<
      \new ChordNames \kyAcc
      \new Staff \new Voice = "v115725" \kyMel
      \new Lyrics \lyricsto "v115725" \kyTxt
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Gloria"
    subtitle = "Missa Pro Europa"
    poet = "Texte : Missel romain"
    composer = "Musique : Jacques Berthier"
  }
  \score {
    <<
      \new ChordNames \glAccords
      \new Staff \new Voice = "v281906" \glMelodie
      \new Lyrics \lyricsto "v281906" \glParoles
    >>
    \layout { \chorusLayout \context { \Score \remove "Bar_number_engraver" } }
  }
}
\bookpart {
  \header {
    title = "Alleluia"
    subtitle = "Missa Pro Europa"
    poet = "Paroles : Frère David (En Calcat)"
    composer = "Musique : Jacques Berthier"
  }
  \score {
    <<
      \new ChordNames \alAccordsRefrain
      \new Staff \new Voice = "v686858" \alRefrain
      \new Lyrics \lyricsto "v686858" \alRefrainParoles
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \alAccordsVerset
      \new Staff \new Voice = "v371720" \alVerset
      \new Lyrics \lyricsto "v371720" \alVersetParoles
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Heureux, bienheureux"
    subtitle = "Toussaint · Mt 5, 1-12"
    poet = "Texte et musique : Communauté de l’Emmanuel"
    composer = "Harmonisation : Alain Langrée"
  }
  \score {
    <<
      \new ChordNames \heRefAcc
      \new Staff \new Voice = "v8132" \heRef
      \new Lyrics \lyricsto "v8132" \heRefTxt
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \heStrAcc
      \new Staff \new Voice = "v129138" \heStr
      \new Lyrics \lyricsto "v129138" \heSa
      \new Lyrics \lyricsto "v129138" \heSb
      \new Lyrics \lyricsto "v129138" \heSc
      \new Lyrics \lyricsto "v129138" \heSd
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \heCinqAcc
      \new Staff \new Voice = "v823116" \heCinq
      \new Lyrics \lyricsto "v823116" \heCinqTxt
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Sanctus"
    subtitle = "Missa Pro Europa"
    poet = "Texte : Missel romain"
    composer = "Musique : Jacques Berthier"
  }
  \score {
    <<
      \new ChordNames \saAcc
      \new Staff \new Voice = "v139674" \saMel
      \new Lyrics \lyricsto "v139674" \saTxt
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Agnus Dei"
    subtitle = "Missa Pro Europa"
    poet = "Texte : Missel romain"
    composer = "Musique : Jacques Berthier"
  }
  \score {
    <<
      \new ChordNames \agAAcc
      \new Staff \new Voice = "v285867" \agA
      \new Lyrics \lyricsto "v285867" \agATxt
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \agMAcc
      \new Staff \new Voice = "v662595" \agM
      \new Lyrics \lyricsto "v662595" \agMa
      \new Lyrics \lyricsto "v662595" \agMb
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \agMAcc
      \new Staff \new Voice = "v110928" \agD
      \new Lyrics \lyricsto "v110928" \agDTxt
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Céleste Jérusalem"
    subtitle = ""
    poet = "Paroles d’après l’Apocalypse"
    composer = "Musique : S.-E. Vongue"
  }
  \score {
    <<
      \new ChordNames \ceRefAcc
      \new Staff \new Voice = "v439741" \ceRef
      \new Lyrics \lyricsto "v439741" \ceRefTxt
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \ceCplAcc
      \new Staff \new Voice = "v788634" \ceCpl
      \new Lyrics \lyricsto "v788634" \ceVa
      \new Lyrics \lyricsto "v788634" \ceVb
      \new Lyrics \lyricsto "v788634" \ceVc
    >>
    \layout { \chorusLayout  }
  }
}
\bookpart {
  \header {
    title = "Il est temps de quitter vos tombeaux"
    subtitle = "Louange"
    poet = "Paroles et musique : Chants de l’Emmanuel (V. Hendricks)"
    composer = "© 2007 Éditions de l’Emmanuel"
  }
  \score {
    <<
      \new ChordNames \itRefAcc
      \new Staff \new Voice = "v251818" \itRef
      \new Lyrics \lyricsto "v251818" \itRefTxt
    >>
    \layout { \chorusLayout  }
  }
  \score {
    <<
      \new ChordNames \itCplAcc
      \new Staff \new Voice = "v531633" \itCpl
      \new Lyrics \lyricsto "v531633" \itVa
      \new Lyrics \lyricsto "v531633" \itVb
      \new Lyrics \lyricsto "v531633" \itVc
      \new Lyrics \lyricsto "v531633" \itVd
    >>
    \layout { \chorusLayout  }
  }
}
}
