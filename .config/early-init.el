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

;; Archives must be set here: package-initialize runs after early-init
;; and before init.el.  (setq package-quickstart t) alone in init.el is too late
;; for MELPA to participate in that first activation.
(setq package-quickstart t
      package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Slightly cheaper first frame on GUI.
(setq frame-inhibit-implied-resize t)
(push '(menu-bar-lines . 0) default-frame-alist)

;;; early-init.el ends here
