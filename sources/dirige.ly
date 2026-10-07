\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

% Transcrit d'après « Dirige-moi par Ta vérité - ADG.pdf » (MuseScore, Ad Dei Gloriam).
% Les liaisons qui ne valent que pour certains couplets (ex. « ra-ble » / « pas. »)
% sont notées en notes séparées : les couplets qui tiennent la syllabe la prolongent.
% Les ténors n'ont pas de texte propre de « té » (m. 20) à « C'est » (m. 24), comme l'original.

\header {
  title = "Dirige-moi par Ta vérité"
  poet = "Texte : d'après le Psaume 24"
  composer = "Musique : Thibault Fromant"
  copyright = "Ad Dei Gloriam — Tous droits réservés · Chorale Scouts de Lyon"
}

global = {
  \key es \major
  \time 4/4
  \tempo 4 = 102
  \sectionLabel "COUPLETS"
  \partial 8 s8 | s1*7 \break s1*8 |
  s2. \bar "||" \sectionLabel "REFRAIN" s4 | s1*8 \break s1*8 \bar "|."
}

% ---------------------------------------------------------------- Soprano
sop = {
  \parenthesize es'8 |
  g'4. f'8 g'4 as' | g'2. f'8 es' | f'2 f'4 g'8 g' | f'2. f'4 |
  as'4. as'8 as'4 bes' | c''2. bes'8 as' | bes'2. bes'4 | bes'2. bes'4 |
  g'4. f'8 g'4 as' | g'2. f'8 es' | f'2. g'4 | f'2. f'4 |
  as'4. g'8 as'4 bes' | c''2. bes'8 as' | bes'2 bes'4 c'' |
  % refrain
  d''2. c''4 | es''2. es''4 | d''2. bes'4 | c''4. bes'4. as'4 |
  bes'2. c''4 | es''2. es''4 | d''2. bes'4 | as'4. as'4. c''4 | bes'2. c''4 |
  es''2 es''4 es'' | d''2. bes'4 | c''4.( bes'4.) as'4 | bes'2. f'8 g' |
  as'2. g'4 | as'4 g' as' bes' | bes'1~ | bes'1 |
}

% ---------------------------------------------------------------- Alto
alto = {
  \parenthesize es'8 |
  es'4. f'8 es'4 f' | es'2. c'8 c' | d'2 d'4 es'8 es' | d'2. d'4 |
  f'4. f'8 as'4 as' | as'2. d'8 es' | f'2. f'4 | f'2. f'4 |
  es'4. f'8 es'4 f' | es'2. c'8 c' | d'2. es'4 | d'2. d'4 |
  f'4. f'8 as'4 as' | as'2. d'8 es' | f'2 f'4 f' |
  % refrain
  f'2. c''4 | c''2. c''4 | bes'2. bes'4 | as'4. as'4. as'4 |
  g'2. c''4 | c''2. c''4 | bes'2. g'4 | as'4. as'4. g'4 | f'2. c''4 |
  c''2 c''4 c'' | bes'2. bes'4 | as'2. as'4 | g'2. f'8 es' |
  es'2. es'4 | f'4 f' f' f' | f'1~ | f'1 |
}

% ---------------------------------------------------------------- Ténor
tenor = {
  \parenthesize bes8 |
  bes4. as8 bes4 bes | bes2. as8 g | bes2 as4 g8 g | bes2( as4) g |
  c'4. c'8 c'4 c' | c'2. c'8 c' | d'2. es'4 | d'2. d'4 |
  bes4. as8 bes4 bes | bes2. as8 g | bes2( as4) g | bes2( as4) g |
  c'4. c'8 c'4 c' | c'2. c'8 c' | d'2 d'4 d' |
  % refrain
  bes2. g4 | g2. g4 | bes4 bes bes d' | c'4. es'4. es'4 |
  es'2( d'4) bes | g2. g4 | bes2. bes4 | c'4. d'4. es'4 | d'2. g4 |
  g2. g4 | bes4 bes bes d' | c'4. es'4. es'4 | es'2( d'4) d'8 d' |
  c'2. c'4 | as4 as c' es' | d'1~ | d'1 |
}

