\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

\header {
  title = "Le lion"
  subtitle = "pour chœur SATB a cappella"
  poet = "Paroles et musique : Tanguy Dionis du Séjour"
  arranger = "Arrangement : J.-C. Rosaz"
  copyright = "© Terra Lontana Publishers"
}

\include "lion_music.ily"

global = {
  \key f \major
  \time 4/4
  \tempo 4 = 76
  \set Score.melismaBusyProperties = #'()
}

lyrSetup = { \set melismaBusyProperties = #'() }

\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff = "solo" \with {
        instrumentName = "Solo" shortInstrumentName = "Sol."
        \RemoveAllEmptyStaves
      } <<
        \global
        \new Voice = "solo" \with \voiceAttrs "Solo" { \soloMusic }
      >>
      \new Lyrics \lyricsto "solo" { \lyrSetup \soloLyrA }
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \sopMusic }
      >>
      \new Lyrics \lyricsto "sop" { \lyrSetup \sopLyrA }
      \new Lyrics \lyricsto "sop" { \lyrSetup \sopLyrB }
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global
        \new Voice = "alto" \with \voiceAttrs "A" { \altoMusic }
      >>
      \new Lyrics \lyricsto "alto" { \lyrSetup \altoLyrA }
      \new Lyrics \lyricsto "alto" { \lyrSetup \altoLyrB }
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenorMusic }
      >>
      \new Lyrics \lyricsto "ten" { \lyrSetup \tenorLyrA }
      \new Lyrics \lyricsto "ten" { \lyrSetup \tenorLyrB }
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basseMusic }
      >>
      \new Lyrics \lyricsto "bas" { \lyrSetup \basseLyrA }
      \new Lyrics \lyricsto "bas" { \lyrSetup \basseLyrB }
    >>
  >>
  \layout {
    \chorusLayout
    indent = 14\mm
    short-indent = 6\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
