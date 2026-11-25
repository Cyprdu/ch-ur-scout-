\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 16)

\header {
  title = "L’éveil du Salut"
  poet = "Texte : Baudouin Tertrais"
  composer = "Musique : Jean de la Charie"
  copyright = "Édition ParFreeTion — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key a \minor
  \time 4/4
  \tempo 4 = 85
  \sectionLabel "REFRAIN"
  \partial 4 s4 | s1*6 \break s1*5 s2. \bar "||" \break
  \sectionLabel "L’étonnement des Hommes (couplets 1, 3, 5)" s4 | s1*4 \break s1*3 s2. \bar "||" \break
  \sectionLabel "La réponse de l’enfant Jésus (couplets 2, 4)" s4 | s1*4 \break s1*4 s4 \bar "||" \break
  \sectionLabel "CODA (après le dernier refrain)" \partial 4 s4 | s1*4 \break s1*4 \bar "|."
}

sopMus = {
  a'4\p | e'' c'' b' c'' | b'2 b'4 a'8 g' | a'2 a'4 b' | c''2. a'4 | bes' bes' c'' d'' | c''2~ c''8 c''\< c'' c'' |
  b'4 b' a'2\! | a'1\mf | c''4.\f c''8 c''4 c''8 c'' | b'2 b' | c''1\ff | c''2.
  c''4\mp | a'4. a'8 b'4 c'' | b'2 b'4 c''8 d'' | c''2 g' | a' a' |
  f'4. f'8 f'4 g'8 a' | b'2 b'4 b'8 b' | b'4 b' b'2 | a'2.
  c''4\p | b' b' c'' d'' | c''2. c''4 | f' g' a' g' | g'2 g'4 g'8 g' |
  d''2 c''4 b' | c''2. c''4 | f' a' b' c'' | d''2 d''~ | d''4
  c''\mp | b' b' c'' d'' | c''2. c''4 | f' g' a' g' | g'2 g'4 g'8 g' |
  d''2 c''4\> b' | c''2.\p c''4\< | a' a' a' b' | c''1\mp |
}

altoMus = {
  a'4 | a' a' g' g' | g'2 g'4 e'8 e' | fis'2 fis'4 gis' | a'2. e'4 | d' d' d' d' | f'2~ f'8 f' f' a' |
  a'4 g' e'2 | e' e'8( a' b') a' | a'2. a'8 a' | a'2 g' | g'1 | g'2.
  g'4 | f'4. f'8 g'4 a' | g'2 g'4 g'8 g' | g'2 g' | g'4. g'8 f'4 a' |
  d'2 d'4 d' | d'2 d'4 d'8 d' | e'4 e' e'2 | e'2.
  g'4 | g' g' a' b' | g'2. g'4 | f' f' f' f' | f'2 e'4 e'8 e' |
  g'2 g'4 g' | g'2. g'4 | f' f' f' f' | f'2 g'~ | g'4
  g' | g' g' a' b' | g'2. g'4 | f' f' f' f' | f'2 e'4 e'8 e' |
  g'2 g'4 g' | g'2. g'4 | f' f' f' f' | g'1 |
}

tenMus = {
  a4 | c' e' e' e' | d'2 d'4 d'8 d' | d'2 d'4 d' | e'2. c'4 | bes bes bes bes | a2~ a8 a a a |
  b4 d' d'2 | cis' e8( a b) e' | f'2. c'8 d' | d'2 d'4( e'8 f') | f'1 | e'2.
  e'4 | c'4. c'8 c'4 f' | d'2 d'4 d'8 d' | e'2 e' | c' c' |
  a4. a8 a4 b8 c' | b2 d'4 d'8 d' | b4 b d'2 | c'2.
  e'4 | d' d' d' d' | e'2. e'4 | c' c' c' c' | c'2 c'4 c'8 c' |
  b2 d'4 d' | c'2. c'4 | c' c' d' e'8( d') | c'2 b~ | b4
  e' | d' d' d' d' | e'2. e'4 | c' c' c' c' | c'2 c'4 c'8 c' |
  b2 d'4 d' | c'2. c'4 | c'2 b4( d') | f' d' e'2 |
}