% ---------------------------------------------------------------- Basse
basse = {
  \parenthesize es8 |
  es4. es8 es4 es | es2. es8 es | bes,2 bes,4 bes,8 bes, | bes,2. bes,4 |
  f4. f8 f4 f | f2. f8 es | d2. c4 | bes,2. bes,4 |
  es4. es8 es4 es | es2. es8 es | bes,2. bes,4 | bes,2. bes,4 |
  f4. f8 f4 f | f2. f8 es | d2 d4 c |
  % refrain
  bes,2. es4 | c2. c4 | g2. g4 | as4. as4. as4 |
  es4 es es d | c2. c4 | g2. g4 | f4. f4. as,4 | bes,4 d8 es f4 es |
  c2 c4 c | g2. g4 | as2. as4 | es4 es es c8 c |
  as,2. as,4 | f4 f f f | bes,1~ | bes,1 |
}

% ---------------------------------------------------------------- Paroles
cplA = \lyricmode {
  \set stanza = "1."
  Re -- gar -- _ de Sei -- gneur, et prends pi -- tié de __ _ moi, __ _
  de moi qui suis seul et __ _ mi -- sé -- ra -- ble.
  Vois __ _ ma mi -- sère et __ _ vois ma pei -- ne,
  en __ _ lè -- ve tous mes nom -- breux __ _ pé -- chés.
}
cplB = \lyricmode {
  \set stanza = "2."
  Ou -- blie les ré -- voltes, les pé -- chés de ma jeu -- nes -- se,
  dans __ _ Ton a -- mour, ne __ _ m'ou -- blie pas. __ _
  J'ai les yeux tour -- nés vers __ _ le Sei -- gneur, __ _
  il __ _ ti -- re -- ra mes pieds du __ _ fi -- let.
}
cplC = \lyricmode {
  \set stanza = "3."
  Est -- _ il un hom -- me qui crai -- _ gne __ _ "Dieu ?" __ _
  Le Sei -- gneur lui mon -- tre le vrai che -- min. __ _
  Son __ _ âme ha -- bi -- te -- ra le bon -- heur, __ _
  ses __ _ des -- cen -- dants pos -- sé -- de -- ront la terre.
}
refHaut = \lyricmode {
  Di -- ri -- ge -- moi, par Ta vé -- ri -- té,
  En -- sei -- gne -- moi car Tu es mon Dieu.
  C'est Toi que j'es -- pè -- re tout le jour,
  en rai -- son de Ta bon -- té Sei -- gneur.
}
refTenor = \lyricmode {
  Di -- ri -- ge, di -- ri -- ge par Ta vé -- ri -- té. __ _
  \repeat unfold 8 \skip 1
  C'est Toi c'est Toi que j'es -- pè -- re tout le jour,
  en rai -- son de Ta bon -- té Sei -- gneur.
}
refBasse = \lyricmode {
  Di -- ri -- ge -- moi, par Ta vé -- ri -- té, Ta vé -- ri -- té.
  Car Tu es le Dieu d'a -- mour qui me sauve.
  C'est Toi que j'es -- pè -- re tout le jour, c'est Toi,
  en rai -- son de Ta bon -- té Sei -- gneur.
}

sopLyr = \lyricmode { \cplA \refHaut }
tenorLyr = \lyricmode { \cplA \refTenor }
basseLyr = \lyricmode { \cplA \refBasse }
% couplets 2 et 3 : sans la levée (notée entre parenthèses, chantée au 1er couplet)
coupletDeux = \lyricmode { \skip 1 \cplB }
coupletTrois = \lyricmode { \skip 1 \cplC }

% ---------------------------------------------------------------- Partition
\score {
  <<
    \new ChoirStaff <<
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \sop }
      >>
      \new Lyrics \lyricsto "sop" \sopLyr
      \new Lyrics \with \italicVerse \lyricsto "sop" \coupletDeux
      \new Lyrics \lyricsto "sop" \coupletTrois
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global
        \new Voice = "alto" \with \voiceAttrs "A" { \alto }
      >>
      \new Lyrics \lyricsto "alto" \sopLyr
      \new Lyrics \with \italicVerse \lyricsto "alto" \coupletDeux
      \new Lyrics \lyricsto "alto" \coupletTrois
      \new Staff \with { instrumentName = "Ténor" shortInstrumentName = "T" } <<
        \global \clef "treble_8"
        \new Voice = "ten" \with \voiceAttrs "T" { \tenor }
      >>
      \new Lyrics \lyricsto "ten" \tenorLyr
      \new Lyrics \with \italicVerse \lyricsto "ten" \coupletDeux
      \new Lyrics \lyricsto "ten" \coupletTrois
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basse }
      >>
      \new Lyrics \lyricsto "bas" \basseLyr
      \new Lyrics \with \italicVerse \lyricsto "bas" \coupletDeux
      \new Lyrics \lyricsto "bas" \coupletTrois
    >>
  >>
  \layout {
    \chorusLayout
    indent = 16\mm
    short-indent = 7\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
