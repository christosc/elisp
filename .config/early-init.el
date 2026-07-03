;;; early-init.el --- Early configuration  -*- lexical-binding: t; -*-

;; tmux is in `always` mode, so it pushes the modifyOtherKeys sequence unconditionally —
;; we don't need xterm.el to request or auto-decode it. We own the exact sequence ourselves.
;; (add-hook 'tty-setup-hook
;;           (lambda ()
;;             (define-key input-decode-map "\e[27;7;37~" [?\C-\M-%])))

;; (define-advice require (:around (orig feature &rest args) my/time-require)
;;   (let ((start (current-time)))
;;     (prog1 (apply orig feature args)
;;       (let ((elapsed (float-time (time-subtract (current-time) start))))
;;         (when (> elapsed 0.02)
;;           (message "require %-30s %.3fs" feature elapsed))))))

;; (profiler-start 'cpu)
;; (add-hook 'after-init-hook
;;           (lambda () (profiler-stop) (profiler-report)))

;; early-init.el: ἀναστολὴ GC κατὰ τὴν ἐκκίνησι
(setq gc-cons-threshold most-positive-fixnum)

;; στὸ early-init.el ἢ ἀρκετὰ νωρίς:
(setq package-quickstart t)
