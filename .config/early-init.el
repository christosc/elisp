;;; early-init.el --- Early configuration  -*- lexical-binding: t; -*-

;; tmux is in `always` mode, so it pushes the modifyOtherKeys sequence unconditionally —
;; we don't need xterm.el to request or auto-decode it. We own the exact sequence ourselves.
;; (add-hook 'tty-setup-hook
;;           (lambda ()
;;             (define-key input-decode-map "\e[27;7;37~" [?\C-\M-%])))

;; (profiler-start 'cpu)
;; (add-hook 'after-init-hook
;;           (lambda () (profiler-stop) (profiler-report)))


;; early-init.el: ἀναστολὴ GC κατὰ τὴν ἐκκίνησι
(setq gc-cons-threshold most-positive-fixnum)
;; στὸ τέλος τοῦ init.el: ἐπαναφορὰ σὲ λογικὴ τιμή
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 8 1024 1024))))

;; στὸ early-init.el ἢ ἀρκετὰ νωρίς:
(setq package-quickstart t)
