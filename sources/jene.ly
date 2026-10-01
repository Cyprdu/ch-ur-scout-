\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 19)

\header {
  title = "Je ne t'ai point cherché en vain, ô mon Seigneur"
  poet = "Paroles : fr. David Perrin, op"
  composer = "Musique : fr. Clément Binachon, op"
  copyright = \markup \center-column {
    "Couplet 2 d'après Sg 7, 7 · Couplet 4 d'après saint Augustin, Confessions, X, 27, 38"
    "Couplet 5 d'après saint Augustin, Confessions, III, 6, 11"
  }
}

global = {
  \key fis \minor
  \tempo "Adagio" 4 = 65
  \time 5/4 s4*5 | s4*5 | \break
  s4*5 | \time 6/4 s4*6 | \pageBreak
  \time 5/4 s4*5 | s4*5 | \break
  s4*5 | \time 6/4 s4*6 \bar "|."
}

sop = \fixed c' {
  a4 fis8[ cis] gis[ e] fis4 fis8[( gis]) | a8[ b] cis'4 cis' b2 |
  b4 a8[ gis] fis[ gis] a2 | fis4 gis8[ a] gis4 gis fis2 |
  a4 fis8[ cis] gis[ e] fis4 \slurDashed fis8[( gis]) | a8[( b]) \slurSolid cis'4 cis' b2 |
  d'4 b8[ fis] cis'[ a] b2^\markup \italic "rit." | fis4 \slurDashed gis8[( a]) \slurSolid fis4 e fis2\fermata |
}

alto = \fixed c' {
  fis4 cis8[ cis] e[ e] d4 d8[( e]) | cis8[ e] e4 e8[( fis]) gis2 |
  fis4 fis8[ cis] d[ e] fis4( cis) | d4 d8[ d] d4 cis cis2 |
  fis4 cis8[ cis] e[ e] d4 \slurDashed d8[( e]) | cis8[( e]) \slurSolid e4 e8[( fis]) gis2 |
  fis4 fis8[ d] fis[ e] e2 | d4 \slurDashed d8[( d]) \slurSolid cis4 cis cis2\fermata |
}