basMus = {
  a4 | a a e c | g2 g4 g8 g | d2 c4 b, | a,2. a4 | f f f f | f2~ f8 f f f |
  g4 e a2 | a1 | r4 f8 f f4 d8 d | g2 g | c1 | c2.
  c4 | f4. f8 f4 d | g2 g4 g8 g | c2 c | f4. f8 f4 e |
  d2 d4 d | g2 g4 g8 g | gis4 gis a2 | a2.
  c4 | g g g g | c2. c4 | f f f f | c2 c4 c8 c |
  g2 g4 g8( f) | e2. e4 | f f d d | g2 g~ | g4
  c | g g g g | c2. c4 | f f f f | c2 c4 c8 c |
  g2 g4 g8( f) | e2. e4 | f f g g | c1 |
}

sopLyrA = \lyricmode {
  \unset stanza Ber -- cé par la ten -- dres -- se de Ma -- rie, de Jo -- seph, l’en -- fant Jé -- sus s’en -- dort et le sa -- lut s’é -- veil -- le! Glo -- ri -- a in ex -- cel -- sis De -- o! 
  \set stanza = "1." Tou -- te peur, tout es -- poir de -- vant ta paix s’ef -- fa -- ce, plus de trouble en mon cœur: ta gran -- deur me dé -- pas -- se!
  \set stanza = "2." N’aie crain -- te mon en -- fant, con -- tem -- ple le mys -- tè -- re d’un Dieu fait tout pe -- tit pour por -- ter ta mi -- sè -- re.
  \unset stanza Con -- tre toute é -- vi -- dence, je suis ton es -- pé -- ran -- ce, l’É -- ter -- nel en si -- lence est en -- tré dans le temps!
}

sopLyrB = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "3." Si pauvre par -- mi les pauvres, vê -- tu d’hu -- mi -- li -- té, __ _ tu men -- dies mon a -- mour Jé -- sus je veux t’ai -- mer! __ _
  \set stanza = "4." Re -- gar -- de bien ma mère, é -- cou -- te son si -- len -- ce, tou -- te plei -- ne de grâce, vers Dieu son cœur s’é -- lan -- ce.
}

sopLyrC = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "5." Sei -- gneur com -- ment te suivre? si pe -- tit dé -- mu -- ni, __ _ seul ton re -- gard me sauve car il est in -- fi -- ni! __ _
}

altoLyrA = \lyricmode {
  \unset stanza Ber -- cé par la ten -- dres -- se de Ma -- rie, de Jo -- seph, l’en -- fant Jé -- sus s’en -- dort et le sa -- lut s’é -- veil -- le! Glo -- ri -- a in ex -- cel -- sis De -- o! 
  \set stanza = "1." Tou -- te peur, tout es -- poir de -- vant ta paix s’ef -- fa -- ce, plus de trouble en mon cœur: ta gran -- deur me dé -- pas -- se!
  \set stanza = "2." N’aie crain -- te mon en -- fant, con -- tem -- ple le mys -- tè -- re d’un Dieu fait tout pe -- tit pour por -- ter ta mi -- sè -- re.
  \unset stanza Con -- tre toute é -- vi -- dence, je suis ton es -- pé -- ran -- ce, l’É -- ter -- nel en si -- lence est en -- tré dans le temps!
}

altoLyrB = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "3." Si pauvre par -- mi les pauvres, vê -- tu d’hu -- mi -- li -- té, __ _ tu men -- dies mon a -- mour Jé -- sus je veux t’ai -- mer! __ _
  \set stanza = "4." Re -- gar -- de bien ma mère, é -- cou -- te son si -- len -- ce, tou -- te plei -- ne de grâce, vers Dieu son cœur s’é -- lan -- ce.
}

altoLyrC = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "5." Sei -- gneur com -- ment te suivre? si pe -- tit dé -- mu -- ni, seul ton re -- gard __ _ me sauve car il est in -- fi -- ni! __ _
}

