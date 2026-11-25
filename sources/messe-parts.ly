% Livret « Dimanche 1er novembre 2026 » : musique des chants (hors Gloria et Alleluia,
% repris de missa-pro-europa-*.ly). Inclus par messe-2026-11-01.ly.

% ================================================================ 1. Les saints et les saintes de Dieu
lsRef = {
  \key g \major \time 6/8 \tempo 4. = 66
  \sectionLabel "Refrain"
  \partial 8 e'8 |
  e'4 d'16 e'16 fis'8 e'8 d'8 | e'4 e'8 g'8 g'8 g'8 | a'8 g'8 a'8 b'4. |
  r8 g'8 a'8 b'8 a'8 g'8 | a'4. r8 a'8 b'8 | c''8 b'8 a'8 b'8 a'8 g'8 | fis'8 e'8 d'8 e'4. \bar "|."
}
lsRefAcc = {
  s8 | \ch "Mim" 4. \ch "Sim/Mi" 4. | \ch "Mim" 4. \ch "Do" 4. | \ch "Ré" 4. \ch "Sol" 4. |
  s2. | \ch "Lam" 2. | s4. \ch "Mim" 4. | \ch "Sim" 4. \ch "Mim" 4. |
}
lsRefTxt = \lyricmode {
  Les saints et les sain -- tes de Dieu s'a -- van -- cent vers le Roi des cieux,
  par leurs hym -- nes de joie, ils cé -- lè -- brent sans fin ce -- lui qui don -- ne vie_!
}
lsCpl = {
  \key g \major
  \sectionLabel "Couplets"
  \time 3/8 r4 g'8 |
  \time 6/8 g'4 g'8 g'8 fis'8 g'8 | a'4.( a'8) g'8 a'8 | b'4 g'8 a'4 b'8 | g'4. g'4. |
  c''4 c''8 c''8( a'8) b'8 | a'8( fis'8 e'8) a'8 g'8( a'8) | b'4 g'8 a'4 b'8 | b'4. b'4. | \break
  \sectionLabel \markup \normal-text \italic "(tous les couplets)"
  e'4. fis'4. | g'4.~ g'8 fis'8 g'8 | a'2.~ | a'4. r4.
  \bar "|." \mark \markup \italic "au Refrain"
}
lsCplAcc = {
  s4. | \ch "Mim" 2. | \ch "Ré" 2. | \ch "Sol" 4. \ch "Si" 4. | \ch "Mim" 4. \ch "7" 4. |
  \ch "Do" 2. | \ch "Ré" 2. | \ch "Sol" 4. \ch "Do6" 4 \ch "7" 8 | \ch "Si" 2. |
  \ch "Do" 2. | \ch "Lam7" 2. | \ch "Ré4" 2. | \ch "3" 4. s4. |
}
lsV = \lyricmode {
  \set stanza = "1."
  Je vis la gloi -- re de Dieu __ re -- vê -- tu de sa puis -- san -- ce.
  De -- vant lui __ se tient __ u -- ne __ lou -- ange é -- ter -- nel -- le_:
  Saint, Saint, Saint, __ le Sei -- gneur_! __
}
lsVb = \lyricmode {
  \set stanza = "2."
  Je vis pa -- raî -- tre son Fils __ res -- plen -- dis -- sant de lu -- miè -- re.
  Il est le __ Sei -- gneur, __ le Sau -- __ veur de tous les hom -- mes_:
}
lsVc = \lyricmode {
  \set stanza = "3."
  Je vis des -- cen -- dre des Cieux __ l'Es -- prit qui rend té -- moi -- gna -- ge.
  Par ce don __ gra -- tuit, __ nous de -- __ ve -- nons fils du Pè -- re_:
}

% ================================================================ 2. Kyrie
kyK = { a'4 a' d'' d'' | c'' c'' a'2 | f'4 f' g' g' | a' a' d'2 }
kyC = { bes'2 a'2 | bes'4( g') a'2 | bes'2 a'4 f' | g' g' a'2 }
kyMel = {
  \key f \major \time 4/4 \tempo 4 = 84
  \sectionLabel "Soliste" \kyK \bar "||"
  \sectionLabel "Assemblée" \kyK \bar "||" \once \override Score.RehearsalMark.break-visibility = #end-of-line-visible \once \override Score.RehearsalMark.self-alignment-X = #RIGHT \mark \markup \italic "Fine" \break
  \sectionLabel "Soliste" \kyC \bar "||"
  \sectionLabel "Assemblée" \kyC \bar "|." \mark \markup \italic "D.C."
}
kyAcc = {
  \ch "Rém" 2 \ch "Solm/Si♭" 2 | \ch "Do" 2 \ch "Fa" 2 | \ch "Si♭" 2 \ch "Solm/Si♭" 2 | \ch "La" 2 \ch "Rém" 2 |
  \ch "Rém" 2 \ch "Si♭" 4 \ch "Si♭7M" 4 | \ch "Do" 2 \ch "Fa" 2 | \ch "Si♭" 2 \ch "Solm/Si♭" 4 \ch "Solm6/Si♭" 4 | \ch "La4" 4 \ch "3" 4 \ch "Rém" 2 |
  \ch "Solm" 2 \ch "Rém" 2 | \ch "Solm" 4 \ch "Solm6" 4 \ch "Rém" 2 | \ch "Solm" 2 \ch "Rém" 4 \ch "Fa/Do" 4 | \ch "Solm/Si♭" 2 \ch "La" 2 |
  \ch "Solm" 2 \ch "Rém" 2 | \ch "Solm" 4 \ch "Solm6" 4 \ch "Rém" 2 | \ch "Solm" 2 \ch "Rém" 4 \ch "Fa/Do" 4 | \ch "Solm6/Si♭" 4 \ch "Solm/Si♭" 4 \ch "La" 2 |
}
kyTxt = \lyricmode {
  Ky -- ri -- e e -- lé -- i -- son, Ky -- ri -- e e -- lé -- i -- son.
  Ky -- ri -- e e -- lé -- i -- son, Ky -- ri -- e e -- lé -- i -- son.
  Chris -- te, Chris -- te, Chris -- te e -- lé -- i -- son.
  Chris -- te, Chris -- te, Chris -- te e -- lé -- i -- son.
}

% ================================================================ 5. Heureux, bienheureux
heRef = {
  \key g \major \time 4/4 \tempo 4 = 100
  \sectionLabel "Refrain"
  \partial 4 e'4 |
  a'2. g'8 fis'8 | g'2. fis'8 e'8 | fis'4. fis'8 g'4 fis'4 | e'8( fis'8) g'8 a'8 b'4 \breathe e'4 |
  a'2. g'8 fis'8 | g'2. fis'8 e'8 | fis'4. a'8 g'4 fis'4 | e'1 \bar "|."
}
heRefAcc = {
  s4 | \ch "Lam" 1 | \ch "Mim" 1 | \ch "Lam" 2 \ch "Mim" 4 \ch "Lam" 4 | \ch "Mim" 2. \ch "Mi" 4 |
  \ch "Lam" 1 | \ch "Mim" 1 | \ch "Lam" 2 \ch "Mim" 4 \ch "Si" 4 | \ch "Mim" 1 |
}
heRefTxt = \lyricmode {
  Heu -- reux, bien -- heu -- reux, qui é -- cou -- te la pa -- ro -- le de Dieu.
  Heu -- reux, bien -- heu -- reux, qui la gar -- de dans son cœur.
}
heStr = {
  \key g \major
  \sectionLabel "Strophes 1 à 4"
  \cadenzaOn \omit Staff.TimeSignature
  e'8 b'\breve c''8 b'8 a'4 \breathe b'\breve fis'8 g'8 a'8 b'4 \bar "|" \break
  e'8 b'\breve c''8 b'8 a'4 \breathe b'\breve g'8 fis'8 e'4
  \bar "||" \mark \markup \italic "au Refrain"
  \cadenzaOff
}
heStrAcc = {
  s8 \ch "Mim" \breve s8 s8 \ch "Do6" 4 \ch "Si7" \breve s8 s8 s8 \ch "Mim" 4
  s8 \ch "Mi7" \breve s8 s8 \ch "Lam" 4 \ch "Si7" \breve s8 s8 \ch "Mim" 4
}
heS = \lyricmode { \override LyricText.self-alignment-X = #LEFT }
heSa = \lyricmode {
  \heS \set stanza = "1."
  Heu -- "reux ceux ont une â" -- me de pauvre, "car le royaume des" cieux est à eux.
  Heu -- reux les _ doux, "car ils posséde" -- ront la terre.
}
heSb = \lyricmode {
  \heS \set stanza = "2."
  Heu -- "reux les" af -- fli -- gés, "car ils se" -- ront con -- so -- lés.
  Heu -- "reux les affamés et assoiffés" de jus -- tice, "car ils seront" ras -- sa -- siés.
}
heSc = \lyricmode {
  \heS \set stanza = "3."
  Heu -- "reux les miséri" -- cor -- di -- eux, "car ils obtiendront" mi -- sé -- ri -- corde.
  Heu -- reux les cœurs purs, "car ils" ver -- ront Dieu.
}
heSd = \lyricmode {
  \heS \set stanza = "4."
  Heu -- "reux les arti" -- sans de paix, "car ils seront appe" -- lés fils de Dieu.
  Heu -- "reux les persécutés pour" la jus -- tice, "car le Royaume des cieux" est à eux.
}
heCinq = {
  \key g \major \time 4/4
  \sectionLabel "Strophe 5"
  \partial 4 e'4 |
  fis'4 fis'8 g'8 a'4 a'8 fis'8 | g'8 fis'8 g'8 a'8 b'4 b'4 | a'4 a'4 d''8 d''8 d''8 c''8 | b'2. \breathe e'4 |
  fis'4 fis'8 g'8 a'4 a'8 fis'8 | g'8( fis'8) g'8 a'8 b'4 b'8 b'8 | a'4 a'8 a'8 d''8 d''8 d''8 c''16 c''16 | b'2. \breathe b'4 |
  c''4 c''8 b'8 a'4. b'8 | g'4 a'16 g'16 fis'8 e'8 e'8 e'8 e'8 | fis'4 fis'8 a'8 g'4 e'4 | fis'2. \breathe b'4 |
  c''4 c''8 b'8 a'4. b'8 | g'4 a'16 g'16 fis'8 e'8 e'8 e'8 e'8 | fis'4 fis'8 a'8 g'4 fis'4 | e'2.
  \bar "|." \mark \markup \italic "au Refrain"
}
heCinqAcc = {
  s4 | \ch "Ré/Mi" 1 | \ch "Mim" 1 | \ch "Ré/Mi" 1 | \ch "Mim" 2. s4 |
  \ch "Ré/Mi" 1 | \ch "Mim" 1 | \ch "Do6" 2 \ch "Ré" 2 | \ch "Sol5+" 2 \ch "Si7" 4 \ch "Mi7" 4 |
  \ch "Lam" 1 | \ch "Mim" 2 \ch "Lam" 4 \ch "Mim" 4 | \ch "Lam6" 2 \ch "Mim" 2 | \ch "Si4" 2 \ch "3" 4 \ch "Mi7" 4 |
  \ch "Lam" 1 | \ch "Mim" 2 \ch "Lam" 4 \ch "Mim" 4 | \ch "Lam6" 2 \ch "Mim" 4 \ch "Si7" 4 | \ch "Mim" 2. |
}
heCinqTxt = \lyricmode {
  \set stanza = "5."
  Heu -- reux se -- rez -- vous quand on vous in -- sul -- te -- ra et qu'on vous per -- sé -- cu -- te -- ra
  et que l'on di -- ra faus -- se -- ment __ con -- tre vous tou -- te sor -- te de mal à cau -- se de moi.
  Soy -- ez dans la joie, soy -- ez dans l'al -- lé -- gres -- se, dans les cieux vous se -- rez com -- blés,
  soy -- ez dans la joie, soy -- ez dans l'al -- lé -- gres -- se, dans les cieux vous se -- rez com -- blés.
}

