\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "Rappelle-toi, tu es sauvé"
  poet = "Texte : Fraternité de Tibériade, d'après Ap 2-3"
  composer = "Musique : Martin Szersnovicz"
  copyright = "© Communauté de Tibériade"
}

mr = #(define-music-function (r) (ly:music?)
  #{ \once \override Rest.staff-position = #0 $r #})

global = {
  \key c \minor
  \autoBeamOff
  \once \omit Staff.TimeSignature
  \time 31/8
  \tempo "Comme une psalmodie"
}
startMeasured = {
  \bar "||"
  \time 4/4
}

sop = \fixed c' {
  g8[ g] g4. g8 f[ g] aes[ aes] g[ f] g2 \mr r4 aes8[ bes] c'[ bes] aes g4 g8[ f] g2
  \startMeasured
  c'4 c'4. c'8[ c'] c' | g4 g8[ g] g[ g] f[ ees] | d2 \mr r2 |
  \mr r8 c' bes[ aes] g2 | \mr r8 f g[ aes] aes2 | \mr r8 d ees[ f] ees2 |
  aes4 aes8[ g] f4 f | g4 g g g8[ g] | g1 \bar "|."
}

alto = \fixed c' {
  ees8[ ees] ees4. ees8 d[ ees] f[ f] ees[ d] ees2 s4 f8[ g] aes[ g] f ees4 ees8[ d] ees2
  aes4 aes4. aes8[ aes] aes | ees4 ees8[ ees] ees[ ees] d[ c] | b,2 s2 |
  s8 aes g[ f] ees2 | s8 d ees[ f] f2 | s8 b, c[ d] c2 |
  ees4 ees8[ ees] d4 f | ees4 f ees ees8[ ees] | d1
}

tenor = \fixed c {
  c'8[ c'] c'4. c'8 c'[ c'] c'[ c'] c'[ c'] c'2 \mr r4 c'8[ c'] c'[ c'] c' c'4 c'8[ c'] c'2
  ees'4 ees'4. ees'8[ ees'] ees' | c'4 c'8[ c'] c'[ c'] aes[ f] | g2 \mr r2 |
  \mr r8 aes aes[ aes] bes2 | \mr r8 bes bes[ d'] c'2 | \mr r8 g g[ g] g2 |
  c'4 c'8[ c'] bes4 d' | bes4 b c' c'8[ c'] | c'2 b
}

basse = \fixed c {
  c8[ c] c4. c8 c[ c] c[ c] c[ c] c2 s4 c8[ c] c[ c] c c4 c8[ c] c2
  aes,4 aes,4. aes,8[ aes,] aes, | c4 c8[ c] c[ c] c[ c] | g,2 s2 |
  s8 aes, aes,[ aes,] ees2 | s8 bes, bes,[ bes,] f2 | s8 g g[ g] c2 |
  aes,4 aes,8[ aes,] bes,4 bes, | ees4 d c bes,8[ aes,] | g,1
}

accords = {
  \ch "Dom" 1*31/8
  \ch "La♭" 1 | \ch "Dom" 1 | \ch "Sol" 1 |
  s8 \ch "La♭" 4. \ch "Mi♭" 2 | s8 \ch "Si♭" 4. \ch "Fam" 2 | s8 \ch "Sol" 4. \ch "Dom" 2 |
  \ch "La♭" 2 \ch "Si♭" 2 | \ch "Mi♭" 2 \ch "Dom" 2 | \ch "Sol4" 2 \ch "Sol" 2 |
}

noRefrain = \repeat unfold 12 \skip 1

coupletA = \lyricmode {
  \set stanza = "1."
  Je con -- nais et ta cons -- tance et tes la -- beurs,
  tu as beau -- coup souf -- fert en mon nom.
  Pour -- quoi as -- tu per -- du ton a -- mour des pre -- miers "temps ?"
  \noRefrain
  Je te fe -- rai goû -- ter à l'ar -- bre de vie.
}
coupletB = \lyricmode {
  \set stanza = "2."
  Je con -- nais ta dé -- tresse et ta pau -- vre -- té,
  sois sans peur si tu vis la souf -- france.
  Pour -- quoi t'é -- loi -- gnes -- tu quand vient le temps de l'é -- "preuve ?"
  \noRefrain
  Je t'of -- fri -- rai la cou -- ron -- ne de la vie.
}
coupletC = \lyricmode {
  \set stanza = "3."
  Je con -- nais ta foi en moi et ton a -- mour,
  sois fort je viens à toi sans tar -- der.
  Pour -- quoi tour -- ner ton coeur et ta vie vers d'au -- tres "dieux ?"
  \noRefrain
  Je t'of -- fri -- rai un nom con -- nu de toi seul.
}
coupletD = \lyricmode {
  \set stanza = "4."
  Je con -- nais ton dé -- voue -- ment et ta bon -- té,
  tiens fer -- me -- ment jus -- qu'à mon re -- tour.
  Pour -- quoi vi -- vre sans moi et t'é -- ga -- rer loin de "moi ?"
  \override LyricText.font-series = #'bold
  \override LyricText.font-shape = #'upright
  Rap -- pel -- le -- "toi !" Tu es sau -- vé, re -- viens à moi.
  \revert LyricText.font-series
  \revert LyricText.font-shape
  Pour toi je se -- rai l'é -- toi -- le du ma -- tin.
}
coupletE = \lyricmode {
  \set stanza = "5."
  Je con -- nais tes oeu -- vres, tu t'es en -- dor -- mi,
  ré -- veil -- le -- toi car je viens à toi.
  Pour -- quoi mar -- cher sans moi et vou -- loir m'a -- ban -- don -- "ner ?"
  \noRefrain
  D'un vê -- te -- ment nup -- tial, je te vê -- ti -- rai.
}
coupletF = \lyricmode {
  \set stanza = "6."
  Je con -- nais ta fi -- dé -- li -- té à mon nom,
  à l'heu -- re de l'é -- preuve, je te garde.
  Pour -- quoi fer -- mer ton coeur, lais -- se -- toi seule -- ment ai -- mer.
  \noRefrain
  Je gra -- ve -- rai en toi le nom de ton Dieu.
}
coupletG = \lyricmode {
  \set stanza = "7."
  Je con -- nais ton coeur mais tu es mal -- heu -- reux,
  sois plus ar -- dent et ou -- vre ton coeur.
  Pour -- quoi vou -- loir cher -- cher la ri -- che -- sse loin de "moi ?"
  \noRefrain
  Je te fe -- rai re -- po -- ser près de mon Pè-re.
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
      \new Lyrics \with \italicVerse \lyricsto "sop" \coupletB
      \new Lyrics \lyricsto "sop" \coupletC
      \new Lyrics \with \italicVerse \lyricsto "sop" \coupletD
      \new Lyrics \lyricsto "sop" \coupletE
      \new Lyrics \with \italicVerse \lyricsto "sop" \coupletF
      \new Lyrics \lyricsto "sop" \coupletG
      \new Staff \with { instrumentName = \markup \center-column { T. B. } } <<
        \global \clef bass
        \new Voice = "ten" \with \voiceAttrs "T" { \voiceOne \tenor }
        \new Voice = "bas" \with \voiceAttrs "B" { \voiceTwo \basse }
      >>
    >>
  >>
  \layout { \chorusLayout indent = 7\mm }
}
