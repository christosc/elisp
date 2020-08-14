;; macgreek.el --- Emacs input method mimicking the Mac's one for inputting
;;                 (polytonic) Greek.
;;
;; Add to your .emacs.d/init.el file the following:
;; 1. Clone within e.g. ~/.emacs.d/elisp.
;; 2. Add to init.el the following:
;;    (add-to-list 'load-path "~/.emacs.d/elisp")
;;    (require 'mac-greek)
;;    (setq default-input-method "mac-greek")
;; Then you can switch between the input methods with C-\ .



(require 'quail)

(quail-define-package "mac-greek" "Greek" "MGR" t
              "A input method for Greek simulating the Mac keybidings."
              nil t t nil nil nil nil nil nil nil t)

(quail-define-rules
 (";" "´+(B)")
 ("]" "`+(B)")
 ("[" "῀+(B)")
 ("{" "ι+(B)")
 ("\'" "᾽+(B)")
 ("\"" "῾+(B)")
 (":" "¨+(B)")
 ("-" "῏+(B)")
 ("_" "῟+(B)")
 ("+" "῟+(B)")
 ("/" "῎+(B)")
 ("\?" "῞+(B)")
 ("=" "῍+(B)")
 ("+" "῝+(B)")

 ("a" ?α)
 ("A" ?Α)
 ("b" ?β)
 ("B" ?Β)
 ("g" ?γ)
 ("G" ?Γ)
 ("d" ?δ)
 ("D" ?Δ)
 ("e" ?ε)
 ("Ε" ?Ε)
 ("z" ?ζ)
 ("Z" ?Z)
 ("h" ?η)
 ("H" ?Η)
 ("u" ?θ)
 ("U" ?Θ)
 ("i" ?ι)
 ("I" ?Ι)
 ("k" ?κ)
 ("K" ?Κ)
 ("l" ?λ)
 ("L" ?Λ)
 ("m" ?μ)
 ("M" ?Μ)
 ("n" ?ν)
 ("N" ?Ν)
 ("j" ?ξ)
 ("J" ?Ξ)
 ("o" ?ο)
 ("O" ?Ο)
 ("p" ?π)
 ("P" ?Π)
 ("r" ?ρ)
 ("R" ?Ρ)
 ("s" ?σ)
 ("S" ?Σ)
 ("w" ?ς)
 ("W" ?Σ)
 ("t" ?τ)
 ("T" ?Τ)
 ("y" ?υ)
 ("Y" ?Υ)
 ("f" ?φ)
 ("F" ?Φ)
 ("x" ?χ)
 ("X" ?Χ)
 ("c" ?ψ)
 ("C" ?Ψ)
 ("v" ?ω)
 ("V" ?Ω)

;; ACCUTE ACCENT
   ;; small letters
      (";a" ?ά)
      (";e" ?έ)
      (";o" ?ό)
      (";v" ?ώ)
      (";h" ?ή)
      (";y" ?ύ)
      (";i" ?ί)

   ;; capital letters
      (";A" ?Ά)
      (";E" ?Έ)
      (";O" ?Ό)
      (";V" ?Ώ)
      (";H" ?Ή)
      (";Y" ?Ύ)
      (";I" ?Ί)

;; GRAVE ACCENT
   ;; small letters
      ("]a" ?ὰ)
      ("]e" ?ὲ)
      ("]o" ?ὸ)
      ("]v" ?ὼ)
      ("]h" ?ὴ)
      ("]y" ?ὺ)
      ("]i" ?ὶ)

   ;; capital letters
      ("]A" ?Ὰ)
      ("]E" ?Ὲ)
      ("]O" ?Ὸ)
      ("]V" ?Ὼ)
      ("]H" ?Ὴ)
      ("]Y" ?Ὺ)
      ("]I" ?Ὶ)

;; CIRCUMFLEX ACCENT
   ;; small letters
       ("[a" ?ᾶ)
       ("[v" ?ῶ)
       ("[h" ?ῆ)
       ("[y" ?ῦ)
       ("[i" ?ῖ)

   ;; capital letters (they don't exist)
   ;;   ("[A" ?ᾶ)
   ;;   ("[V" ?ῶ)
   ;;   ("[H" ?ῆ)
   ;;   ("[Y" ?ῦ)
   ;;   ("[I" ?ῖ)


 ;; BREATHINGS
 ;;     SMOOTH
 ;;          SMALL LETTERS.
               ("'a" ?ἀ)
           ("'e" ?ἐ)
           ("'o" ?ὀ)
           ("'v" ?ὠ)
           ("'h" ?ἠ)
           ("'y" ?ὐ)
           ("'i" ?ἰ)
           ("'r" ?ῤ)
        ;; CAPITAL LETTERS
               ("'A" ?Ἀ)
           ("'E" ?Ἐ)
           ("'O" ?Ὀ)
           ("'V" ?Ὠ)
           ("'H" ?Ἠ)
           ("'Y" ?ὐ)
           ("'I" ?Ἰ)
           ;;("'R" ?᾽Ρ)

       ;; ROUGH
           ;;small letters
           ("\"a" ?ἁ)
           ("\"e" ?ἑ)
           ("\"o" ?ὁ)
           ("\"v" ?ὡ)
           ("\"h" ?ἡ)
           ("\"y" ?ὑ)
           ("\"i" ?ἱ)
           ("\"r" ?ῥ)

           ;;capital letters
           ("\"A" ?Ἁ)
           ("\"E" ?Ἑ)
           ("\"O" ?Ὁ)
           ("\"V" ?Ὡ)
           ("\"H" ?Ἡ)
           ("\"Y" ?Ὑ)
           ("\"I" ?Ἱ)
           ("\"R" ?Ῥ)

;; ACCENTS WITH BREATHINGS
   ;; Accute with smooth.
      ;; Small letters.

           ("/a" ?ἄ)
           ("/e" ?ἔ)
           ("/o" ?ὄ)
           ("/v" ?ὤ)
           ("/h" ?ἤ)
           ("/y" ?ὔ)
           ("/i" ?ἴ)

      ;; Capital letters.
           ("/A" ?Ἄ)
           ("/E" ?Ἔ)
           ("/O" ?Ὄ)
           ("/V" ?Ὤ)
           ("/H" ?Ἤ)
           ;;("/Y" ?ὔ)
           ("/I" ?Ἴ)

  ;; Accute with rough.
      ;; Small letters.

           ("\?a" ?ἅ)
           ("\?e" ?ἕ)
           ("\?o" ?ὅ)
           ("\?v" ?ὥ)
           ("\?h" ?ἥ)
           ("\?y" ?ὕ)
           ("\?i" ?ἵ)

      ;; Capital letters.

           ("\?A" ?Ἅ)
           ("\?E" ?Ἕ)
           ("\?O" ?Ὅ)
           ("\?V" ?Ὥ)
           ("\?H" ?Ἥ)
           ("\?Y" ?Ὕ)
           ("\?I" ?Ἵ)

  ;; Grave with smooth.
     ;; Small letters.
           ("=a" ?ἂ)
           ("=e" ?ἒ)
           ("=o" ?ὂ)
           ("=v" ?ὢ)
           ("=h" ?ἢ)
           ("=y" ?ὒ)
           ("=i" ?ἲ)

    ;; Capital letters.

           ("=A" ?Ἂ)
           ("=E" ?Ἒ)
           ("=O" ?Ὂ)
           ("=V" ?Ὢ)
           ("=H" ?Ἢ)
           ("=Y" ?ὒ)
           ("=I" ?Ἲ)

  ;;Grave with rough.
     ;; Small letters.
           ("+a" ?ἃ)
           ("+e" ?ἓ)
           ("+o" ?ὃ)
           ("+v" ?ὣ)
           ("+h" ?ἣ)
           ("+y" ?ὓ)
           ("+i" ?ἳ)

     ;; Capital letters.
           ("+A" ?Ἃ)
           ("+E" ?Ἓ)
           ("+O" ?Ὃ)
           ("+V" ?Ὣ)
           ("+H" ?Ἣ)
           ("+Y" ?Ὓ)
           ("+I" ?Ἳ)

  ;; Circumflex with smooth.
     ;; Small letters.

           ("-a" ?ἆ)
           ("-v" ?ὦ)
           ("-h" ?ἦ)
           ("-y" ?ὖ)
           ("-i" ?ἶ)

     ;; Capital letters.

           ("-A" ?Ἆ)
           ("-V" ?Ὦ)
           ("-H" ?Ἦ)
           ("-Y" ?ὖ)
           ("-I" ?Ἶ)

 ;; Circumflex with rough.
    ;; Small letters.

           ("_a" ?ἇ)
           ("_v" ?ὧ)
           ("_h" ?ἧ)
           ("_y" ?ὗ)
           ("_i" ?ἷ)

    ;; Capital letters.

           ("_A" ?Ἇ)
           ("_V" ?Ὧ)
           ("_H" ?Ἧ)
           ("_Y" ?ὗ)
           ("_I" ?Ἷ)


 ;; SUBSCRIPT IOTA
    ;; Small letters.
           ("{a" ?ᾳ)
           ("{v" ?ῳ)
           ("{h" ?ῃ)

    ;; Capital letters.
           ("{A" ?ᾼ)
           ("{V" ?ῼ)
           ("{H" ?ῌ)

    ;; With accute.
       ;; Small letters.
           (";{a" ?ᾴ)
           (";{v" ?ῴ)
           (";{h" ?ῄ)
           ("{;a" ?ᾴ)
           ("{;v" ?ῴ)
           ("{;h" ?ῄ)

       ;; Capital letters. (non existent.)
           ;;("\;{A" ?ᾴ)
           ;;("\;{V" ?ῴ)
           ;;("\;{Η" ?ῄ)

    ;; With grave.
       ;; Small letters.
           ("]{a" ?ᾲ)
           ("]{v" ?ῲ)
           ("]{h" ?ῂ)
           ("{[a" ?ᾲ)
           ("{[v" ?ῲ)
           ("{[h" ?ῂ)

       ;; Capital letters. (non existent.)
           ;;("]{a" ?ᾲ)
           ;;("]{v" ?ῲ)
           ;;("]{η" ?ῂ)

    ;; With circumflex.
       ;; Small letters.
           ("[{a" ?ᾷ) ("{[a" ?ᾷ)
           ("[{v" ?ῷ) ("{[v" ?ῷ)
           ("[{h" ?ῇ) ("{[h" ?ῇ)


       ;; Capital letters. (non existent.)



    ;; With smooth.
     ;; Small letters.
           ("'{a" ?ᾀ)
           ("'{v" ?ᾠ)
           ("'{h" ?ᾐ)
           ("{'a" ?ᾀ)
           ("{'v" ?ᾠ)
           ("{'h" ?ᾐ)

     ;; Capital letters.
           ("\'{A" ?ᾈ)
           ("\'{V" ?ᾨ)
           ("\'{H" ?ᾘ)

    ;; With rough.
     ;; Small letters.
           ("\"{a" ?ᾁ)
           ("\"{v" ?ᾡ)
           ("\"{h" ?ᾑ)
           ("{\"a" ?ᾁ)
           ("{\"v" ?ᾡ)
           ("{\"h" ?ᾑ)

     ;; Capital letters.
           ("\"{A" ?ᾉ)
           ("\"{V" ?ᾩ)
           ("\"{H" ?ᾙ)

    ;; Accute - smooth
     ;; Small letters.
           ("/{a" ?ᾄ)
           ("/{v" ?ᾤ)
           ("/{h" ?ᾔ)
           ("{/a" ?ᾄ)
           ("{/v" ?ᾤ)
           ("{/h" ?ᾔ)

     ;; Small letters.
           ("/{A" ?ᾌ)
           ("/{V" ?ᾬ)
           ("/{H" ?ᾜ)

    ;; Accute - rough
     ;; Small letters.
           ("\?{a" ?ᾅ)
           ("\?{v" ?ᾥ)
           ("\?{h" ?ᾕ)

     ;; Capital letters.
           ("\?{A" ?ᾍ)
           ("\?{V" ?ᾭ)
           ("\?{H" ?ᾝ)


     ;; Grave - smooth
     ;; Small letters.
           ("={a" ?ᾂ)
           ("={v" ?ᾢ)
           ("={h" ?ᾒ)

     ;; Capital letters.
           ("={A" ?ᾊ)
           ("={V" ?ᾪ)
           ("={H" ?ᾚ)

    ;; Grave - rough
     ;; Small letters.
           ("+{a" ?ᾃ)
           ("+{v" ?ᾣ)
           ("+{h" ?ᾓ)

     ;; Capital letters.
           ("+{A" ?ᾋ)
           ("+{V" ?ᾫ)
           ("+{H" ?ᾛ)

    ;; Circumflex - smooth
     ;; Small letters.
           ("-{a" ?ᾆ)
           ("-{v" ?ᾦ)
           ("-{h" ?ᾖ)

     ;; Capital letters.
           ("-{A" ?ᾎ)
           ("-{V" ?ᾮ)
           ("-{H" ?ᾞ)

    ;; Circumflex - rough
     ;; Small letters.
           ("_{a" ?ᾇ)
           ("_{v" ?ᾧ)
           ("_{h" ?ᾗ)

     ;; Capital letters.
           ("_{A" ?ᾏ)
           ("_{V" ?ᾯ)
           ("_{H" ?ᾟ)


;; Diairesis
      ;; Plain.
      ;; Small letters.
           ("\:i" ?ϊ)
           ("\:y" ?ϋ)

      ;; Capital letters.
           ("\:I" ?Ϊ)
           ("\:Y" ?Ϋ)

      ;; With accute.
      ;; Small letters.
           ("\:\;i" ?ΐ)
           ("\:\;y" ?ΰ)

      ;; Capital letters. (non existent)


      ;; With grave.
      ;; Small letters.
           ("\:]i" ?ῒ)
           ("\:]y" ?ῢ)

      ;; Capital letters. (non existent)

;; Punctuation
      ("q" ?\;)
      ("Q" ?:)
      ("`" ?·)
      ("\\." ?·)
;; Apostrophe
      ("\\" ?’)
      ("\\\\" [#x5C])

;; Ellipsis
      ("\\..." ?…)

;; Other characters
      ("' " [#x2019]) ;; According to Unicode comments this character is the
                      ;; preferred one to represent the apostrophe.
      ("\\#" [#x0374]) ;; numerical sign
      ("\\##" [#x0375]) ;; lower numerical sign
      ("\\ST" [#x03DA]) ;; Capital stigma
      ("\\st" [#x03DB]) ;; Small stigma
      ("\\s"  [#x00A7]) ;; Section sign
      ("---" ?—) ;; EM DASH
      ("--"  ?–) ;; EN DASH
      ("- "   ?-) ;; minus
      ("+ "   ?+) ;; plus
      ("= "   ?=) ;; equal
      ("{ "   ?{)
      ("} "   ?})
      ("[ "   ?\[)
      ("] "   ?\])
      ("<<"   ?«)
      (">>"   ?»)
      ("\? "  ?\?)
      ("//"   ?/)
      ("/ "   ?/)
)

(provide 'macgreek)
