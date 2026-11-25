\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "La Nativité"
  subtitle = "3e mystère joyeux"
  poet = "Texte : Pauline Riobée"
  composer = "Musique : Jacques Montagne"
  copyright = "Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key c \major
  \time 6/8
  \tempo 4 = 90
  \sectionLabel "Tutti"
  s2.*7 \break s2.*5 \bar "||" \break
  \key g \major \sectionLabel "Couplet 1" s2.*7 \break s2.*5 \bar "||" \break
  \key d \major \sectionLabel "Couplet 2" s2.*7 \break s2.*5 \bar "||" \break
  \key a \major \sectionLabel "Couplet 3" s2.*7 \break s2.*5 \bar "||" \break
  \sectionLabel "Adagio" s2.*8 \break s2.*8 \bar "|."
}

sopMus = {
  g'4 e'8 g'4 e'8 | f'4. f' | g'8 g' e' g'4 e'8 | c''2. | g'4 e'8 g'4 e'8 | f'4. e'8 e' e' | e'4 e'8 d'4. |
  r4. e'8( f') g' | g'4 g'8 g' a' g' | f'4 f'8 e'4 d'8 | a'4. d'4 c'8 | d'2. |
  g'2.^\markup \italic "B.F."\( | a' | g' | g' | g' | e'4.\) g'8 g' g' | g'4 g'8 fis'4. |
  r4. b'8( c'') d'' | d''4 d''8 d'' e'' d'' | c''4 c''8 b'4 a'8 | e''4. a'4 g'8 | a'2. |
  a'4 fis'8 a'4 fis'8 | g'2. | a'8 a' fis' a'4 fis'8 | d''2. | a'4 fis'8 a'4 fis'8 | g'4. fis'8 fis' fis' | d'4 d'8 cis'4. |
  r4. fis'8( g') a' | a'4 a'8 a' b' a' | g'4 g'8 fis'4 e'8 | b'4. e'4 d'8 | e'2. |
  a'2.^\markup \italic "B.F."\( | b' | a' | a' | a' | fis'4.\) a'8 a' a' | a'4 a'8 gis'4. |
  r4. cis''8( d'') e'' | e''4 e''8 e'' fis'' e'' | d''4 d''8 cis''4 b'8 | fis''4. b'4 a'8 | b'2. |
  b'4. cis''4 cis''8 | cis''4. cis''4 cis''8 | b'4.~ b'4 b'8 | b'4 b'8 cis''4 b'8 | a'( b') cis''4. cis''8 | cis''4 cis''8 e''4 e''8 | d''4 d''8 d''4 d''8 | cis''4. cis'' |
  cis''4 cis''8 <cis'' fis''>4 <cis'' fis''>8 | <cis'' e''>4 <cis'' e''>8 <cis'' d''>4.\fermata | fis''4. e'' | e''2. | d'' | a' | a'~ | a' |
}

altoMus = {
  g'4 e'8 g'4 e'8 | f'4. f' | g'8 g' e' g'4 e'8 | c''2. | g'4 e'8 g'4 e'8 | f'4. e'8 e' e' | e'4 e'8 d'4. |
  r4. e'8( f') g' | g'4 g'8 g' a' g' | f'4 f'8 e'4 d'8 | a'4. d'4 c'8 | d'2. |
  d'2.^\markup \italic "B.F."\( | e' | d' | c' | d' | c'4.\) d'8 d' d' | d'4 d'8 d'4. |
  r4. g'8( a') b' | b'4 b'8 b' c'' b' | g'4 e'8 fis'4 fis'8 | a'4. g'4 g'8 | g'4.( fis') |
  fis'4 d'8 fis'4 d'8 | b2. | fis'8 fis' d' fis'4 d'8 | b'2. | fis'4 d'8 fis'4 d'8 | e'4. d'8 d' d' | a4 a8 a4. |
  r4. d'8( e') fis' | fis'4 fis'8 fis' g' fis' | d'4 b8 cis'4 cis'8 | e'4. d'4 d'8 | d'4.( cis') |
  e'2.^\markup \italic "B.F."\( | fis' | e' | d' | e' | fis'4.\) e'8 e' e' | e'4 e'8 e'4. |
  r4. a'8( b') cis'' | cis''4 cis''8 cis'' d'' cis'' | a'4 fis'8 gis'4 gis'8 | b'4. a'4 a'8 | a'4.( gis') |
  gis'4. a'4 a'8 | a'4. a'4 a'8 | a'4.( gis'4) gis'8 | gis'4 gis'8 gis'4 gis'8 | fis'( gis') a'4. a'8 | a'4 a'8 ais'4 ais'8 | b'4 b'8 b'4 b'8 | b'4. b' |
  b'4 b'8 ais'4 ais'8 | b'4 g'8 fis' e'8.( a'16) | g'4. a'8( e') fis' | <fis' gis'>4.( <e' gis'>) | fis'2. | fis' | e'~ | e' |
}

