\version "2.24.4"
\include "chorale.ily"
#(set-global-staff-size 17)

% Transcrit d'après partitions/LE_LION.pdf (Terra Lontana Publishers).
% Les notes entre parenthèses ne sont chantées que sur l'un des deux couplets.

\header {
  title = "Le lion"
  subtitle = "pour chœur SATB a cappella"
  poet = "Paroles et musique : Tanguy Dionis du Séjour"
  arranger = "Arrangement : J.-C. Rosaz"
  copyright = "© Terra Lontana Publishers"
}

global = {
  \key f \major
  \time 4/4
  \tempo 4 = 100
  \set Score.melismaBusyProperties = #'(tieMelismaBusy)
}

op = #(define-music-function (m) (ly:music?) #{ \parenthesize $m #})

% ---------------------------------------------------------------- Solo
solo = {
  R1*10
  \repeat volta 2 {
    R1*13
    r2 r4 e'8 e' |                          % 24
    c''2. r4 |
    r4 d'( a') a' |
    b'4( c''8 b' d''4) g'' |
    f''4.( e''8) f''2 |                     % 28
    r4 e''~( e''8 d'') e''4 |
    es''4( c'') c'' c'' |
    d''4 b' b'2 |
  }
  \alternative {
    { r4 a'8 a' a'4 r4 | }                  % 32
    { r4 a'8 a' a'4 r4 | }                  % 33
  }
  R1*17
  r2 r4 e'8 e' |                            % 51
  c''2. r4 |
  r4 d'( a') a' |
  b'4( c''8 b' d''4) g'' |
  f''4.( e''8) f''2 |                       % 55
  r4 e''~( e''8 d'') e''4 |
  es''4( c'') c'' c'' |
  d''4 b' b'2 |
  r4 c'' aes' r4 |                          % 59
  r4 b' g' r4 |
  r4 g'8 g' g'4 r4 |
  r4 a'8 a' a'4 b' |
  a'1 \bar "|."
}

soloLyr = \lyricmode {
  dans les cieux In _ ex -- cel _ _ _ -- sis
  De _ -- o De _ -- o Le _ ser -- vi -- teur su -- prême
  vé -- ri -- table vé -- ri -- table
  dans les cieux In _ ex -- cel _ _ _ -- sis
  De _ -- o De _ -- o Le _ ser -- vi -- teur su -- prême
  su -- prême su -- prême vé -- ri -- table vé -- ri -- table a -- mour
}

