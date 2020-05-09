
;; .emacs

(menu-bar-mode -1)
(tool-bar-mode -1)
;; set a default font
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono-10"))

(setq inhibit-startup-screen t)
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
        (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;(custom-set-variables
;; ;; custom-set-variables was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(custom-enabled-themes (quote (adwait)))
;; '(diff-switches "-u")
;; '(package-selected-packages
;;   (quote
;;    (smartparens yasnippet ws-butler dtrt-indent clean-aindent-mode stickyfunc-enhance projectile company sr-speedbar function-args ggtags helm-gtags helm))))
;;
;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;(load-theme 'manoj-dark)
;;(load-theme 'tango-dark)
(load-theme 'wombat)
(setq-default fill-column 80)
(menu-bar-mode -1)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
(setq c-basic-offset 4)
(add-to-list 'load-path "~/.emacs.d/lisp/")
(let ((default-directory  "~/.emacs.d/lisp/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'yang-mode)
;;(global-visual-line-mode t)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;(global-set-key (kbd "C-c <left>")  'windmove-left)
;;(global-set-key (kbd "C-c <right>") 'windmove-right)
;;(global-set-key (kbd "C-c <up>")    'windmove-up)
;;(global-set-key (kbd "C-c <down>")  'windmove-down)
(global-set-key (kbd "C-c h")  'windmove-left)
(global-set-key (kbd "C-c l") 'windmove-right)
(global-set-key (kbd "C-c k")    'windmove-up)
(global-set-key (kbd "C-c j")  'windmove-down)
(global-set-key (kbd "C-c a") 'ff-find-other-file)
(xterm-mouse-mode t)
;;(require 'helm-config)
;;;; Enable helm-gtags-mode
;;(add-hook 'c-mode-hook 'helm-gtags-mode)
;;(add-hook 'c++-mode-hook 'helm-gtags-mode)
;;(add-hook 'asm-mode-hook 'helm-gtags-mode)
;;
;;;; Set key bindings
;;(eval-after-load "helm-gtags"
;;  '(progn
;;     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
;;     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
;;     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
;;     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
;;     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
;;              (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

;;(require 'ggtags)
;;(add-hook 'c-mode-common-hook
;;          (lambda ()
;;            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
;;              (ggtags-mode 1))))
;;
;;(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
;;(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
;;(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
;;(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
;;(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
;;(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)


;;(setq
;; helm-gtags-ignore-case t
;; helm-gtags-auto-update t
;; helm-gtags-use-input-at-cursor t
;; helm-gtags-pulse-at-cursor t
;; helm-gtags-prefix-key "\C-cg"
;; helm-gtags-suggested-key-mapping t
;; )
;;
;;(require 'helm-gtags)
;;;; Enable helm-gtags-mode
;;(add-hook 'dired-mode-hook 'helm-gtags-mode)
;;(add-hook 'eshell-mode-hook 'helm-gtags-mode)
;;(add-hook 'c-mode-hook 'helm-gtags-mode)
;;(add-hook 'c++-mode-hook 'helm-gtags-mode)
;;(add-hook 'asm-mode-hook 'helm-gtags-mode)


;;(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;;(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
;;(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;;(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;;(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;(require 'company)
;;(add-hook 'after-init-hook 'global-company-mode)
;;
;;(setq company-backends (delete 'company-semantic company-backends))
;;(define-key c-mode-map  [(tab)] 'company-complete)
;;(define-key c++-mode-map  [(tab)] 'company-complete)
;;(add-to-list 'company-backends 'company-c-headers)

;;(require 'cc-mode)
;;(require 'semantic)
;;
;;(global-semanticdb-minor-mode 1)
;;(global-semantic-idle-scheduler-mode 1)
;;
;;(semantic-mode 1)
;;
;;(require 'ede)
;;(global-ede-mode)
;;(projectile-global-mode)
;;(global-semantic-idle-summary-mode 1)
;;(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;;
;;(setq-local eldoc-documentation-function #'ggtags-eldoc-function)
;;(add-hook 'c-mode-common-hook   'hs-minor-mode)

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )

;;(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET
;;
;;;; activate whitespace-mode to view all whitespace characters
;;(global-set-key (kbd "C-c w") 'whitespace-mode)
;;
;;;; show unncessary whitespace that can mess up your diff
;;(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)

;; Package: clean-aindent-mode
;;(require 'clean-aindent-mode)
;;(add-hook 'prog-mode-hook 'clean-aindent-mode)
;;
;;;; Package: dtrt-indent
;;(require 'dtrt-indent)
;;(dtrt-indent-mode 1)
;;(setq dtrt-indent-verbosity 0)

;; Package: ws-butler
;;(require 'ws-butler)
;;(add-hook 'c-mode-common-hook 'ws-butler-mode)

;; Package: yasnippet
;;(require 'yasnippet)
;;(yas-global-mode 1)

;; Package: smartparens
;;(require 'smartparens-config)
;;(show-smartparens-global-mode +1)
;;(smartparens-global-mode 1)
;;
;;;; when you press RET, the curly braces automatically
;;;; add another newline
;;(sp-with-modes '(c-mode c++-mode)
;;  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
;;  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
;;                                            ("* ||\n[i]" "RET"))))
;;
;;
;;(global-set-key (kbd "<f5>") (lambda ()
;;                               (interactive)
;;                               (setq-local compilation-read-command nil)
;;                                                              (call-interactively 'compile)))


;;(setq
;; ;; use gdb-many-windows by default
;; gdb-many-windows t
;;
;; ;; Non-nil means display source file containing the main routine at startup
;; gdb-show-main t
;;  )

(require 'macgreek)
(setq default-input-method "mac-greek")

(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)

;;(defun xx ()
;;  "setting up grep-command using current word under cursor as a search string"
;;  (interactive)
;;  (let* ((cur-word (thing-at-point 'word))
;;;;         (cmd (concat "grep -nH -r --exclude='TAGS' --include='*.h' --include='*.cpp' --include='*.pl' --include='*.c' -e " cur-word " /home/alex/code")))
;;         (cmd (concat "grep -nH -r --exclude='TAGS' -e " cur-word " .")))
;;    (grep-apply-setting 'grep-command cmd)
;;    (grep cmd)))
;;
;;(global-set-key (kbd "<f3>")  'xx)


(defun grep-word-under-dir (dir)
  "Grep word under cursor under given directory."
  (let* ((cur-word (thing-at-point 'word))
         (args (concat "grep -nH --null --exclude-dir={[uU]nittests,[tT]est,build,.hg,.git} --exclude='*.sw?' --exclude='#*#' --exclude='*~' --exclude=tags --exclude='*.orig' -e '\\<" cur-word "\\>' -rI " dir)))
    (grep args)))

(defun grep-word-under-curr-dir()
  "Grep word under cursor under current working directory."
  (interactive)
  (grep-word-under-dir "."))

(defun grep-word-under-parent-dir ()
  "Call word under the parent dir of the current one."
  (interactive)
  (grep-word-under-dir ".."))

(defun occur-curr-word ()
  "Do an occur for word under the cursor."
  (interactive)
  (occur (thing-at-point 'word)))

(defun grep-cpp-def ()
  "setting up grep-command using current word under cursor as a search string"
  (interactive)
  (let* ((cur-word (thing-at-point 'word))
         (args (concat "grep -nH --null --exclude-dir={[uU]nittests,[tT]est,build,.hg,.git} --exclude='*.sw?' --exclude='#*#' --exclude='*~' --exclude=tags --exclude='*.orig' -e '::" cur-word "\\>' -rI .")))
    (grep args)))



(global-set-key (kbd "C-c g .") 'grep-word-under-curr-dir)
(global-set-key (kbd "C-c g p") 'grep-word-under-parent-dir)
(global-set-key (kbd "C-c o r") 'occur)
(global-set-key (kbd "C-c o .") 'occur-curr-word)

(global-set-key (kbd "C-c t") 'grep-cpp-def)
(setq vc-follow-symlinks nil)
;;(setq scroll-conservatively most-positive-fixnum)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit yasnippet ws-butler stickyfunc-enhance sr-speedbar smartparens projectile helm-gtags ggtags function-args dtrt-indent company clean-aindent-mode))))

;; For more options M-x customize-group > grep.
(setq-default grep-highlight-matches nil)
(setq-default grep-save-buffers nil)
(defun make-underscore-word-constituent () (modify-syntax-entry ?_ "w"))
(add-hook 'c-mode-hook 'make-underscore-word-constituent)
(add-hook 'c++-mode-hook 'make-underscore-word-constituent)
;; Treat underscore as part of words.
;;(modify-syntax-entry ?_ "w")


(setq find-file-visit-truename t)

(defconst my-cc-style
  '("cc-mode"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "my-cc-mode" my-cc-style)
(setq-default frame-title-format '("%b"))
(delete-selection-mode 1)  ;; paste over selection

(setq-default ff-search-directories (list "." "../export" "../src"))
;; Customizing colors used in diff mode
;; (defun custom-diff-colors ()
;;   "update the colors for diff faces"
;;   (set-face-attribute
;;    'diff-added nil :foreground "green")
;;   (set-face-attribute
;;    'diff-removed nil :foreground "red")
;;   (set-face-attribute
;;    'diff-changed nil :foreground "purple"))
;; (eval-after-load "diff-mode" '(custom-diff-colors))