tenMus = {
  g4 e8 g4 e8 | f4. f | g8 g e g4 e8 | c'2. | g4 e8 g4 e8 | f4. e8 e e | e4 e8 d4. |
  r4. c'8~ c' c' | b4 bes8 bes bes bes | a4 a8 gis4 g8 | fis4. g4 g8 | g2. |
  d'8 d' b d'4 b8 | c'2. | d'8 d' b d'4 b8 | g2. | d'8 d' b d'4 b8 | c'4. b8 b b | b4 b8 a4. |
  r4. d'8( c') b | d'4 b8 d' c' b | c'4 g8 a4 a8 | a4. a4 d'8 | d'2. |
  d'2.^\markup \italic "B.F."\( | e' | d' | d' | d' | b4.\) a8 a a | fis4 fis8 e4. |
  r4. a8( g) fis | a4 fis8 a g fis | g4 d8 e4 e8 | e4. e4 a8 | a2. |
  e'8 e' cis' e'4 cis'8 | d'2. | e'8 e' cis' e' e' cis' | a2. | e'8 e' cis' e'4 cis'8 | d'4. cis'8 cis' cis' | cis'4 cis'8 b4. |
  r4. e'8( d') cis' | e'4 cis'8 e' d' cis' | d'4 a8 b4 b8 | b4. b4 e'8 | e'2. |
  e'4. e'4 e'8 | e'4. e'4 e'8 | e'4.~ e'4 e'8 | d'4 d'8 d'4 d'8 | cis'4 fis'4. fis'8 | fis'4 fis'8 e'4 e'8 | e'4 e'8 e'4 d'8 | e'4. e' |
  e'4 e'8 fis'4 fis'8 | cis'4 cis'8 d'4 cis'8 | b4 b8 cis'4. | e'2. | d' | d' | cis'~ | cis' |
}

basMus = {
  g4 e8 g4 e8 | f4. f | g8 g e g4 e8 | c'2. | g4 e8 g4 e8 | f4. e8 e e | e4 e8 d4. |
  r4. c'8~ c' c' | b4 bes8 bes bes bes | a4 a8 gis4 g8 | fis4. g4 g8 | g2. |
  b8 b g b4 g8 | e2. | b8 b g b4 g8 | e2. | b8 b g b4 g8 | a4. g8 g g | g4 g8 d4. |
  r4. g4 g8 | fis4 f8 f f f | e4 e8 dis4 d8 | cis4. d4 d8 | d2. |
  a2.^\markup \italic "B.F."\( | b | a | g | a | b4.\) d8 d d | d4 d8 a,4. |
  r4. d4 d8 | cis4 c8 c c c | b,4 b,8 ais,4 a,8 | gis,4. a,4 a,8 | a,2. |
  cis'8 cis' a cis'4 a8 | fis2. | cis'8 cis' a cis' cis' a | fis2. | cis'8 cis' a cis'4 a8 | b4. a8 a a | a4 a8 e4. |
  r4. a4 a8 | gis4 g8 g g g | fis4 fis8 eis4 e8 | dis4. e4 e8 | e2. |
  e4. e4 e8 | e4. e4 e8 | e4.~ e4 e8 | f4 f8 f4 f8 | fis4 fis4. fis8 | fis4 fis8 fisis4 fisis8 | gis4 gis8 gis4 gis8 | a4. a |
  a4 a8 ais4 ais8 | b4 b8 b4 a8 | g4 g8 a4. | b2. | a | d | a,~ | a, |
}

sopLyrA = \lyricmode {
  \unset stanza La nuit tom -- be tom -- be sur le pe -- tit trou -- peau dors (dors) dors (dors) dors en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur 
  \repeat unfold 6 \skip 1
  \unset stanza que Dieu nous a don -- né gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur il est là il dort son vi -- sage est si beau dors (dors) dors (dors) dors en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur 
  \repeat unfold 6 \skip 1
  \unset stanza un sau -- veur nous est né gran -- de joie Ô bon -- ne nou -- vel -- le c’est le Christ le Sei -- gneur En -- trer ve -- nez l’a -- do -- rer __ il est le roi des an -- ges il est lu -- miè -- re né de la lu -- miè -- re il est Dieu né du vrai Dieu a -- do -- rez a -- do -- rez
}

altoLyrA = \lyricmode {
  \unset stanza La nuit tom -- be tom -- be sur le pe -- tit trou -- peau dors (dors) dors (dors) dors en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur 
  \repeat unfold 6 \skip 1
  \unset stanza que Dieu nous a don -- né gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur il est là il dort son vi -- sage est si beau dors (dors) dors (dors) dors en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur 
  \repeat unfold 6 \skip 1
  \unset stanza un sau -- veur nous est né gran -- de joie Ô bon -- ne nou -- vel -- le c’est le Christ le Sei -- gneur En -- trer ve -- nez l’a -- do -- rer __ il est le roi des an -- ges il est lu -- miè -- re né de la lu -- miè -- re il est Dieu né du vrai Dieu en -- trez ad -- do -- rez a -- do -- rez
}

