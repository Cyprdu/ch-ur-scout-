\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 19)

\header {
  title = "Laissez-vous consumer"
  category = "EUCHARISTIE"
  number = "N° 21-07"
  poet = "Paroles et musique : Marc Dannaud"
  copyright = "© 2014, Éditions de l'Emmanuel"
}

mr = #(define-music-function (r) (ly:music?)
  #{ \once \override Rest.staff-position = #0 $r #})

global = {
  \key e \major
  \time 4/4
  \autoBeamOff
  \tempo 4 = 65
  \sectionLabel "REFRAIN"
  s1*6 \bar "||" \break
  \sectionLabel "COUPLETS"
  s1*5
  \time 2/4 s2 \bar "|."
}

sop = \fixed c' {
  b4 a gis fis8[ a] | gis4 e8[ e] cis'4 b8[ cis'] | a4 gis8[ a] fis2 |
  gis4 fis e dis8[ fis] | e4. e8 a[ b] gis[ a] | fis8[ fis] e[ dis] e2 |
  \mr r8 e[ dis e] fis4 gis8[ b] | a8[ e] e[ fis] gis4 gis |
  b8[ a] a[ gis] e4 fis8[ gis] | b8[ a] a[ gis] fis4 gis8[ a] |
  cis'8[ b] cis'4 b8[ a] gis[ a] | fis2
}

alto = \fixed c' {
  gis4 fis e fis8[ fis] | e4 e8[ e] e4 e8[ e] | e4 e8[ e] e4( dis) |
  b,4 b, b, b,8[ b,] | cis4. e8 e[ e] e[ e] | dis8[ dis] b,[ b,] b,2 |
  s8 b,[ b, b,] dis4 e8[ dis] | e8[ e] e[ e] e4 e |
  gis8[ fis] fis[ e] e4 e8[ e] | dis8[ cis] cis[ b,] cis4 fis8[ fis] |
  e8[ dis] e4 e8[ fis] e[ e] | dis2
}

tenor = \fixed c {
  b4 b b b8[ b] | cis'4 gis8[ gis] a4 b8[ b] | cis'4 b8[ cis'] cis'4( b) |
  b4 a gis fis8[ fis] | gis4. gis8 cis'[ b] a[ cis'] | b8[ b] gis[ fis] gis2 |
  r8 gis fis[ gis] b4 b8[ b] | cis'8[ cis'] b[ cis'] cis'4 cis' |
  b8[ b] b[ b] cis'4 cis'8[ cis'] | fis8[ fis] fis[ gis] a4 b8[ cis'] |
  a8[ a] a4 gis8[ a] b[ cis'] | b2
}

basse = \fixed c {
  e4 e dis dis8[ dis] | cis4 b,8[ b,] a,4 gis,8[ gis,] | fis,4 fis,8[ fis,] b,2 |
  e4 e dis dis8[ dis] | cis4 b,8[ b,] a,[ gis,] fis,[ fis,] | b,8[ b,] b,[ b,] e2 |
  e4 e8[ e] b,4 b,8[ b,] | a,8[ a,] a,[ a,] cis4 cis |
  gis,8[ gis,] gis,[ gis,] a,4 a,8[ a,] | b,8[ b,] b,[ b,] fis4 fis8[ fis] |
  a,8[ a,] a,4 e8[ e] e[ e] | b,2
}

accords = {
  \ch "Mi" 2 \ch "Si/Ré♯" 2 | \ch "Do♯m" 2 \ch "La" 2 | \ch "Fa♯m" 2 \ch "Si4" 4 \ch "Si" 4 |
  \ch "Mi" 2 \ch "Si/Ré♯" 2 | \ch "Do♯m" 2 \ch "La" 4 \ch "Fa♯m" 4 | \ch "Si" 2 \ch "Mi" 2 |
  \ch "Mi" 2 \ch "Si" 2 | \ch "La" 2 \ch "Do♯m" 2 |
  \ch "Mi/Sol♯" 2 \ch "La" 2 | \ch "Si" 2 \ch "Fa♯m" 2 | \ch "La" 2 \ch "Mi" 2 | \ch "Si" 2
}

refrainSkip = \repeat unfold 31 \skip 1

coupletA = \lyricmode {
  Lais -- sez vous con -- su -- mer par le feu de l'a -- mour de mon coeur.
  De -- puis l'au -- be des temps, je veux ha -- bi -- ter au creux de vos vies.
  \set stanza = "1."
  Je suis ve -- nu al -- lu -- mer un feu sur ter -- re,
  com -- me je vou -- drais qu'il soit dé -- jà al -- lu -- "mé !"
  Lais -- sez vous brû -- ler par ma Cha -- ri -- té.
}
coupletB = \lyricmode {
  \refrainSkip
  \set stanza = "2."
  Voy -- ez mon Cœur qui a tant ai -- mé les hom -- mes,
  et qui en re -- tour n'a re -- çu que du mé -- pris.
  Lais -- sez vous ai -- mer par mon cœur brû -- lant.
}
coupletC = \lyricmode {
  \refrainSkip
  \set stanza = "3."
  Pre -- nez mon Corps et bu -- vez à ce ca -- li -- ce.
  De -- puis si long -- temps, j'ai dé -- si -- ré ce mo -- ment.
  Lais -- sez -- moi ve -- nir de -- meu -- rer en vous.
}
coupletD = \lyricmode {
  \refrainSkip
  \set stanza = "4."
  N'é -- cou -- tez pas vo -- tre cœur qui vous con -- dam -- ne,
  mon a -- mour pour vous est plus grand que vos pé -- chés.
  Lais -- sez mon Es -- prit pu -- ri -- fier vos vies.
}
coupletE = \lyricmode {
  \refrainSkip
  \set stanza = "5."
  Ma Croix dres -- sée est un si -- gne pour le mon -- de.
  Voi -- ci l'é -- ten -- dard, il con -- duit vers le sa -- lut.
  Lais -- sez vous gui -- der vers la sain -- te -- "té !"
}
coupletF = \lyricmode {
  \refrainSkip
  \set stanza = "6."
  Je suis ve -- nu pour vous don -- ner la Vic -- toi -- re,
  j'ai vain -- cu la Mort. Ay -- ez foi, ne crai -- gnez pas,
  e -- xul -- tez de joie pour l'é -- ter -- ni -- "té !"
}

\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff <<
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
      \new Staff <<
        \global \clef bass
        \new Voice = "ten" \with \voiceAttrs "T" { \voiceOne \tenor }
        \new Voice = "bas" \with \voiceAttrs "B" { \voiceTwo \basse }
      >>
    >>
  >>
  \layout { \chorusLayout }
}
