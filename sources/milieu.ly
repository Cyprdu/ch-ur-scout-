\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "Il est au milieu de nous"
  composer = "Paroles et musique : Thibault Fromant"
  copyright = "Ad Dei Gloriam — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key g \major
  \time 4/4
  \tempo 4 = 120
  \sectionLabel "REFRAIN"
  s1*4 \break s1*5 \bar "||" \break
  \sectionLabel "COUPLETS" s1*4 \break s1*4 \break s1*4 \break s1*4
  \mark \markup \small \italic "puis refrain (m. 2)" s1 \bar "|."
}

sopMus = {
  r4 e'8 e' b' a' g' a' | b'4 e' g' b' | c'' e'8 e' c'' b' a' g' | a'4 d' fis' a' |
  b' fis'8 fis' b' a' g' a' | g'4 e' fis' g' | a' fis'8 fis' a' a' g' a' | b'1~ | b' |
  r8 g' g' fis' g'2 | r8 g' g' fis' g'2 | r8 g' g' g' fis'4 fis' | fis' e' fis'2 |
  r8 b' b' a' b'2 | r8 b' b' a' b'2 | r8 b' b' b' a'4 a' | a' b' a'2 |
  r8 g' g' fis' g'2 | r8 g' g' fis' g'2 | r8 g' g' g' fis'4 fis' | fis' g' a'2 |
  r8 b' b' a' b'2~ | b'8 b' b' a' b'2~ | b'8 g' g' a' b'4 b' | b' c'' b'2~ |
  b'4 e'8 e' b' a' g' a' |
}

altoMus = {
  r4 e'8 e' g' fis' e' fis' | g'4 b e' g' | a' c'8 c' a' g' fis' e' | fis'4 d' d' fis' |
  fis'2 fis' | e'4 e' e' e' | e' e'8 e' e' e' e' e' | fis'1~ | fis' |
  r8 g' fis' e' e'2 | r8 g' fis' e' e'2 | r8 e' e' e' d'4 d' | d' d' d'2 |
  r8 b' a' a' g'2 | r8 b' a' a' g'2 | r8 g' g' g' fis'4 fis' | fis' g' fis'2 |
  r8 g' fis' e' e'2 | r8 g' fis' e' e'2 | r8 e' e' e' d'4 d' | d' e' fis'2 |
  r8 b' a' a' a'4( g' | g'8) b' a' a' g'4( fis' | e'8) g' g' g' g'4 g' | g' g' fis'2~ |
  fis'4 e'8 e' g' fis' e' fis' |
}

tenMus = {
  r4 b8 b b b b b | b4 g b b | a a8 b c' d' e' e' | d'4 b d' d' |
  dis'2 dis' | e'4 d' d' c' | a b8 b c' d' e' e' | e'1( | dis') |
  r8 b b b b2 | r8 b b b b2 | r8 e fis g a4 a | fis b a2 |
  r8 d' d' d' d'2 | r8 d' d' d' d'2 | r8 g a b d'4 d' | a a a2 |
  r8 b b b b2 | r8 b b b b2 | r8 e fis g a4 a | b b a2 |
  r8 d' d' d' d'2~ | d'8 d' d' d' d'2~ | d'8 g g g g4 g | c' e' e'2( |
  dis'4) b8 b b b b b |
}

basMus = {
  r2 e4 e | e e e e | c a, d a, | d g fis d |
  b, b, dis b, | c c c c | c a,8 a, a, a, c c | b,1~ | b, |
  r8 e e e e2 | r8 e e e e2 | r8 c c b, d4 b, | a, b, d2 |
  r8 g g g g2 | r8 g g g g2 | r8 e e d d4 d | d d d2 |
  r8 e e e e2 | r8 e e e e2 | r8 c c b, d4 b, | b, b, d2 |
  r8 g g g g2~ | g8 g g g g2~ | g8 e e e c4 c | a, a, b,2~ |
  b,4 r e e |
}

sopLyrA = \lyricmode {
  \unset stanza Il est pré -- sent par -- mi nous puis -- qu’Il nous aime, Il s’est sa -- cri -- fié pour nous, res -- su -- ci -- té, Il nous ré -- vè -- le Sa vie par Son Bap -- tême. Il est au mi -- lieu de nous. 
  \set stanza = "1." Bap -- ti -- sé par Saint Jean -- Bap -- tiste, Il in -- vite à la con -- ver -- sion. Par ce bap -- tême, Jé -- sus, le Christ, nous mon -- tre qu’Il est a -- vec nous. Ce bap -- tême d’eau, vient an -- non -- cer l’heure de la Croix où par a -- mour, Il fran -- chi -- ra, l’eau de la mort pour nous faire vi -- vre pour tou -- jours.
  \unset stanza Il est pré -- sent par -- mi
}

sopLyrB = \lyricmode {
  \repeat unfold 40 \skip 1
  \set stanza = "2." Par le Bap -- tême d’Eau et d’Es -- prit, Il nous fait tra -- ver -- ser les eaux. Par ce bap -- tême, nous de -- ve -- nons en -- fants de Dieu, par Son Es -- prit. Il veut nous faire par -- ti -- ci -- per au mys -- tè -- re de Sa Pas -- sion. Il veut nous faire par -- ti -- ci -- per à Sa sain -- te Ré -- sur -- rec -- tion.
}

sopLyrC = \lyricmode {
  \repeat unfold 40 \skip 1
  \set stanza = "3." Lors du Re -- pas, Il ins -- ti -- tue, le mys -- tère de l’Eu -- cha -- ris -- tie. Il fit ce -- la, pour que ma foi puisse tou -- jours s’a -- breu -- ver de Lui. Mort sur la Croix, pour nous sau -- ver, en por -- tant nos nom -- breux pé -- chés, Lui qui est roi, Il nous ra -- chète, Il est vrai -- ment res -- su -- sci -- té.
}