% ---------------------------------------------------------------- Soprano
sop = {
  R1*8
  d'1( |                                    % 9
  e'2 f'2)\fermata |
  \repeat volta 2 {
    r8 d' e' f' e' d'16 d' e'8 f' |         % 11
    e'8 d' e' f' e' d' e' f' |
    e'8 d' e' f' e' d' d' f' |
    f'2 e' |
    r8 d' g' a' a' g' a' bes' |             % 15
    bes'8 es' g' a' a' g' a' bes' |
    bes'8 es' g' a' bes' g' g' bes' |
    \slurDashed bes'2( a') \slurSolid |
    r8 bes' c'' des'' des'' bes'16 \op bes' c''8 des'' |   % 19
    des''8 bes' c'' des'' des'' bes'16 bes' c''8 des'' |
    des''8 bes' c'' des'' des'' bes' bes' bes' |
    c''2 r |
    r8 b' ais' b' c'' b' a' g' |            % 23
    g'2 r |
    r8 c'' b' c'' d'' c'' b' a' |
    a'4 a'( d') a' |
    g'2 b' |
    r4 g'8 g' b'4 g'8 g' |                  % 28
    c''4 c''8 c'' g'4 c'' |
    g'4 g' a' g' |
    g'4 g' g'2 |
  }
  \alternative {
    { r4 fis'8 fis' fis'4 r4 | }            % 32
    { r4 fis'8 fis' fis'4 r4 | }            % 33
  }
  r8 d' e' f' a'4 d''8( c''~ |              % 34
  c''8 bes'4) a'8 a' g' f' g' |
  bes'4( a' g') f'8 f' |
  f'2 e' |
  r8 g' g' a' a' bes' bes' g' |
  g'2 g'4 r8 g' |                           % 39
  g'8 a' a' bes'~ bes' r g' bes' |
  a'2 r |
  r8 bes'16 bes' bes'8 bes' des'' bes' c'' des''~ |
  des''8 bes' bes' bes' des'' bes' c'' des''~ |   % 43
  des''8 bes'16 bes' bes'8 bes' des'' bes' bes' des'' |
  c''2~ c''4 r |
  r8 bes'16 bes' bes'8 bes' des'' bes' c'' des''~ |   % 46
  des''8 bes' bes' bes' des'' bes' c'' des''~ |
  des''8 bes'16 bes' bes'8 bes' des'' bes' bes' bes' |
  c''1 |                                    % 49
  r8 b' ais' b' c'' b' a' g' |
  g'2 r |
  r8 c'' b' c'' d'' c'' b' a' |
  a'4 a'( d') a' |                          % 53
  g'2 b' |
  r4 g'8 g' b'4 g'8 g' |
  c''4 c''8 c'' g'4 c'' |
  g'4 g' a' g' |
  g'4 g' g'2 |
  r4 f' f' r |                              % 59
  r4 g' d' r |
  r4 g'8 g' g'4 r |
  r4 e'8 e' e'4 e' |
  fis'1 \bar "|."
}

sopLyrA = \lyricmode {
  Vienne __ _ _
  Com -- me la terre tour -- née vers le
  ciel es -- père la pluie et le so --
  leil mon â -- me vers Lui se re --
  dres -- "se," Je vois la mys -- té -- rieu -- se
  croix où est clou -- é un nou -- veau
  Ciel que re -- co -- nnaît sou -- dain mon
  âme __ _
  Je vois le sang comme __ _ u -- ne
  pluie qui ré -- u -- nit le Ciel à la
  terre Je vois ce coeur le grand se -- cret
  Le lion s'est fait si faible a -- gneau
  Les anges ac -- cla -- ment le grand "roi," In _ ex -- cel -- sis
  Le plus fort au ser -- vi -- ce des plus pe -- "tits," Le ser -- vi -- teur su -- prême
  vé -- ri -- table vé -- ri -- table
  Der -- rière la nuit brille __ _ _
  le lion au coeur d'a -- gneau __ _ _ qui m'es -- pè -- "re."
  Der -- rière les va -- ni -- tés du mon -- de
  Der -- rière les faux ciels les faux lions
  Il est in -- vi -- sible et pour -- tant
  A -- vec puis -- sance il s'é -- "lance," vers le coeur as -- soif -- fé d'être ai -- "mé,"
  Son ru -- gis -- se -- ment fait le -- ver
  l'au -- "rore," les "blés," les en -- "fants," Les mon -- ta -- gnes dan -- sent de -- vant
  lui
  Le lion s'est fait si faible a -- gneau
  Les anges ac -- cla -- ment le grand "roi," In _ ex -- cel -- sis
  Le plus fort au ser -- vi -- ce des plus pe -- "tits," Le ser -- vi -- teur su -- prême
  su -- prême su -- prême vé -- ri -- table vé -- ri -- table a -- mour
}

sopLyrB = \lyricmode {
  \repeat unfold 3 \skip 1
  L'ob -- scu -- ri -- té tout au -- tour se
  "fait," Mes en -- ne -- mis m'ont en -- cer --
  clé Nul -- le sor -- tie nul -- le lu --
  miè -- "re." Je vois la mys -- té -- rieu -- se
  croix où est clou -- é un nou -- veau
  Ciel Mes en -- ne -- mis fré -- missent et
  ra -- "gent."
  Qui s'a -- baisse _ se -- ra é -- le --
  "vé," qui s'ou -- blie _ se -- ra ex -- al --
  "té," Oui qui se donne au -- ra la vie
}

% ---------------------------------------------------------------- Alto
alto = {
  R1*6
  d'1( |                                    % 7
  e'2 f'4) f' |
  d'1~ |
  d'1\fermata |
  \repeat volta 2 {
    r8 d' d' d' d' d'16 d' d'8 d' |         % 11
    d'8 d' d' d' d' d' d' d' |
    d'8 d' d' d' d' d' d' d' |
    c'2 c' |
    r8 d' d' d' d' d' d' d' |               % 15
    g'8 es' es' es' es' es' es' es' |
    g'8 es' es' es' es' es' es' es' |
    f'2 \op f'8 f' f' \op f' |
    f'2~ f'8 \op f'16 \op f' f'8 f' |       % 19
    ges'2 f'4 ges' |
    \slurDashed bes'4( ges') \slurSolid f' bes'8 \op bes' |
    a'2 a'4 a' |
    b'2. r4 |                               % 23
    r8 g' fis' g' a' g' fis' e' |
    e'4 e' a' e' |
    fis'8 fis' eis' fis' g' a' g' fis' |
    g'1 |
    r2 r4 b8 b |                            % 28
    c'4 c'8 c' e'4 g' |
    g'1 |
    R1 |
  }
  \alternative {
    { R1 | }
    { R1 | }
  }
  r2 r8 f' g' a' |                          % 34
  a'8( g'4 d'8) d'2 |
  d'2 d'4 d'8 d' |
  d'2 c' |
  r8 d' d' d' d' d' d'4 |
  r8 g' g' g' g' f' f' es' |                % 39
  es'4 r r g'8 g' |
  f'2 r |
  r8 f'16 f' f'8 f' f' f' f' f'~ |
  f'8 ges' ges' ges' ges' ges' ges' ges'~ |   % 43
  ges'8 ges'16 ges' ges'8 ges' ges' ges' ges' bes' |
  f'2~ f'4 r |
  r8 f'16 f' f'8 f' f' f' f' f'~ |          % 46
  f'8 ges' ges' ges' ges' ges' ges' ges'~ |
  ges'8 ges'16 ges' ges'8 ges' ges' ges' bes' bes' |
  a'2 a'4 a' |                              % 49
  b'2. r4 |
  r8 g' fis' g' a' g' fis' e' |
  e'4 e' a' e' |
  fis'8 fis' eis' fis' g' a' g' fis' |      % 53
  g'1 |
  r2 r4 b8 b |
  c'4 c'8 c' e'4 g' |
  g'1 |
  r4 g' d' g' |
  aes'2. aes'4 |                            % 59
  g'4 d'~ d' g' |
  es'2. d'4 |
  cis'2. cis'4 |
  d'1 \bar "|."
}

altoLyrA = \lyricmode {
  Vienne __ _ _ la pluie
  Com -- me la terre tour -- née vers le
  ciel es -- père la pluie et le so --
  leil mon â -- me vers Lui se re --
  dres -- "se," Je vois la mys -- té -- rieu -- se
  croix où est clou -- é un nou -- veau
  Ciel que re -- co -- nnaît sou -- dain mon
  âme __ _ Je vois le
  sang __ _ _ u -- ne
  pluie à la "terre," le grand se -- _ "cret." Il est lion
  Rien n'est plus "fou," mais dans les cieux Les anges ac --
  clament il a ou -- vert la voie du ciel
  au ser -- vi -- ce des plus pe -- tits
  Der -- rière la nuit __ _ _ brille
  l'a -- gneau qui m'es -- pè -- "re."
  Der -- rière les va -- ni -- tés
  Der -- rière les va -- ni -- tés der -- rière les faux lions
  Il est in -- vi -- sible et pour -- tant
  A -- vec puis -- sance il s'é -- "lance," vers le coeur as -- soif -- fé d'être ai -- "mé,"
  Son ru -- gis -- se -- ment fait le -- ver
  l'au -- "rore," les "blés," les en -- "fants," Les mon -- ta -- gnes dan -- sent de -- vant
  lui Il est lion
  Rien n'est plus "fou," mais dans les cieux Les anges ac --
  clament il a ou -- vert la voie du ciel
  au ser -- vi -- ce des plus pe -- tits
  Le ser -- vi -- teur su -- prê -- me __ le vé -- ri -- table a -- mour
}

altoLyrB = \lyricmode {
  \repeat unfold 5 \skip 1
  L'ob -- scu -- ri -- té tout au -- tour se
  "fait," Mes en -- ne -- mis m'ont en -- cer --
  clé Nul -- le sor -- tie nul -- le lu --
  miè -- "re." Je vois la mys -- té -- rieu -- se
  croix où est clou -- é un nou -- veau
  Ciel Mes en -- ne -- mis fré -- missent et
  ragent Qui __ _ s'a -- _
  baisse __ se -- ra é -- le --
  vé e -- xal -- té __ _ au -- ra la vie
}

% ---------------------------------------------------------------- Ténor
% (mesures 3 à 10 : divisi)
tenorII = \new Voice {
  \voiceTwo e1 | e1 | e1 | e1 | f1 | f1 | f1 | f1 |
}

tenor = {
  d1( |
  e1) |
  << {
    \voiceOne
    a1 |                                    % 3
    bes4( a g f |
    a1) |
    bes4( a g f |
    a2.) c'4 |                              % 7
    bes4 a g f |
    a1 |
    bes4( a2.)\fermata |
  } \tenorII >>
  \oneVoice
  \repeat volta 2 {
    a2~ a4~ a8 a |                          % 11
    a2( g4) f8 f |
    bes2~ bes4 bes8 a |
    g2 g |
    bes1 |                                  % 15
    c'4( bes2) bes8 bes |
    c'4( bes8 a g2) |
    r4 f c' des'8( c') |
    bes2~ bes8 des'16 \op des' des'8 des' | % 19
    es'8 es' des' des' des' des'16 des' des'8 des' |
    \slurDashed es'8( es') \slurSolid des' des' des' des' des' c'16( bes) |
    c'2 c'8( d') d'4 |
    d'2~ d'8 d' d' d' |                     % 23
    b4 b g b |
    a4 a a c' |
    d'4 d'( a) d' |
    d'2 d' |
    r4 d'8 d' d'4 d'8 d' |                  % 28
    g4 g r2 |
    r4 es' es' es' |
    d'4 d' d'2 |
  }
  \alternative {
    { r4 d'8 d' d'4 a | }                   % 32
    { r4 d'8 d' d'4 r | }                   % 33
  }
  a1( |                                     % 34
  d'2 bes) |
  d'4( c') bes bes8 a |
  g2 g |
  r8 bes bes a a g g bes |
  bes8( a4 g8) g4 r8 g |                    % 39
  c'8 c' c' g~ g r c' c' |
  c'2 bes8 bes a a |
  des'2. bes8 bes |
  bes2. bes8 bes |                          % 43
  es'4. bes8 bes bes bes bes |
  a8 f' f' es' es' des' des' c' |
  des'2. bes8 bes |                         % 46
  bes2. bes8 bes |
  es'2 bes8 bes bes bes |
  c'2 c'8( d') d'4 |                        % 49
  d'2~ d'8 d' d' d' |
  b4 b g b |
  a4 a a c' |
  d'4 d'( a) d' |                           % 53
  d'2 d' |
  r4 d'8 d' d'4 d'8 d' |
  g4 g r2 |
  r4 es' es' es' |
  d'4 d' d'2 |
  r4 es' c' r |                             % 59
  r4 d' b r |
  r4 c'8 c' c'4 r |
  r4 e8 e a4 g |
  a1 \bar "|."
}

tenorLyrA = \lyricmode {
  O _ Vienne Vienne __ _ _ _ _ Vienne __ _ _ _ _ la
  pluie et le so -- leil Vienne __ _
  Ô __ le Ciel __ _ le so --
  leil __ se re -- dres -- "se,"
  Ô croix __ _ nou -- veau
  Ciel __ _ _ _
  Je vois le __ _ sang __ comme _ u -- ne
  pluie qui ré -- u -- nit le ciel à la
  terre __ _ Je __ _ vois le grand se -- _ "cret." Il __ _ est
  lion __ Le lion s'est
  fait si faible a -- gneau Les anges ac -- clament In _ ex -- cel -- sis
  Le plus fort au ser -- vi -- ce
  Le ser -- vi -- teur su -- prême
  vé -- ri -- table a vé -- ri -- table
  A __ _ _ l'a __ _ gneau qui m'es -- pè -- "re."
  Der -- rière les va -- ni -- tés du mon __ _ _ -- de
  Der -- rière les faux ciels les faux lions
  Il est in -- vi -- sible et pour -- tant il s'é --
  "lance," as -- soif -- fé d'être ai -- "mé," il pous -- se son ru -- gis -- se --
  ment fait le -- ver les en -- fants dan -- sent de -- vant
  "lui." Il __ _ est lion __ Le lion s'est
  fait si faible a -- gneau Les anges ac -- clament In _ ex -- cel -- sis
  Le plus fort au ser -- vi -- ce
  Le ser -- vi -- teur su -- prême
  su -- prême su -- prême vé -- ri -- table vé -- ri -- table a -- mour
}

tenorLyrB = \lyricmode {
  \repeat unfold 21 \skip 1
  mour __ _ _ _ En -- cer --
  clé __ sans lu -- miè -- "re."
  \repeat unfold 9 \skip 1
  _ Qui s'a -- _
  baisse __ se -- ra é -- le --
  "vé," qui s'ou -- blie _ se -- ra ex -- al --
  "té," Oui qui se donne au -- ra la __ _ vie
}

% ---------------------------------------------------------------- Basse
basse = {
  \repeat unfold 9 { d1~ | }
  d1\fermata |
  \repeat volta 2 {
    d2~ d4~ d8 d |                          % 11
    bes,2~ bes,4 bes,8 bes, |
    g,2~ g,4 g,8 g, |
    c2 c |
    g2.( f4) |                              % 15
    es2. es8 d |
    c1 |
    r4 f f f8( es) |
    des2~ des8 \op des16 \op des des8 des | % 19
    ges2~ ges8 \op ges16 \op ges ges8 f |
    es2~ es8 es f ges |
    f2 f4 fis8( d) |
    g2~ g8 g fis fis |                      % 23
    e4 g b g |
    a4 a g fis8( e) |
    d1 |
    r4 g8 g g4 f8( e) |
    d8( c b, a,) g,4 b,8 b, |               % 28
    c4 e8 e g4 c |
    c4 c c c |
    b,4 g, g,2 |
  }
  \alternative {
    { r2 r4 a,4 | }                         % 32
    { R1 | }                                % 33
  }
  r2 r8 d e f |                             % 34
  bes4( f) d( bes,) |
  g2 g4 g8 g |
  c2 c |
  g,2( d |
  es1) |                                    % 39
  c2( es |
  f2) f8 f f f |
  bes2. aes8 aes |
  ges2. f8 f |                              % 43
  es4. es8 es es es es |
  f8 f a f c' f es f |
  bes2. aes8 aes |                          % 46
  ges2. f8 f |
  es2 es8 es f ges |
  f2 f4 fis8( d) |                          % 49
  g2~ g8 g fis fis |
  e4 g b g |
  a4 a g fis8( e) |
  d1 |                                      % 53
  r4 g8 g g4 f8( e) |
  d8( c b, a,) g,4 b,8 b, |
  c4 e8 e g4 c |
  c4 c c c |
  b,4 d g2 |
  r4 f f r |                                % 59
  r4 f g r |
  r4 c8 c c4 r |
  r4 a,8 a, a,4 a, |
  d1 \bar "|."
}

basseLyrA = \lyricmode {
  O
  Ô __ le Ciel __ le so -- leil __ se re -- dres -- "se,"
  Ô __ _ croix nou -- veau Ciel
  Je vois le __ _ sang __ _ _ u -- ne
  pluie __ _ _ à la terre __ le grand se -- "cret." Il est __ _
  lion __ Le lion s'est
  fait si faible a -- gneau Les anges ac -- _ clament
  In ex -- cel -- sis _
  De __ _ _ _ -- o au ser -- vi -- ce des plus pe -- tits Le ser -- vi -- teur su -- prême
  a
  Der -- rière la nuit __ _ brille __ _
  l'a -- gneau qui m'es -- pè -- "re."
  Der -- _ rière Der -- _ rière
  Il est in -- vi -- sible et pour -- tant il s'é --
  "lance," as -- soif -- fé d'être ai -- "mé," il pous -- se son ru -- gis -- se --
  ment fait le -- ver les en -- fants dan -- sent de -- vant
  "lui." Il est __ _ lion __ Le lion s'est
  fait si faible a -- gneau Les anges ac -- _ clament
  In ex -- cel -- sis _
  De __ _ _ _ -- o au ser -- vi -- ce des plus pe -- tits Le ser -- vi -- teur su -- prême
  su -- prême su -- prême vé -- ri -- table vé -- ri -- table a -- mour
}

basseLyrB = \lyricmode {
  \skip 1
  mour __ _ _ En -- cer --
  clé __ sans lu -- miè -- "re."
  \repeat unfold 6 \skip 1
  _ Qui s'a -- _
  baisse __ se -- ra é -- le --
  "vé," __ se -- ra ex -- al --
  "té," __ au -- ra la vie
}

% ---------------------------------------------------------------- Accords
accords = {
  s1*10
  \ch "Dm" 1 \ch "B♭" 1 \ch "Gm" 1 \ch "C" 1 \ch "Gm" 1 \ch "E♭" 1          % 11-16
  \ch "Cm" 1 \ch "F" 1 \ch "B♭m" 1 \ch "G♭" 1 \ch "E♭m" 1 \ch "F" 1 \ch "G" 1 % 17-23
  \ch "Em" 1 \ch "Am" 1 \ch "D" 1 \ch "G" 1                               % 24-27
  \ch "G7" 1 \ch "C" 1 \ch "Cm" 1 \ch "G" 1 s1 s1                         % 28-33
  \ch "Dm" 1 \ch "B♭" 1 \ch "Gm" 1 \ch "C" 1 \ch "Gm" 1                   % 34-38
  \ch "E♭" 1 \ch "Cm" 1 \ch "F" 1 \ch "B♭m" 1                             % 39-42
  \ch "G♭" 1 \ch "E♭m" 1 \ch "F" 1 \ch "B♭m" 1 \ch "G♭" 1 \ch "E♭m" 1     % 43-48
  \ch "F" 1 \ch "G" 1 \ch "Em" 1 \ch "Am" 1                               % 49-52
  \ch "D" 1 \ch "G" 1 \ch "G7" 1 \ch "C" 1 \ch "Cm" 1 \ch "G" 1           % 53-58
  s1*5
}

% ---------------------------------------------------------------- Partition
\score {
  <<
    \new ChordNames \accords
    \new ChoirStaff <<
      \new Staff = "solo" \with {
        instrumentName = "Solo" shortInstrumentName = "Sol."
        \RemoveAllEmptyStaves
      } <<
        \global
        \new Voice = "solo" \with \voiceAttrs "Solo" { \solo }
      >>
      \new Lyrics \lyricsto "solo" \soloLyr
      \new Staff \with { instrumentName = "Soprano" shortInstrumentName = "S" } <<
        \global
        \new Voice = "sop" \with \voiceAttrs "S" { \sop }
      >>
      \new Lyrics \lyricsto "sop" \sopLyrA
      \new Lyrics \with \italicVerse \lyricsto "sop" \sopLyrB
      \new Staff \with { instrumentName = "Alto" shortInstrumentName = "A" } <<
        \global
        \new Voice = "alto" \with \voiceAttrs "A" { \alto }
      >>
      \new Lyrics \lyricsto "alto" \altoLyrA
      \new Lyrics \with \italicVerse \lyricsto "alto" \altoLyrB
      \new Staff \with {
        instrumentName = "Ténor" shortInstrumentName = "T"
        $(voiceAttrs "T")
      } <<
        \global \clef "treble_8"
        \new Voice = "ten" { \tenor }
      >>
      \new Lyrics \lyricsto "ten" \tenorLyrA
      \new Lyrics \with \italicVerse \lyricsto "ten" \tenorLyrB
      \new Staff \with { instrumentName = "Basse" shortInstrumentName = "B" } <<
        \global \clef bass
        \new Voice = "bas" \with \voiceAttrs "B" { \basse }
      >>
      \new Lyrics \lyricsto "bas" \basseLyrA
      \new Lyrics \with \italicVerse \lyricsto "bas" \basseLyrB
    >>
  >>
  \layout {
    \chorusLayout
    indent = 14\mm
    short-indent = 6\mm
    \context { \Lyrics \override LyricText.font-size = #0 }
  }
}
