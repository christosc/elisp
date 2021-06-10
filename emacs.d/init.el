
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
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(match ((t (:background "nil")))))

;;(load-theme 'zenburn t)

;;(load-theme 'wombat)
;;(load-theme 'tango-dark)
;;(load-theme 'sanityinc-tomorrow-eighties t)
;;(load-theme 'tramp t)
;; (if window-system
;;     (invert-face 'default))  ;; turn to dark background color
;;(load-theme 'manoj-dark)


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

(global-visual-line-mode t)

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
(global-set-key (kbd "C-c SPC") 'toggle-input-method)
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


(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET
;; I leave control-J as electric-newline-and-maybe-indent, in case it's useful
;; to insert newline without any auto indentation.

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



;; Exclude tags files from grep command.
(setq grep-command "grep -nH --null --exclude='TAGS' --exclude='tags' -e ")

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
  (let* ((cur-word (thing-at-point 'symbol))
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
  (occur (thing-at-point 'symbol)))

(defun grep-cpp-def ()
  "setting up grep-command using current word under cursor as a search string"
  (interactive)
  (let* ((cur-word (thing-at-point 'symbol))
         (args (concat "grep -nH --null --exclude-dir={[uU]nittests,[tT]est,build,.hg,.git} --exclude='*.sw?' --exclude='#*#' --exclude='*~' --exclude=tags --exclude='*.orig' -e '::" cur-word "\\>' -rI .")))
    (grep args)))

(defun goto-definition ()
  "Go to C/C++ function definition."
  (interactive)
  (let* ((cur-word (thing-at-point 'symbol t))
         (regexp (concat  "\\w\\s-+\\(\\w+::\\)?" cur-word "(\\|\\(\\*\\|>\\|&\\)\\(\\s-*\\|\\(\\s-*\\w+::\\)\\)" cur-word "(")))
    (unless (re-search-forward regexp nil t) (re-search-backward regexp))))

;; For tips on how to achieve jump to other buffer through grep, maybe this links will be useful:
;; https://stackoverflow.com/a/21161239/375842.
;; Also: https://emacs.stackexchange.com/a/12346/2362

(global-set-key (kbd "C-c d") 'goto-definition)
(global-set-key (kbd "C-c g .") 'grep-word-under-curr-dir)
(global-set-key (kbd "C-c g p") 'grep-word-under-parent-dir)
;;(global-set-key (kbd "C-c o r") 'occur)
(global-set-key (kbd "C-c o") 'occur-curr-word)

(global-set-key (kbd "C-c t") 'grep-cpp-def)
(global-set-key (kbd "C-c r") 'revert-buffer)
(setq vc-follow-symlinks nil)
;;(setq scroll-conservatively most-positive-fixnum)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f9aede508e587fe21bcfc0a85e1ec7d27312d9587e686a6f5afdbb0d220eab50" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "6ebdb33507c7db94b28d7787f802f38ac8d2b8cd08506797b3af6cdfd80632e0" "76c5b2592c62f6b48923c00f97f74bcb7ddb741618283bdb2be35f3c0e1030e3" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(package-selected-packages
   '(yang-mode monokai-theme color-theme-sanityinc-tomorrow tramp-theme zenburn-theme gruvbox-theme spacemacs-theme magit yasnippet ws-butler stickyfunc-enhance sr-speedbar smartparens projectile helm-gtags ggtags function-args dtrt-indent company clean-aindent-mode))
 '(tramp-default-user "chryssoc"))

;; For more options M-x customize-group > grep.
(setq-default grep-highlight-matches nil)
(setq-default grep-save-buffers nil)
;;(defun make-underscore-word-constituent () (modify-syntax-entry ?_ "w"))
;;(add-hook 'c-mode-hook 'make-underscore-word-constituent)
;;(add-hook 'c++-mode-hook 'make-underscore-word-constituent)
;; Treat underscore as part of words.
;;(modify-syntax-entry ?_ "w")


(setq find-file-visit-truename t)

(defconst my-cc-style
  '("linux"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "my-cc-style" my-cc-style)

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
 c-default-style "my-cc-style" ;; set style to "my-cc-style"
 )

;;(setq-default frame-title-format '("%b"))
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
(setq recenter-redisplay nil)


;; better occur mode
 (add-hook 'occur-mode-hook
           (lambda()
             (toggle-truncate-lines t)
             (setq-local cursor-type 'box)
             (setq-local blink-cursor-blinks 1)
             (company-mode -1)
             (hl-line-mode t)
             ;;(next-error-follow-minor-mode t)
             ))
;;(setq list-matching-lines-jump-to-current-line t)

(defconst private-defs-file "~/.emacs.d/private.el" "Filepath for private definitions")

(if (file-exists-p private-defs-file)
    (load-file private-defs-file))

(setq grep-use-null-device nil)

(setq-default
 frame-title-format
 '(:eval
   (format "%s@%s:%s"
           (or (file-remote-p default-directory 'user) user-login-name)
           (or (file-remote-p default-directory 'host) system-name)
           (file-name-nondirectory (or (buffer-file-name) default-directory)))))

(add-hook 'diff-mode-hook
          (lambda () (diff-auto-refine-mode -1)))

(setq vc-handled-backends '(Hg Git))

;; Remove comma from electric indent characters for CC mode
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq-local electric-indent-chars (remq ?, electric-indent-chars))))

(setq visible-cursor nil)

(c-set-offset 'innamespace 0)


;; Disable electric slash and star for CC mode.
;; (eval-after-load 'cc-mode
;;   '(progn
;;      (define-key c-mode-base-map "/" 'self-insert-command)
;;      (define-key c-mode-base-map "*" 'self-insert-command)
;;      (define-key c-mode-base-map ";" 'self-insert-command)
;;      (define-key c-mode-base-map "," 'self-insert-command))
;;   )
  
;; (require 'tramp)
;; (setq tramp-shell-prompt-pattern "^[^>$:]*[>$:] *" )

(setq completion-ignore-case  t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

;; Search recursively up for the TAGS file.
(let ((my-tags-file (locate-dominating-file default-directory "TAGS")))
  (when my-tags-file
    (message "Loading tags file: %s" my-tags-file)
    (visit-tags-table my-tags-file)))

(setq tags-revert-without-query t)
(setq frame-background-mode 'dark)

;; (if (not (display-graphic-p))
;;     ;; In WSL terminal there is no bold face, and the buffer name appears
;;     ;; too light.
;;     (set-face-attribute 'mode-line-buffer-id nil :weight 'normal))

;; Windows Terminal doesn't pass C-SPC or C-@ to emacs, therefore
;; I define an alternative shortcut.
;;(global-set-key (kbd "C-c SPC") 'set-mark-command)

(transient-mark-mode 0)
(setq ediff-split-window-function 'split-window-horizontally)


;; Customizations for manoj-dark color theme.
;;(set-face-attribute 'mode-line-buffer-id nil :foreground "Blue" :background "grey75" :bold nil :weight 'normal)
;;(set-face-attribute 'mode-line-buffer-id nil :foreground 'unspecified :background 'unspecified :bold 'unspecified :weight 'unspecified)

;; Remove bold attribute from modeline buffer id, because it renders as fade-out in terminal...
(set-face-attribute 'mode-line-buffer-id nil :bold 'unspecified :weight 'unspecified)
