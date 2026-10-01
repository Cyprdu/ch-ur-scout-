\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 19)

\header {
  title = "En toi, ma confiance"
  category = "MÉDITATION ET CONFIANCE"
  number = "N° 18-07"
  poet = "Paroles (d'après le Ps 13) et musique : Chants de l'Emmanuel (J.-F. Léost)"
  copyright = "© 2009, Éditions de l'Emmanuel, 37 rue de l'Abbé Grégoire, 75006 Paris"
}

global = {
  \key d \minor
  \time 4/4
  \tempo 4 = 98
  \sectionLabel "COUPLETS"
  \partial 8 s8 | s1*3 | s2. \bar "!" \break s4 | s1*3 |
  s2. \bar "||" \break
  \sectionLabel "REFRAIN"
  s4 | s1*3 | s2. s4 \break | s1*2 |
  \once \omit Staff.TimeSignature \time 3/4 s2. \bar "||"
  \once \omit Staff.TimeSignature \time 4/4 s1 \bar "|."
}

sop = \fixed c' {
  a,8 | d4 d8[ d] d[ d] e[ f] | bes2. bes8[ a] | g4 g8[ g] g[ g] f[ e] | d2. d8[ c] |
  d4 d8[ d] d[ d] e[ f] | c4 c r8 c[ f g] | a4 a8[ a] a[ f] f[ g] | g2. d4 |
  bes2~ bes8[ a] g[ f] | e2. d8[ e] | f2( g) | a2. d4 |
  bes2~ bes8[ a] g[ f] | e2~ e8[ e] f[ e] | d2. | d1^\markup \small \italic "(pour le dernier refrain)" |
}

alto = \fixed c' {
  a,8 | a,4 a,8[ a,] d[ d] c[ d] | f2. f8[ f] | d4 d8[ d] d[ d] d[ bes,] | a,2. a,8[ a,] |
  bes,4 bes,8[ bes,] bes,[ bes,] bes,[ bes,] | c4 c r8 c[ c f] | f4 f8[ f] f[ f] d[ d] | e2. d4 |
  d2~ d8[ d] d[ d] | cis2. cis8[ cis] | d2( c) | c2. c4 |
  d2~ d8[ f] f[ d] | cis2~ cis8[ cis] d[ a,] | a,2. | a,1 |
}

tenor = \fixed c {
  f8 | f4 f8[ f] a[ a] a[ c'] | d'2. d'8[ bes] | bes4 bes8[ bes] bes[ bes] a[ g] | f2. f8[ f] |
  f4 f8[ f] bes[ bes] bes[ bes] | a4 a r8 a[ a a] | a4 a8[ c'] d'[ d'] d'[ d'] | c'2. a4 |
  bes2~ bes8[ bes] bes[ bes] | a2. a8[ g] | a2( c') | c'2. a4 |
  bes2~ bes8[ bes] bes[ a] | g2~ g8[ a] a[ g] | f2. | fis1 |
}

basse = \fixed c {
  d8 | d4 d8[ d] f[ f] e[ d] | bes,2. bes,8[ d] | d4 d8[ d] g[ g] g,[ bes,] | d2. d8[ d] |
  bes,4 bes,8[ bes,] g,[ g,] c[ c] | f4 f r8 f[ c c] | d4 d8[ d] bes,[ bes,] bes,[ c] | c2. a,4 |
  g,2~ g,8[ g,] g,[ a,] | a,2. a,8[ a,] | d2( e) | f2. f4 |
  f2~ f8[ f] bes,[ bes,] | a,2~ a,8[ a,] b,[ cis] | d2. | d1 |
}

accords = {
  \partial 8 s8 | \ch "Rém" 1 | \ch "Sib" 1 | \ch "Solm" 1 | \ch "Rém" 1 |
  \ch "Sib" 2 \ch "Solm" 4 \ch "Do7" 4 | \ch "Fa" 1 | \ch "Rém" 2 \ch "Sib7" 2 | \ch "Do" 2. \ch "Rém" 4 |
  \ch "Solm" 1 | \ch "La" 1 | \ch "Rém" 2 \ch "Do/Mi" 2 | \ch "Fa" 1 |
  \ch "Sib" 1 | \ch "La7" 1 | \ch "Rém" 2. | \ch "Ré" 1 |
}

coupletA = \lyricmode {
  \set stanza = "1."
  Sei -- gneur, m'ou -- blie -- ras -- tu pour tou -- "jours ?" Jus -- qu'à
  quand me ca -- che -- ras -- tu ta "face ?"
  Vois mon âme est en -- va -- hie de ré -- vol -- te,
  et jour et nuit le cha -- grin em -- plit mon coeur.
  En toi, __ j'ai mis, Sei -- gneur, __ ma con -- fian -- ce.
  Ne me __ dé -- lais -- ses pas, __ Dieu de ma joie. joie.
}
coupletB = \lyricmode {
  \set stanza = "2."
  Mon Dieu, po -- se ton re -- gard sur moi. Ré -- ponds --
  moi, il -- lu -- mi -- ne mon vi -- sage.
  Dans la mort, que je ne m'en -- dor -- me pas, __ _
  et que le mal ne l'em -- por -- te pas sur moi.
}
coupletC = \lyricmode {
  \set stanza = "3."
  Pour moi, j'ai con -- fiance en ton a -- mour. Et j'e --
  xulte ô Sei -- gneur car tu me sauves.
  Je te loue pour le bien que tu m'as fait, __ _
  et pour ton Nom je chan -- te -- rai à ja -- "mais !"
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
