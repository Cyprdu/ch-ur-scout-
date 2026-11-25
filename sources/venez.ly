\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "Venez tous, accourez…"
  composer = "Musique : Benoît Collet"
  copyright = "Édition ParFreeTion — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key g \major
  \time 4/4
  \tempo 4 = 115
  \sectionLabel "COUPLETS"
  s1*4 \break s1*3 \time 2/4 s2 \bar "||" \break
  \sectionLabel "FARANDOLE" s2*8 \break s2*8 \bar "|."
}

sopMus = {
  b8 dis' e' fis' g'2 | a'8 g' fis' e' dis'4 dis' | b8 dis' fis' g' a'2 | b'8 a' g' fis' e'4 e' |
  c''8 c'' b' a' b'4 b' | c''8 c'' b' a' b'2 | a'4 c'' b'8 a' g' fis' | e'2 |
  b'8 b' b' a'16 b' | c''4. c''16 b' | a'8 a' a' g'16 a' | b'4. b'16 a' | g'8 g' g' fis'16 g' | a'4 c'' | dis' b'8 a' | g'2 |
  b'8 b' b' a'16 b' | c''4. c''16 b' | a'8 a' a' g'16( a') | b'4. b'16 a' | g'8 g' g' fis'16 g' | a'4 c'' | fis'8 fis' fis' e' | e'4 e' |
}

altoMus = {
  b8 dis' e' fis' g'2 | a'8 g' fis' e' dis'4 dis' | b8 dis' fis' g' a'2 | b'8 a' g' fis' e'4 e' |
  a'8 a' g' fis' g'4 g' | a'8 a' g' fis' g'2 | fis'4 a' g'8 fis' e' dis' | e'2 |
  g'8 g' g' fis'16 g' | a'4. a'16 g' | fis'8 fis' fis' e'16 fis' | g'4. g'16 fis' | e'8 e' e' dis'16 e' | fis'4 fis' | fis' fis'8 fis' | e'2 |
  g'8 g' g' fis'16 g' | a'4. a'16 g' | fis'8 fis' fis' e'16( fis') | g'4. g'16 fis' | e'8 e' e' dis'16 e' | fis'4 a' | dis'8 dis' dis' b | b4 b |
}

tenMus = {
  fis1^\markup \italic "B.F." | fis | fis | fis2 g | c' b | c' b | c'4 b b8 b b a | g2 |
  e'8 e' e' e'16 e' | e'4. e'16 e' | d'8 d' d' d'16 d' | d'4. d'16 c' | c'8 c' c' c'16 c' | c'4 c' | b b8 b | b2 |
  e'8 e' e' e'16 e' | e'4. e'16 e' | d'8 d' d' d' | d'4. d'16 d' | c'8 c' c' c'16 c' | c'4 c' | b8 b a g | g4 g |
}

basMus = {
  b,1^\markup \italic "B.F." | b, | b, | b,2 e | a, e | a, e | a,4 a, b,8 b, b, b, | e2 |
  e8 e e e16 e | a4. a16 a | d8 d d d16 d | g4. g16 g | c8 c c c16 b, | a,4 a, | b, cis8 dis | e2 |
  e8 e e e16 e | a4. a16 a | d8 d d d | g4. g16 g | c8 c c c16 b, | a,4 a, | b,8 b, b, b, | e4 e |
}

sopLyrA = \lyricmode {
  \set stanza = "1." Tout le ciel s’em -- plit d’u -- ne joie nou -- velle; __ _ On en -- tend la nuit di -- re la mer -- veil -- le. Fê -- te sans pa -- reil -- le; Le Sau -- veur est né; L’En -- fant Dieu nous est don -- né!
  \unset stanza Ve -- nez tous, ac -- cou -- rez, à la crèche, ve -- nez a -- do -- rer, car l’en -- fant qui y est cou -- ché, est le Roi du Ciel. Il vient pour nous sau -- ver de la mort et du pé -- ché, car Il vient pour nous em -- me -- ner vers la Vie é -- ter -- nel -- le!
}

sopLyrB = \lyricmode {
  \set stanza = "2." Le Sei -- gneur pa -- raît, Ver -- be de lu -- mière; __ _ L’u -- ni -- vers con -- naît la bon -- té du Pè -- re. Dieu sur no -- tre ter -- re; Vient tra -- cer la voie; Où che -- mi -- ne -- ront nos pas!
}

sopLyrC = \lyricmode {
  \set stanza = "3." A -- vec les ber -- gers, a -- vec tous les sages; __ _ C’est le monde en -- tier qui vers Lui s’en -- ga -- ge Pour voir le vi -- sa -- ge de l’A -- mour vi -- vant; qui pour nous s’est fait en -- fant!
}

sopLyrD = \lyricmode {
  \set stanza = "4." Gloire à Jé -- sus Christ, Gloire au Fils du Père; __ _ Gloire à son Es -- prit dont l’A -- mour é -- clai -- re. L’é -- cla -- tant mys -- tè -- re qui rem -- plit le Ciel; Gloire à l’Hom -- me Dieu, No -- ël!
}

altoLyrA = \lyricmode {
  \set stanza = "1." Tout le ciel s’em -- plit d’u -- ne joie nou -- velle; __ _ On en -- tend la nuit di -- re la mer -- veil -- le. Fê -- te sans pa -- reil -- le; Le Sau -- veur est né; L’En -- fant Dieu nous est don -- né!
  \unset stanza Ve -- nez tous, ac -- cou -- rez, à la crèche, ve -- nez a -- do -- rer, car l’en -- fant qui y est cou -- ché, est le Roi du Ciel. Il vient pour nous sau -- ver de la mort et du pé -- ché, car Il vient pour nous em -- me -- ner vers la Vie é -- ter -- nel -- le!
}

altoLyrB = \lyricmode {
  \set stanza = "2." Le Sei -- gneur pa -- raît, Ver -- be de lu -- mière; __ _ L’u -- ni -- vers con -- naît la bon -- té du Pè -- re. Dieu sur no -- tre ter -- re; Vient tra -- cer la voie; Où che -- mi -- ne -- ront nos pas!
}

altoLyrC = \lyricmode {
  \set stanza = "3." A -- vec les ber -- gers, a -- vec tous les sages; __ _ C’est le monde en -- tier qui vers Lui s’en -- ga -- ge Pour voir le vi -- sa -- ge de l’A -- mour vi -- vant; qui pour nous s’est fait en -- fant!
}

altoLyrD = \lyricmode {
  \set stanza = "4." Gloire à Jé -- sus Christ, Gloire au Fils du Père; __ _ Gloire à son Es -- prit dont l’A -- mour é -- clai -- re. L’é -- cla -- tant mys -- tè -- re qui rem -- plit le Ciel; Gloire à l’Hom -- me Dieu, No -- ël!
}

tenLyrA = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "1." L’En -- fant Dieu nous est don -- né!
  \unset stanza Ve -- nez tous, ac -- cou -- rez, à la crèche, ve -- nez a -- do -- rer, car l’en -- fant qui y est cou -- ché, est le Roi du Ciel. Il vient pour nous sau -- ver de la mort et du pé -- ché, car Il vient pour nous em -- me -- ner vers la Vie é -- ter -- nel -- le!
}

tenLyrB = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "2." Où che -- mi -- ne -- ront nos pas!
}