tenLyrA = \lyricmode {
  \unset stanza Ber -- cé par la ten -- dres -- se de Ma -- rie, de Jo -- seph, l’en -- fant Jé -- sus s’en -- dort et le sa -- lut s’é -- veil -- le! Glo -- ri -- a in ex -- cel -- sis De -- o! 
  \set stanza = "1." Tou -- te peur, tout es -- poir de -- vant ta paix s’ef -- fa -- ce, plus de trouble en mon cœur: ta gran -- deur me dé -- pas -- se!
  \set stanza = "2." N’aie crain -- te mon en -- fant, con -- tem -- ple le mys -- tè -- re d’un Dieu fait tout pe -- tit pour por -- ter ta mi -- sè -- re.
  \unset stanza Con -- tre toute é -- vi -- dence, je suis ton es -- pé -- ran -- ce, l’É -- ter -- nel en si -- lence est en -- tré dans le temps!
}

tenLyrB = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "3." Si pauvre par -- mi les pauvres, vê -- tu d’hu -- mi -- li -- té, __ _ tu men -- dies mon a -- mour Jé -- sus je veux t’ai -- mer! __ _
  \set stanza = "4." Re -- gar -- de bien ma mère, é -- cou -- te son si -- len -- ce, tou -- te plei -- ne de grâce, vers Dieu son cœur s’é -- lan -- ce.
}

tenLyrC = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "5." Sei -- gneur com -- ment te suivre? si pe -- tit dé -- mu -- ni, __ _ seul ton re -- gard me sauve car il est in -- fi -- ni! __ _
}

basLyrA = \lyricmode {
  \unset stanza Ber -- cé par la ten -- dres -- se de Ma -- rie, de Jo -- seph, l’en -- fant Jé -- sus s’en -- dort et le sa -- lut s’é -- veil -- le! Glo -- ri -- a in ex -- cel -- sis De -- o! 
  \set stanza = "1." Tou -- te peur, tout es -- poir de -- vant ta paix s’ef -- fa -- ce, plus de trouble en mon cœur: ta gran -- deur me dé -- pas -- se!
  \set stanza = "2." N’aie crain -- te mon en -- fant, con -- tem -- ple le mys -- tè -- re d’un Dieu fait tout pe -- tit pour por -- ter ta mi -- sè -- re.
  \unset stanza Con -- tre toute é -- vi -- dence, je suis ton es -- pé -- ran -- ce, l’É -- ter -- nel en si -- lence est en -- tré dans le temps!
}

basLyrB = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "3." Si pauvre par -- mi les pauvres, vê -- tu d’hu -- mi -- li -- té, __ _ tu men -- dies mon a -- mour Jé -- sus je veux t’ai -- mer! __ _
  \set stanza = "4." Re -- gar -- de bien ma mère, é -- cou -- te son si -- len -- ce, tou -- te plei -- ne de grâce, vers Dieu son cœur s’é -- lan -- ce.
}

basLyrC = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "5." Sei -- gneur com -- ment te suivre? si pe -- tit dé -- mu -- ni, seul ton re -- gard __ _ me sauve car il est in -- fi -- ni! __ _
}

\score {
  <<
    \new ChoirStaff <<
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global 
        \new Voice = "sop" \with \voiceAttrs "S" { \sopMus }
      >>
      \new Lyrics \lyricsto "sop" \sopLyrA
      \new Lyrics \with \italicVerse \lyricsto "sop" \sopLyrB
      \new Lyrics \lyricsto "sop" \sopLyrC
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global 
        \new Voice = "alto" \with \voiceAttrs "A" { \altoMus }
      >>
      \new Lyrics \lyricsto "alto" \altoLyrA
      \new Lyrics \with \italicVerse \lyricsto "alto" \altoLyrB
      \new Lyrics \lyricsto "alto" \altoLyrC
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenMus }
      >>
      \new Lyrics \lyricsto "ten" \tenLyrA
      \new Lyrics \with \italicVerse \lyricsto "ten" \tenLyrB
      \new Lyrics \lyricsto "ten" \tenLyrC
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basMus }
      >>
      \new Lyrics \lyricsto "bas" \basLyrA
      \new Lyrics \with \italicVerse \lyricsto "bas" \basLyrB
      \new Lyrics \lyricsto "bas" \basLyrC
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