% ================================================================ 6. Sanctus
saMel = {
  \key d \major \time 4/4 \tempo 4 = 100
  \sectionLabel \markup { "Soliste," \normal-text \italic "puis tous" }
  a'4 a' d'' cis'' | b'8 b' a' g' a'2 | fis'4 fis' b' a' | g'8 fis' e' e' d'2 \bar "||"
  \sectionLabel "Soliste"
  d'4 d'8 e' fis'4 fis'8 a' | b'2 a'2 | d''4 a' b'2 | g'4( fis') e'2 \bar "||" \break
  \sectionLabel \markup { "Tous" \normal-text \italic "(soliste la 1re fois)" }
  \mark \markup \musicglyph "scripts.segno"
  a'4 d'' cis'' b'8 a' | b'2 a'2 | fis'4 b' a' g'8 fis' | e'2 d'2 \bar "||" \once \override Score.RehearsalMark.break-visibility = #end-of-line-visible \once \override Score.RehearsalMark.self-alignment-X = #RIGHT \mark \markup \italic "Fine" \break
  \sectionLabel "Soliste"
  d''4 d'' cis'' cis''8 cis'' | b'2 cis''2 | d''4 d''8 d'' cis''2 | b'4 b' a'2
  \bar "|." \mark \markup \italic "D.S. al Fine"
}
saAcc = {
  \ch "Ré" 4 \ch "La/Do♯" 4 \ch "Sim" 4 \ch "Fa♯m" 4 | \ch "Sol" 4 \ch "Mim" 4 \ch "Ré" 2 |
  \ch "Ré" 4 \ch "Fa♯m7/Do♯" 4 \ch "Sim" 4 \ch "Fa♯m" 4 | \ch "Mim7" 4 \ch "La4" 8 \ch "3" 8 \ch "Ré" 2 |
  \ch "Sim" 4 s8 \ch "La" 8 \ch "Ré" 2 | \ch "Sol" 2 \ch "La" 2 | \ch "Ré" 4 \ch "Fa♯m" 4 \ch "Sol" 2 | \ch "Mim" 4 \ch "Mim9" 4 \ch "La" 2 |
  \ch "Ré" 4 \ch "Sim" 4 \ch "Fa♯m" 2 | \ch "Sol" 2 \ch "Ré" 2 | \ch "Ré" 4 \ch "Sim" 4 \ch "Fa♯m" 4 \ch "Mim9" 4 | \ch "La" 2 \ch "Ré" 2 |
  \ch "Sim" 4 \ch "Mi7/Si" 4 \ch "La/Do♯" 4 \ch "Fa♯m" 4 | \ch "Sim/Ré" 4 \ch "Mi" 4 \ch "La" 2 |
  \ch "Ré/Fa♯" 4 \ch "Mi7/Sol♯" 4 \ch "La" 4 \ch "Fa♯m" 4 | \ch "Sim/Ré" 4 \ch "Mi" 4 \ch "La" 2 |
}
saTxt = \lyricmode {
  Sanc -- tus, Sanc -- tus, Sanc -- tus Do -- mi -- nus, Sanc -- tus, Sanc -- tus De -- us Sa -- ba -- oth.
  Ple -- ni sunt cae -- li et ter -- ra glo -- ri -- a tu -- a.
  Ho -- san -- na in ex -- cel -- sis. Ho -- san -- na in ex -- cel -- sis.
  Be -- ne -- dic -- tus qui ve -- nit in no -- mi -- ne Do -- mi -- ni.
}