altoLyrA = \lyricmode {
  \unset stanza Il est pré -- sent par -- mi nous puis -- qu’Il nous aime, Il s’est sa -- cri -- fié pour nous, Dieu res -- su -- sci -- té! Oui, par Son Bap -- tême, Il est au mi -- lieu de nous. 
  \set stanza = "1." Bap -- ti -- sé par Saint Jean -- Bap -- tiste, Il in -- vite à la con -- ver -- sion. Par ce bap -- tême, Jé -- sus, le Christ, nous mon -- tre qu’Il est a -- vec nous. Ce bap -- tême d’eau, vient an -- non -- cer l’heure de la Croix où par a -- mour, Il fran -- chi -- ra, l’eau de la mort pour nous faire vi -- vre pour tou -- jours.
  \unset stanza Il est pré -- sent par -- mi
}

altoLyrB = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "2." Par le Bap -- tême d’Eau et d’Es -- prit, Il nous fait tra -- ver -- ser les eaux. Par ce bap -- tême, nous de -- ve -- nons en -- fants de Dieu, par Son Es -- prit. Il veut nous faire par -- ti -- ci -- per au mys -- tè -- re de Sa Pas -- sion. Il veut nous faire par -- ti -- ci -- per à Sa sain -- te Ré -- sur -- rec -- tion.
}

altoLyrC = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "3." Lors du Re -- pas, Il ins -- ti -- tue, le mys -- tère de l’Eu -- cha -- ris -- tie. Il fit ce -- la, pour que ma foi puisse tou -- jours s’a -- breu -- ver de Lui. Mort sur la Croix, pour nous sau -- ver, en por -- tant nos nom -- breux pé -- chés, Lui qui est roi, Il nous ra -- chète, Il est vrai -- ment res -- su -- sci -- té.
}

tenLyrA = \lyricmode {
  \unset stanza Il est pré -- sent par -- mi nous puis -- qu’Il nous aime, Il s’est sa -- cri -- fié pour nous, Dieu res -- su -- sci -- té! Oui, par Son Bap -- tême, Il est au mi -- lieu de nous. 
  \set stanza = "1." Bap -- ti -- sé par Saint Jean -- Bap -- tiste, Il in -- vite à la con -- ver -- sion. Par ce bap -- tême, Jé -- sus, le Christ, nous mon -- tre qu’Il est a -- vec nous. Ce bap -- tême d’eau, vient an -- non -- cer l’heure de la Croix où par a -- mour, Il fran -- chi -- ra, l’eau de la mort pour nous faire vi -- vre pour tou -- jours.
  \unset stanza Il est pré -- sent par -- mi
}

tenLyrB = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "2." Par le Bap -- tême d’Eau et d’Es -- prit, Il nous fait tra -- ver -- ser les eaux. Par ce bap -- tême, nous de -- ve -- nons en -- fants de Dieu, par Son Es -- prit. Il veut nous faire par -- ti -- ci -- per au mys -- tè -- re de Sa Pas -- sion. Il veut nous faire par -- ti -- ci -- per à Sa sain -- te Ré -- sur -- rec -- tion.
}

tenLyrC = \lyricmode {
  \repeat unfold 35 \skip 1
  \set stanza = "3." Lors du Re -- pas, Il ins -- ti -- tue, le mys -- tère de l’Eu -- cha -- ris -- tie. Il fit ce -- la, pour que ma foi puisse tou -- jours s’a -- breu -- ver de Lui. Mort sur la Croix, pour nous sau -- ver, en por -- tant nos nom -- breux pé -- chés, Lui qui est roi, Il nous ra -- chète, Il est vrai -- ment res -- su -- sci -- té.
}

basLyrA = \lyricmode {
  \unset stanza Il est pré -- sent par -- mi nous, Il s’est sa -- cri -- fié pour nous, res -- su -- sci -- té! Oui, par Son Bap -- tême, Il est au mi -- lieu de nous. 
  \set stanza = "1." Bap -- ti -- sé par Saint Jean -- Bap -- tiste, Il in -- vite à la con -- ver -- sion. Par ce bap -- tême, Jé -- sus, le Christ, nous mon -- tre qu’Il est a -- vec nous. Ce bap -- tême d’eau, vient an -- non -- cer l’heure de la Croix où par a -- mour, Il fran -- chi -- ra, l’eau de la mort pour nous faire vi -- vre pour tou -- jours.
  \unset stanza Il est
}

basLyrB = \lyricmode {
  \repeat unfold 30 \skip 1
  \set stanza = "2." Par le Bap -- tême d’Eau et d’Es -- prit, Il nous fait tra -- ver -- ser les eaux. Par ce bap -- tême, nous de -- ve -- nons en -- fants de Dieu, par Son Es -- prit. Il veut nous faire par -- ti -- ci -- per au mys -- tè -- re de Sa Pas -- sion. Il veut nous faire par -- ti -- ci -- per à Sa sain -- te Ré -- sur -- rec -- tion.
}

basLyrC = \lyricmode {
  \repeat unfold 30 \skip 1
  \set stanza = "3." Lors du Re -- pas, Il ins -- ti -- tue, le mys -- tère de l’Eu -- cha -- ris -- tie. Il fit ce -- la, pour que ma foi puisse tou -- jours s’a -- breu -- ver de Lui. Mort sur la Croix, pour nous sau -- ver, en por -- tant nos nom -- breux pé -- chés, Lui qui est roi, Il nous ra -- chète, Il est vrai -- ment res -- su -- sci -- té.
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
