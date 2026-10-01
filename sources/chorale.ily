\version "2.24.4"
% Style commun des partitions de la chorale
% (gravure PDF + annotations des têtes de notes pour le lecteur web)

#(set-default-paper-size "a4")
#(set-global-staff-size 18)

% --- Annotations pour le lecteur web (ignorées dans le PDF) ---
#(define (note-attrs voice)
   (lambda (grob)
     (let* ((ev (event-cause grob))
            (p (ly:event-property ev 'pitch))
            (d (ly:event-property ev 'duration))
            (arts (ly:event-property ev 'articulations '()))
            (tied (any (lambda (a) (memq 'tie-event (ly:event-property a 'class '()))) arts))
            (m (grob::when grob))
            (loc (grob::rhythmic-location grob)))
       `((class . "nh") (data-v . ,voice)
         (data-m . ,(number->string (if (pair? loc) (car loc) 0)))
         (data-t . ,(number->string (exact->inexact (ly:moment-main m))))
         (data-p . ,(number->string (+ 60 (ly:pitch-semitones p))))
         (data-d . ,(number->string (exact->inexact (ly:moment-main (ly:duration-length d)))))
         ,@(if tied '((data-tie . "1")) '())))))

% En mode annotation (variable d'environnement CHORALE_ANNOTATE=1),
% chaque tête de note porte un lien invisible « http://n/?v=…&t=… » :
% build.py lit ces liens dans le PDF Cairo, issu de la même mise en page
% que le SVG affiché, et place la note rouge exactement sur la tête.
#(define (note-link-stencil voice)
   (let ((attrs (note-attrs voice)))
     (lambda (grob)
       (let* ((s (ly:note-head::print grob))
              (url (string-append "http://n/?"
                     (string-join
                       (filter-map (lambda (kv)
                                     (and (string-prefix? "data-" (symbol->string (car kv)))
                                          (string-append (substring (symbol->string (car kv)) 5) "=" (cdr kv))))
                                   (attrs grob))
                       "&")))
              (x (ly:stencil-extent s X))
              (y (ly:stencil-extent s Y)))
         (ly:stencil-add s (ly:make-stencil (list 'url-link url x y) x y))))))

voiceAttrs =
#(define-scheme-function (v) (string?)
   (if (getenv "CHORALE_ANNOTATE")
       #{ \with { \override NoteHead.stencil = #(note-link-stencil v) } #}
       #{ \with { } #}))

% --- Paroles annotées pour le lecteur web (ignorées dans le PDF) ---
% Chaque syllabe porte un lien « http://l/?ln=…&st=…&vc=…&t=…&tx=… » :
% ligne de paroles, couplet (stanza), voix associée, instant et texte.
% Chaque trait d'union porte « http://h/?ln=…&t=… » (syllabe suivie d'un tiret :
% le mot continue), ce qui permet de regrouper les syllabes en mots.
#(use-modules (rnrs bytevectors))
#(define (chorale-url-escape str)
   (string-concatenate
    (map (lambda (b)
           (let ((c (integer->char b)))
             (if (and (< b 128)
                      (or (char-alphabetic? c) (char-numeric? c) (memv c '(#\- #\_ #\. #\~))))
                 (string c)
                 (string-append "%" (if (< b 16) "0" "") (number->string b 16)))))
         (bytevector->u8-list (string->utf8 str)))))

#(define chorale-lyric-lines '())
#(define (chorale-line-id ctx)
   (let ((e (assq ctx chorale-lyric-lines)))
     (if e (cdr e)
         (let ((id (length chorale-lyric-lines)))
           (set! chorale-lyric-lines (acons ctx id chorale-lyric-lines))
           id))))

#(define (Chorale_lyric_engraver context)
   (make-engraver
    ((initialize engraver) (chorale-line-id context))
    (listeners
     ;; « _ » (vocalise) ne crée pas de syllabe : on le note dans un fichier annexe
     ((lyric-event engraver event)
      (let ((tx (ly:event-property event 'text))
            (file (getenv "CHORALE_MEL_FILE")))
        (if (and file (string? tx) (string-null? (string-trim-both tx)))
            (let ((port (open-file file "a")))
              (format port "~a	~a
" (chorale-line-id context)
                      (chorale-num (ly:moment-main (ly:context-current-moment context))))
              (close-port port))))))
    (acknowledgers
     ((lyric-syllable-interface engraver grob source-engraver)
      (let ((st (ly:context-property context 'stanza #f))
            (av (let ((vc (ly:context-property context 'associatedVoiceContext #f)))
                  (if (ly:context? vc) (ly:context-id vc)
                      (ly:context-property context 'associatedVoice #f)))))
        (ly:grob-set-property! grob 'details
          (append
           `((chorale-line . ,(chorale-line-id context))
             (chorale-stanza . ,(if (markup? st) (markup->string st) ""))
             (chorale-voice . ,(if (string? av) av "")))
           (ly:grob-property grob 'details '()))))))))

#(define (chorale-num x) (number->string (exact->inexact x)))

#(define (chorale-lyric-stencil grob)
   (let ((s (lyric-text::print grob)))
     (if (and (getenv "CHORALE_ANNOTATE") (ly:stencil? s) (not (ly:stencil-empty? s)))
         (let* ((det (ly:grob-property grob 'details '()))
                (txt (ly:grob-property grob 'text))
                (str (if (markup? txt) (markup->string txt) ""))
                (loc (grob::rhythmic-location grob))
                (line (assq-ref det 'chorale-line)))
           (if (not line)
               s
               (let ((url (string-append
                           "http://l/?ln=" (number->string line)
                           "&st=" (chorale-url-escape (or (assq-ref det 'chorale-stanza) ""))
                           "&vc=" (chorale-url-escape (or (assq-ref det 'chorale-voice) ""))
                           "&m=" (number->string (if (pair? loc) (car loc) 0))
                           "&t=" (chorale-num (ly:moment-main (grob::when grob)))
                           "&tx=" (chorale-url-escape str)))
                     (x (ly:stencil-extent s X))
                     (y (ly:stencil-extent s Y)))
                 (ly:stencil-add s (ly:make-stencil (list 'url-link url x y) x y)))))
         s)))

#(define (chorale-spanner-link grob s prefix)
   ;; Lien « http://<prefix>/?ln=…&t=… » sur la syllabe de gauche d'un trait (union ou prolongation)
   (if (getenv "CHORALE_ANNOTATE")
       (let* ((orig (ly:grob-original grob))
              (left (and orig (ly:spanner-bound orig LEFT)))
              (det (and (ly:grob? left) (ly:grob-property left 'details '())))
              (line (and det (assq-ref det 'chorale-line))))
         (if line
             (ly:stencil-add
              (if (ly:stencil? s) s empty-stencil)
              (ly:make-stencil
               (list 'url-link
                     (string-append "http://" prefix "/?ln=" (number->string line)
                                    "&t=" (chorale-num (ly:moment-main (grob::when left))))
                     '(0 . 0.05) '(0 . 0.05))
               '(0 . 0.01) '(0 . 0.01)))
             s))
       s))

#(define (chorale-extender-stencil grob)
   (chorale-spanner-link grob (ly:lyric-extender::print grob) "e"))

#(define (chorale-hyphen-stencil grob)
   (let ((s (ly:lyric-hyphen::print grob)))
     (if (getenv "CHORALE_ANNOTATE")
         (let* ((orig (ly:grob-original grob))
                (left (and orig (ly:spanner-bound orig LEFT)))
                (det (and (ly:grob? left) (ly:grob-property left 'details '())))
                (line (and det (assq-ref det 'chorale-line))))
           (if line
               (ly:stencil-add
                (if (ly:stencil? s) s empty-stencil)
                (ly:make-stencil
                 (list 'url-link
                       (string-append "http://h/?ln=" (number->string line)
                                      "&t=" (chorale-num (ly:moment-main (grob::when left))))
                       '(0 . 0.05) '(0 . 0.05))
                 '(0 . 0.01) '(0 . 0.01)))
               s))
         s)))

% Accords en notation française (texte libre, ex. \ch "La♭" 2)
ch = #(define-music-function (txt dur) (markup? ly:duration?)
  #{ \once \override ChordName.text = #txt c $dur #})

\paper {
  top-margin = 12\mm
  bottom-margin = 12\mm
  left-margin = 15\mm
  right-margin = 15\mm
  indent = 0
  ragged-last-bottom = ##t
  ragged-bottom = ##t
  markup-system-spacing.basic-distance = #14
  system-system-spacing.basic-distance = #16
  system-system-spacing.padding = #3
  score-markup-spacing.padding = #3
  print-first-page-number = ##f
  property-defaults.fonts.serif = "C059"
  property-defaults.fonts.sans = "Nimbus Sans"

  bookTitleMarkup = \markup \column {
    \fill-line {
      \override #'(font-name . "Nimbus Sans Bold") \fontsize #-1.5 \fromproperty #'header:category
      \override #'(font-name . "Nimbus Sans") \fontsize #-1.5 \fromproperty #'header:number
    }
    \vspace #0.6
    \fill-line { \override #'(font-name . "C059 Bold") \fontsize #6 \fromproperty #'header:title }
    \vspace #0.3
    \fill-line { \italic \fontsize #0 \fromproperty #'header:subtitle }
    \vspace #0.8
    \fill-line {
      \fontsize #-1 \fromproperty #'header:poet
      \fontsize #-1 \right-column { \fromproperty #'header:composer \fromproperty #'header:arranger }
    }
  }
  oddHeaderMarkup = \markup \fill-line {
    \null
    \unless \on-first-page \fontsize #-2 \italic \fromproperty #'header:title
    \unless \on-first-page \fontsize #-2 \fromproperty #'page:page-number-string
  }
  evenHeaderMarkup = \oddHeaderMarkup
  oddFooterMarkup = \markup \if \on-last-page \column {
    \fill-line { \fontsize #-3 \italic \fromproperty #'header:copyright }
    \vspace #0.4
    \fill-line { \override #'(font-name . "Nimbus Sans") \fontsize #-3.5 \with-color #(rgb-color 0.55 0.55 0.55) "Chorale Scouts d'Europe — Lyon 2026" }
  }
  evenFooterMarkup = \oddFooterMarkup
}

\header { tagline = ##f }

chorusLayout = \layout {
  \context {
    \Score
    \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/16)
    \override BarNumber.font-size = #-1
    \override SectionLabel.font-name = "Nimbus Sans Bold"
    \override SectionLabel.font-size = #-0.5
    \override SectionLabel.padding = #1.2
    \override MetronomeMark.font-size = #-0.5
  }
  \context {
    \Lyrics
    \consists #Chorale_lyric_engraver
    \override LyricText.stencil = #chorale-lyric-stencil
    \override LyricHyphen.stencil = #chorale-hyphen-stencil
    \override LyricExtender.stencil = #chorale-extender-stencil
    \override LyricText.font-size = #0.6
    \override StanzaNumber.font-series = #'bold
    \override LyricHyphen.minimum-distance = #0.8
    \override LyricSpace.minimum-distance = #0.9
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #0.8
  }
  \context {
    \ChordNames
    \override ChordName.font-shape = #'italic
    \override ChordName.font-size = #0.3
  }
  \context {
    \Staff
    \override InstrumentName.font-size = #-0.5
  }
}

italicVerse = \with { \override LyricText.font-shape = #'italic }