% ================================================================ 7. Agnus Dei
agA = {
  \key f \major \tempo "Calme" 4 = 60
  \sectionLabel "Assemblée"
  \time 2/4 a'4 a' | \time 4/4 g'4 g' r a' | d''4 d''8 d'' c''4 c'' | bes'2 a'2 \bar "||"
}
agAAcc = { \ch "Fa" 2 | \ch "Do" 2. \ch "Fa" 4 | \ch "Si♭" 4 s8 \ch "6" 8 \ch "Fa" 2 | \ch "Solm" 2 \ch "La" 2 | }
agATxt = \lyricmode { A -- gnus De -- i, qui tol -- lis pec -- ca -- ta mun -- di_: }
agM = {
  \key f \major \time 4/4
  \sectionLabel \markup { "Solistes," \normal-text \italic "puis chœur" }
  f'8 e' d' f' e'4 e' | f'8 e' d' f' g'4 g' | a'4. a'8 g'4 f' | e'2 d'2 \bar "|."
}
agMAcc = { \ch "Rém" 4. \ch "Sol" 8 \ch "La" 2 | \ch "Rém" 2 \ch "Do" 2 | \ch "Fa" 2 \ch "Do" 4 \ch "Rém" 4 | \ch "La4" 4 \ch "3" 4 \ch "Rém" 2 | }
agMa = \lyricmode { \set stanza = "1 & 2." Mi -- se -- re -- re no -- bis. Mi -- se -- re -- re no -- bis. Mi -- se -- re -- re no -- bis. }
agMb = \lyricmode { \set stanza = "3." Do -- na no -- bis pa -- cem. Do -- na no -- bis pa -- cem. Do -- na no -- bis pa -- cem. }
agD = {
  \key f \major \time 4/4
  \sectionLabel \markup \normal-text \italic "Pour finir (3e fois) : quelques sopranes en superposition"
  a'8 a' a' g' a'4 a' | d''8 e'' f'' f'' e'' d'' c''4 | f''4. f''8 g''4 f'' | e''2 d''2 \bar "|."
}
agDTxt = \lyricmode { Do -- na no -- bis pa -- cem. Do -- na no -- bis pa -- cem. Do -- na no -- bis pa -- cem. }

