\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 18.5)

% Transcrit d'après « Fais-Moi Renaître.pdf » (photo, mélodie et accords).
% Partition seule : ce chant n'est pas publié sur le site (absent de chants.json).

\header {
  title = "Fais-moi renaître"
  poet = "Paroles : Sr Marie-Liesse Bigot, inspirées de Gn 2, 7 – Jn 3, 6 – Qohélet 11, 5"
  composer = "Musique : Sr Marie-Liesse Bigot"
  copyright = "© 2019, Béatitudes Productions, 41600 Nouan-le-Fuzelier (BP-0228) — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key a \minor
  \time 2/4
  \tempo 4 = 76-80
}

melodie = {
  \partial 4 e'8 f' |
  \repeat volta 2 {
    e'4. e'8 | f'4. e'8 | d'4 g'8 f' | e'4. f'8 |
    e'4. e'8 | f'4. e'8 | d'4 g'8 f' | e'2~ | \break
    e'8 e' e' g' | a'4.( g'8) | g'4 d'8 g' | e'2 |
    e'8 e' e' g' | f'4 f' | d' e' | e'2~ | \break
    e'8 e' e' g' | a'4.( g'8) | g'4 d'8 g' | e'2 |
    e'8 e' e' g' | f'4 f' | d' e' |
  }
  \alternative { { e'2~ | e'4 e'8 f' | } { e'2~ | e'4 r4 | } } \break
  \bar "||"
  a'8 g' f' e' | f'4. a'8 | g'4 b'8 g' | e'4. a'8 |
  a'8 g' f' e' | f'4 f'8 a' | b'4 b'8 g' | e'4 e' | \break
  r4 e'8 g' | a'4 b' | c''4. b'8 | b'4 c''8 b' | a'2~ | a'2 \bar "||"
  r4 e'8 f' | \break
  \repeat volta 2 {
    e'4 e'8 e' | f'4 e'8 e' | d'8 d' g' f' | e'4 r8 f' |
    e'4 e'8 e' | f'4 e'8 e' | d'8 d' g' f' | e'2 | \break
    r4 e'8 g' | a'4. g'8 | g'4 d'8 g' | e'2 |
    e'8 e' e' g' | f'4 f' | d' e' | e'2 | \break
    r4 e'8 g' | a'4. g'8 | g'4 d'8 g' | e'2 |
    e'8 e' e' g' | f'4 f' | d' e' |
  }
  \alternative { { e'2~ | e'4 e'8 f' | } { e'2~ | e'4 r4 | } }
  \bar "|."
}

grille = { \ch "Am" 2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 | s2 | \ch "F" 2 | \ch "G" 2 | }
accords = {
  \partial 4 s4 |
  \repeat volta 2 {
    \grille \ch "Am" 2 | s2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 |
    s2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 | s2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 |
    s2 | \ch "F" 2 | \ch "G" 2 |
  }
  \alternative { { \ch "Am" 2 | s2 | } { \ch "Am" 2 | s2 | } }
  \ch "Am" 2 | \ch "Dm" 2 | \ch "G" 2 | \ch "Am" 2 | s2 | \ch "Dm" 2 | \ch "G" 2 | \ch "Am" 2 |
  s2 | \ch "(Am)" 4 \ch "G" 4 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 | s2 | s2 |
  \repeat volta 2 {
    \grille \ch "Am" 2 | s2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 |
    s2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 | s2 | \ch "F" 2 | \ch "G" 2 | \ch "Am" 2 |
    s2 | \ch "F" 2 | \ch "G" 2 |
  }
  \alternative { { \ch "Am" 2 | s2 | } { \ch "Am" 2 | s2 | } }
}

paroles = \lyricmode {
  Ô Sei -- gneur, fais -- moi re -- naî -- tre d’en haut,
  Sei -- gneur, fais -- moi re -- naî -- tre d’en haut. __
  Que je con -- tem -- ple ton Roy -- au -- me,
  que je con -- tem -- ple ta beau -- té. __
  Que je con -- tem -- ple ton Roy -- au -- me,
  que je con -- tem -- ple ta beau -- té. __ Ô Sei -- té. __

  Je ne con -- nais pas la voie de l’Es -- prit,
  la main qui m’a for -- mé dans le sein de ma mè -- re,
  mais tu m’as don -- né ton souf -- fle de vie. __

  Ô Sei -- gneur, fais -- moi naî -- tre de l’eau et de l’Es -- prit.
  Sei -- gneur, fais -- moi naî -- tre de l’eau et de l’Es -- prit,
  et que j’en -- tre dans ton Roy -- au -- me,
  que je con -- tem -- ple ta beau -- té,
  et que j’en -- tre dans ton Roy -- au -- me,
  que je con -- tem -- ple ta beau -- té. __ Ô Sei -- té. __
}

\score {
  <<
    \new ChordNames \accords
    \new Staff << \global \new Voice = "mel" { \melodie } >>
    \new Lyrics \lyricsto "mel" \paroles
  >>
  \layout {
    \chorusLayout
    \context {
      \Score
      \remove "Bar_number_engraver"
      % uniquement les fins de lignes choisies (\break), à la fin des phrases
      \override NonMusicalPaperColumn.line-break-permission = ##f
    }
  }
}

\paper { system-system-spacing.basic-distance = #19 }