tenLyrC = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "3." qui pour nous s’est fait en -- fant!
}

tenLyrD = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "4." Gloire à l’Hom -- me Dieu, No -- ël!
}

basLyrA = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "1." L’En -- fant Dieu nous est don -- né!
  \unset stanza Ve -- nez tous, ac -- cou -- rez, à la crèche, ve -- nez a -- do -- rer, car l’en -- fant qui y est cou -- ché, est le Roi du Ciel. Il vient pour nous sau -- ver de la mort et du pé -- ché, car Il vient pour nous em -- me -- ner vers la Vie é -- ter -- nel -- le!
}

basLyrB = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "2." Où che -- mi -- ne -- ront nos pas!
}

basLyrC = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "3." qui pour nous s’est fait en -- fant!
}

basLyrD = \lyricmode {
  \repeat unfold 9 \skip 1
  \set stanza = "4." Gloire à l’Hom -- me Dieu, No -- ël!
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
      \new Lyrics \with \italicVerse \lyricsto "sop" \sopLyrD
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global 
        \new Voice = "alto" \with \voiceAttrs "A" { \altoMus }
      >>
      \new Lyrics \lyricsto "alto" \altoLyrA
      \new Lyrics \with \italicVerse \lyricsto "alto" \altoLyrB
      \new Lyrics \lyricsto "alto" \altoLyrC
      \new Lyrics \with \italicVerse \lyricsto "alto" \altoLyrD
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenMus }
      >>
      \new Lyrics \lyricsto "ten" \tenLyrA
      \new Lyrics \with \italicVerse \lyricsto "ten" \tenLyrB
      \new Lyrics \lyricsto "ten" \tenLyrC
      \new Lyrics \with \italicVerse \lyricsto "ten" \tenLyrD
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basMus }
      >>
      \new Lyrics \lyricsto "bas" \basLyrA
      \new Lyrics \with \italicVerse \lyricsto "bas" \basLyrB
      \new Lyrics \lyricsto "bas" \basLyrC
      \new Lyrics \with \italicVerse \lyricsto "bas" \basLyrD
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