% ================================================================ 8. Céleste Jérusalem
ceRef = {
  \key d \major \time 4/4
  \sectionLabel "Refrain"
  r4 d'4 d'4 cis'4 | d'2. d'4 | d'4 cis'8 d'8~ d'4 a'4 | a'1~ | a'2 fis'4 fis'4 | g'2. g'4 | \break
  g'4 fis'8 fis'8~ fis'4 d'4 | e'1~ | e'4 d'4 d'4 cis'4 | d'2 \breathe d'4 d'4 | d'4 cis'8 d'8~ d'4 a'4 | \break
  a'1~ | a'2. fis'8( g'8) | a'2 d'2 | fis'8( e'8~ e'4) d'4 cis'4 | d'1 \bar "|."
}
ceRefAcc = {
  s1 | \ch "Ré" 1 | \ch "La" 1 | \ch "Sim7" 1 | s1 | \ch "Sol" 1 |
  \ch "Mim" 1 | \ch "La4" 1 | \ch "La" 1 | \ch "Ré" 1 | \ch "La" 1 |
  \ch "Sim7" 1 | s1 | \ch "Sol" 1 | \ch "La" 1 | \ch "Ré4" 1 |
}
ceRefTxt = \lyricmode {
  No -- tre ci -- té se trou -- ve dans __ les cieux, __ nous ver -- rons l'é --
  pou -- se de __ l'A -- gneau, __ res -- plen -- dis -- san -- te de la gloi -- re __ de
  Dieu, __ cé -- les -- te Jé -- ru -- sa -- lem.
}
ceCpl = {
  \key d \major \time 4/4
  \sectionLabel "Couplets"
  r4 fis'4 g'4 a'4 | a'2 a'4 b'4~ | b'4 b'4 a'4 a'4~ | a'1 | \break
  r4 d'4 e'4 fis'4 | fis'2 fis'4 g'4 | g'2 fis'4 g'4 | e'1 | \break
  r4 a'4 d''4 cis''4 | cis''2 b'4 b'4~ | b'4 \parenthesize b'4 a'4 a'4~ | a'1 | \break
  r4 d'4 e'4 fis'4 | fis'2 fis'4 g'4~ | g'2 fis'4 g'4 | a'2 a'2
  \bar "|." \mark \markup \italic "au Refrain"
}
ceCplAcc = {
  \ch "Ré" 1 | \ch "Sol" 1 | s1 | \ch "Ré/Fa♯" 1 |
  s1 | \ch "Mim" 1 | s1 | \ch "La4" 1 |
  \ch "La" 1 | \ch "Sol" 1 | s1 | \ch "Ré/Fa♯" 1 |
  s1 | \ch "Mim" 1 | s1 | \ch "La" 1 |
}
ceVa = \lyricmode {
  \set stanza = "1."
  L'A -- gneau de -- vien -- dra no -- tre flam -- beau, __
  nous nous pas -- se -- rons du __ _ so __ _ leil, __
  il n'y_au -- ra plus ja -- mais __ _ de nuit, __
  Dieu ré -- pan -- dra sur nous __ sa lu -- miè -- re.
}
ceVb = \lyricmode {
  \set stanza = "2."
  Dieu au -- ra sa de -- meure a -- vec nous, __
  il es -- suie -- ra les lar -- mes de nos yeux, __
  il n'y_au -- ra plus de pleurs __ ni de peines, __
  car l'an -- cien mon -- de s'en __ est al -- lé. __ _
}
ceVc = \lyricmode {
  \set stanza = "3."
  Et main -- te -- nant, voi -- ci le sa -- lut, __
  le rè -- gne et la puis -- san -- ce de Dieu, __
  soy -- ez donc dans la joie __ vous les cieux, __
  il ré -- gne -- ra sans fin __ dans les siè -- cles.
}