tenLyrA = \lyricmode {
  \unset stanza La nuit tom -- be tom -- be sur le pe -- tit trou -- peau dors (dors) dors (dors) dors en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur al -- lons à Beth -- lé -- em pour voir le nou -- veau né Quel est ce doux en -- fant que Dieu nous a don -- né gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur 
  \repeat unfold 6 \skip 1
  \unset stanza en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur al -- lons au -- tour de nous ra -- con -- ter l’é -- vé -- ne -- ment Gran -- de joie sur la terre un sau -- veur nous est né gran -- de joie Ô bon -- ne nou -- vel -- le c’est le Christ le Sei -- gneur En -- trer ve -- nez l’a -- do -- rer __ il est le roi des an -- ges il est lu -- miè -- re né de la lu -- miè -- re il est Dieu né du vrai Dieu en -- trez a -- do -- rez a -- do -- rez
}

basLyrA = \lyricmode {
  \unset stanza La nuit tom -- be tom -- be sur le pe -- tit trou -- peau dors (dors) dors (dors) dors en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur al -- lons à Beth -- lé -- em pour voir le nou -- veau né Quel est ce doux en -- fant que Dieu nous a don -- né gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur 
  \repeat unfold 6 \skip 1
  \unset stanza en cet -- te dou -- ce nuit gran -- de joie Ô bon -- ne nou -- vel -- le il est né le sau -- veur al -- lons au -- tour de nous ra -- con -- ter l’é -- vé -- ne -- ment Gran -- de joie sur la terre un sau -- veur nous est né gran -- de joie Ô bon -- ne nou -- vel -- le c’est le Christ le Sei -- gneur En -- trer ve -- nez l’a -- do -- rer __ il est le roi des an -- ges il est lu -- miè -- re né de la lu -- miè -- re il est Dieu né du vrai Dieu en -- trez a -- do -- rez a -- do -- rez
}

accords = \chordmode {
  \ch "Do" 2. | \ch "Rém" 2. | \ch "Do" 2. | \ch "Fa" 2. | \ch "Do" 2. | \ch "Ré" 4. \ch "Do" 4. | s4. \ch "Sol" 4. | s2.*5 |
  \ch "Sol" 2. | \ch "Lam" 2. | \ch "Sol" 2. | \ch "Do" 2. | \ch "Sol" 2. | \ch "Lam" 4. \ch "Sol" 4. | s4. \ch "Ré" 4. |
  s4. \ch "Sol" 4. | \ch "Sim/Fa♯" 4 \ch "Sidim/Fa" 2 | \ch "Do" 4. \ch "Si7" 4 \ch "Ré" 8 | \ch "La" 4. \ch "Ré4" 4. | s4. \ch "Ré" 4. |
  \ch "Ré" 2. | \ch "Mim" 2. | \ch "Ré" 2. | \ch "Sol" 2. | \ch "Ré" 2. | \ch "Mim" 4. \ch "Ré" 4. | s4. \ch "La" 4. |
  s4. \ch "Ré" 4. | \ch "Fa♯m/Do♯" 4 \ch "Fa♯dim/Do" 2 | \ch "Sol" 4. \ch "Fa♯7" 4 \ch "La" 8 | \ch "Mi" 4. \ch "La4" 4. | s4. \ch "La" 4. |
  \ch "La" 2. | \ch "Sim" 2. | \ch "La" 2. | \ch "Ré" 2. | \ch "La" 2. | \ch "Sim" 4. \ch "La" 4. | s4. \ch "Mi" 4. |
  s4. \ch "La" 4. | \ch "Do♯m/Sol♯" 4 \ch "Do♯dim/Sol" 2 | \ch "Ré" 4. \ch "Do♯7" 4 \ch "Mi" 8 | \ch "Si" 4. \ch "Mi4" 4. | s4. \ch "Mi" 4. |
  \ch "Mi" 4. \ch "La/Mi" 4. | s2. | \ch "Mi4" 4. \ch "Mi" 4. | \ch "Sol♯7/Fa" 2. | \ch "Fa♯" 2. | s4. \ch "Fa×dim7" 4. | \ch "Mi7/Sol♯" 2. | \ch "La9" 2. |
  s4. \ch "Fa♯/La♯" 4. | \ch "Do♯7" 4. \ch "Sim9" 4. | \ch "Sol7" 4. \ch "La" 4. | \ch "Mi9" 2. | \ch "Ré/La" 2. | \ch "Ré" 2. | \ch "La" 2. | s2. |
}

\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global 
        \new Voice = "sop" \with \voiceAttrs "S" { \sopMus }
      >>
      \new Lyrics \lyricsto "sop" \sopLyrA
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global 
        \new Voice = "alto" \with \voiceAttrs "A" { \altoMus }
      >>
      \new Lyrics \lyricsto "alto" \altoLyrA
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenMus }
      >>
      \new Lyrics \lyricsto "ten" \tenLyrA
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basMus }
      >>
      \new Lyrics \lyricsto "bas" \basLyrA
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