tenor = \fixed c {
  cis'4 a8[ a] gis[ cis'] a4 a8[( cis']) | a8[ gis] a4 a gis2 |
  b4 cis'8[ cis'] d'[ b] cis'2 | a4 gis8[ fis] b4 b a2 |
  cis'4 a8[ a] gis[ cis'] a4 \slurDashed a8[( cis']) | a8[( gis]) \slurSolid a4 a gis2 |
  b4 b8[ b] a[ cis'16( b)] a4( gis) | a4 \slurDashed fis8[( b]) \slurSolid gis4 gis a2\fermata |
}

basse = \fixed c {
  fis4 fis8[ fis] cis[ cis] d4 d8[( cis]) | fis8[ e] a,[ b,] cis[ d] e2 |
  d4 fis8[ e] a[ gis] fis4( e) | d8[( cis]) b,[ d] fis4 eis fis2 |
  fis4 fis8[ fis] cis[ cis] d4 \slurDashed d8[( cis]) | fis8[( e]) \slurSolid a,[ b,] cis[ d] e2 |
  b,8[( cis]) d[ b,] fis16[( e]) a,8 e2 | d8[( cis]) \slurDashed b,[( b,]) \slurSolid cis4 cis <fis, fis>2\fermata |
}

accords = {
  \ch "Fa♯m" 2 \ch "Do♯m" 4 \ch "Ré" 4 \ch "(Do♯m)" 4 | \ch "Fa♯m" 8 \ch "(Mi)" 8 \ch "La" 2 \ch "Mi" 2 |
  \ch "Sim(ré)" 4 \ch "Fa♯m" 8 \ch "(Do♯m)" 8 \ch "Ré(la)" 8 \ch "Mi(sol♯)" 8 \ch "Fa♯m" 4 \ch "La(mi)" 4 |
  \ch "Ré" 4 \ch "Sol♯dim" 4 \ch "Sol♯dim(fa♯)" 4 \ch "Do♯7" 4 \ch "Fa♯m" 2 |
  \ch "Fa♯m" 2 \ch "Do♯m" 4 \ch "Ré" 4 \ch "(Do♯m)" 4 | \ch "Fa♯m" 8 \ch "(Mi)" 8 \ch "La" 2 \ch "Mi" 2 |
  \ch "Sim" 2 \ch "Fa♯m" 8 \ch "(La)" 8 \ch "Mi4–3" 2 |
  \ch "Ré" 4 \ch "Sol♯dim" 4 \ch "Do♯4–Do♯m" 2 \ch "Fa♯m" 2 |
}

sing = { \set ignoreMelismata = ##t }
unsing = { \unset ignoreMelismata }

coupletA = \lyricmode {
  \set stanza = "1."
  Je ne t'ai point cher -- ché en __ vain ô mon Sei -- gneur
  Aux ap -- pels de mon cœur tu t'es lais -- sé trou -- ver.
  \set stanza = "1."
  Tu es la sour -- ce viv(e) où __ \sing boit ton \unsing ser -- vi -- teur,
  le fleu -- ve qui em -- porte mon âm(e) __ as -- soif -- fée.
}
coupletB = \lyricmode {
  \set stanza = "2."
  Jour et nuit, j'ai pri -- é et __ tu m'as vi -- si -- té.
  Tu fis des -- cendr(e) en moi ton Es -- prit de Sa -- gesse.
  \set stanza = "2."
  Aux scep -- tres et aux trôn(es) je __ t'ai __ pré -- fé -- ré
  et j'ai te -- nu pour rien \sing les biens et \unsing les ri -- chesses.
}
coupletC = \lyricmode {
  \set stanza = "3."
  Je me suis a -- bri -- té tout __ con -- tre toi, Jé -- sus.
  Sur ton coeur, ô mon Dieu, ma têt(e) a re -- po -- sé.
  \set stanza = "3."
  Et ta voix me di -- sait_: "« A" -- \sing dam, où \unsing é -- tais -- "tu ?"
  Par -- tout je t'ai cher -- ché, \sing pour -- quoi as -- tu \unsing tar -- "dé ? »"
}
coupletD = \lyricmode {
  \set stanza = "4."
  Ô beau -- té si an -- cienn(e), ô __ beau -- té si nou -- velle,
  bien tard je t'ai ai -- mée et t'ai don -- né ma vie.
  \set stanza = "4."
  Au de -- hors de moi -- mêm(e) je __ t'ai __ pour -- sui -- vie
  mais tu é -- tais en moi, \sing Vé -- ri -- té \unsing é -- ter -- "nelle !"
}
coupletE = \lyricmode {
  \set stanza = "5."
  Plus in -- té -- rieur à moi que __ moi -- mêm(e) ô Sei -- gneur,
  je te dé -- couvr(e) en -- fin_: pré -- senc(e) où je m'ou -- blie.
  \set stanza = "5."
  Hô -- te très doux de l'âm(e) sceau __ brû -- lant du cœur
  Je te rends gloir(e) ô Père, Fils et __ Saint Es -- prit.
}

\score {
  <<
    \new ChordNames \accords
    \new PianoStaff <<
      \new Staff <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \voiceOne \sop }
        \new Voice = "alto" \with \voiceAttrs "A" { \voiceTwo \alto }
      >>
      \new Lyrics \lyricsto "sop" \coupletA
      \new Lyrics \lyricsto "sop" \coupletB
      \new Lyrics \lyricsto "sop" \coupletC
      \new Lyrics \lyricsto "sop" \coupletD
      \new Lyrics \lyricsto "sop" \coupletE
      \new Staff <<
        \global \clef bass
        \new Voice = "ten" \with \voiceAttrs "T" { \voiceOne \tenor }
        \new Voice = "bas" \with \voiceAttrs "B" { \voiceTwo \basse }
      >>
    >>
  >>
  \layout {
    \chorusLayout
    \context { \Score \override NonMusicalPaperColumn.line-break-permission = ##f }
  }
}