% ================================================================ 9. Il est temps de quitter vos tombeaux
itRef = {
  \key f \major \time 2/2 \tempo 4 = 120
  \sectionLabel "Refrain"
  \partial 2 r8. d'16~ d'8 e'8 |
  \repeat volta 2 {
    f'8. f'16~ f'8 f'8 e'8. d'16~ d'8 c'8 | d'2 d'8. d'16~ d'8( e'8) |
    f'8. f'16~ f'8 f'8 g'8. g'16~ g'8 a'8 | a'2~ a'4. a'8 | \break
    bes'8 bes'16 bes'16~ bes'8 a'8 g'8. g'16 g'8 g'8 | a'4. a'8 a'8. g'16~ g'8 f'8 |
    \alternative {
      { a'2~ a'8. d'16~ d'8 e'8 | }
      { a'2. r4 | }
    }
  }
  \bar "|."
}
itRefAcc = {
  s2 |
  \ch "Rém" 2 \ch "Lam" 2 | \ch "Rém" 1 | s2 \ch "Do" 2 | \ch "Fa" 1 |
  \ch "Solm7" 2 \ch "Do" 2 | \ch "Fa" 2 \ch "Mim7" 2 |
  \ch "La4" 2 \ch "3" 2 | \ch "La4" 4 \ch "3" 2 s4 |
}
itRefTxt = \lyricmode {
  Il est temps de quit -- ter vos tom -- beaux __ de sor -- tir du som -- meil de la nuit, __
  d'al -- ler vers la lu -- miè -- re ac -- cla -- mer le Dieu trois fois Saint_! __ Il est
  Saint_!
}
itCpl = {
  \key f \major \time 2/2
  \sectionLabel "Couplets"
  \partial 4 r8 a'8 |
  f'8. g'16~ g'8 a'8 bes'8. bes'16~ bes'8 a'8 | g'8. g'16~ g'8 a'8( a'8.) a'16~ a'8 g'8 |
  f'8. f'16~ f'8 f'8 g'8. g'16~ g'8 f'8 | g'2 g'4 r8 a'8 | \break
  f'8. g'16~ g'8 a'8 bes'8 bes'8 bes'8 a'8 | g'8. g'16~ g'8 a'8( a'8.) a'16~ a'8 g'8 |
  f'4. a'8 bes'8 bes'16 bes'16~ bes'8 a'8 | c''4. c''8 r8. d'16~ d'8 e'8
  \bar "||" \mark \markup \italic "au Refrain"
}
itCplAcc = {
  s4 | \ch "Rém" 2 \ch "Solm" 2 | \ch "Do" 2 \ch "Fa" 2 |
  \ch "Rém" 2 \ch "Do" 2 | \ch "Sol4" 2 \ch "3" 2 |
  \ch "Rém" 2 \ch "Solm" 2 | \ch "Do" 2 \ch "Fa" 2 |
  \ch "Rém" 2 \ch "Si♭" 4 \ch "Solm" 4 | \ch "Do4" 4. \ch "3" 8 s2 |
}
itVa = \lyricmode {
  \set stanza = "1."
  Vain -- queur de la nuit, Christ res -- sus -- ci -- té, __ tu dé -- voi -- les la fa -- ce du Pè -- re. Tu
  es la lu -- miè -- re, tu es no -- tre joie. __ Sois bé -- ni, ô Dieu qui nous li -- bè -- res_! Il est
}
itVb = \lyricmode {
  \set stanza = "2."
  U -- nis à ton corps, Christ res -- sus -- ci -- té, __ tu nous mènes à la gloire é -- ter -- nel -- le. Tu
  pré -- sentes au Pè -- re ceux qu'il t'a con -- fiés. __ Sois lou -- é, re -- çois no -- tre pri -- è -- re_! Il est
}
itVc = \lyricmode {
  \set stanza = "3."
  Tu don -- nes l'Es -- prit, Christ res -- sus -- ci -- té, __ tu dé -- ver -- ses les fleu -- ves d'eaux vi -- ves. Fils
  ai -- mé du Pè -- re tu nous as sau -- vés. __ Gloire à toi, pour ta mi -- sé -- ri -- cor -- de_! Il est
}
itVd = \lyricmode {
  \set stanza = "4."
  Roi de l'u -- ni -- vers, Christ res -- sus -- ci -- té, __ toi qui trônes à la droi -- te du Pè -- re. Tu
  viens dans la Gloi -- re pour nous re -- le -- ver. __ Ô Sei -- gneur, que s'ou -- vre ton Roy -- au -- me_! Il est
}
