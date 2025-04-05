;; .emacs

;; !!!: For better colors in terminal emacs set 'TERM' env variable to 'screen-256color'.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7"
     "b1a691bb67bd8bd85b76998caf2386c9a7b2ac98a116534071364ed6489b695d"
     "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838"
     "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" default))
 '(diff-switches "-u")
 '(package-selected-packages
   '(company copilot copilot-chat eglot-copilot gruvbox-theme helm lsp-mode lsp-ui
             markdown-mode protobuf-mode yaml-mode zenburn-theme)))

;;; uncomment for CJK utf-8 support for non-Asian users
;;(require 'un-define)

;; Don't hide the menu so that we can learn some useful keyboard shortcuts.
(menu-bar-mode 1)

;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.2")
;; (require 'package)
;; ;;Any add to list for package-archives (to add marmalade or melpa) goes here
;; (add-to-list 'package-archives
;;     '("MELPA" .
;;       "https://melpa.org/packages/"))

;; (package-initialize)
(add-to-list 'load-path "C:/Users/chryssoc/AppData/Roaming/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(require 'fic-mode)
(add-hook 'c++-mode-hook 'turn-on-fic-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-fic-mode)

;; Private definitions
(defconst private-file "private.el" "File with private definitions.")
(if (locate-file private-file load-path)
    (progn
      (message "Loading private.el")
      (load "private.el"))
  (message "No file private.el found"))

;;(require 'yang-mode)
;;(require 'highlight-doxygen)
;;(highlight-doxygen-global-mode 1)

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
(global-set-key (kbd "C-c c o") 'occur-curr-word)

(global-set-key (kbd "C-c t") 'grep-cpp-def)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c f") 'find-name-dired)
;; By default the indentation is weird in C++
;; (setq ;;c-default-style "linux"
;;       c-basic-offset 4)

;; Most often Javascript config files are indented by 2 spaces.
(setq js-indent-level 2)

;; So that yank overwrites selected region
;;(delete-selection-mode 1)

;; Activate easy movement between windows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Don't redraw the screen when recentering with C-l.
;; This is useful for terminal emacs, so that it doesn't "flash" the screen when pressing C-l
;; to recenter the screen.
(setq recenter-redisplay nil)

;; I'll try to get used to the default windmove keybindings...
;; (global-set-key (kbd "C-c h") 'windmove-left)
;; (global-set-key (kbd "C-c l") 'windmove-right)
;; (global-set-key (kbd "C-c k") 'windmove-up)
;; (global-set-key (kbd "C-c j") 'windmove-down)
;; (global-set-key (kbd "C-c <left>")  'windmove-left)
;; (global-set-key (kbd "C-c <right>") 'windmove-right)
;; (global-set-key (kbd "C-c <up>")    'windmove-up)
;; (global-set-key (kbd "C-c <down>")  'windmove-down)
;; </windmove>


;; Enable mouse support
(xterm-mouse-mode t)
(mouse-wheel-mode t)
;; </mouse-support>

;; Ignore case when auto-completing in the minibuffer (does it work?)
(setq completion-ignore-case  t)
;; </case-insensitive-auto-completion-mini-buffer>

;; Show column number at the modeline
(setq column-number-mode t)

;; Ignore case when completing buffer names in minibuffer
;; (setq read-buffer-completion-ignore-case t)


;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; (package-initialize)

(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

;; Switch between header-implementation files.
(global-set-key (kbd "C-c o") 'ff-find-other-file)

(defun cac-c++-mode-hook()
  (c-set-offset 'innamespace 0)
  (c-set-offset 'topmost-intro 0)
  (c-set-offset 'inline-open 0)
  (setq-default indent-tabs-mode nil)
  (c-set-offset 'brace-list-intro 0)
  (c-set-offset 'brace-list-close -)
  )

(c-add-style "cac"
             '("linux"
               (c-basic-offset . 4)
               (c-offsets-alist
               (innamespace . 0)
               (topmost-intro . 0)
               (topmost-intro-cont . 4)
               (statement-cont . 8)
               (arglist-cont . 8)
               (arglist-cont-nonempty . 8)
               (arglist-intro . 8))
               (indent-tabs-mode . nil)))

(setq c-default-style "cac")
;; For some reason setting indent-tabs-mode to nil in the style above, doesn't seem to suffice.
;; I needed to add this hook instead.
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq indent-tabs-mode nil)
   ;;          (setq (cc-other-file-alist
   ;; '(("\\.cc\\'"
   ;;    (".hh" ".h"))
   ;;   ("\\.hh\\'"
   ;;    (".cc" ".C" ".CC" ".cxx" ".cpp" ".c++"))
   ;;   ("\\.c\\'"
   ;;    (".h"))
   ;;   ("\\.m\\'"
   ;;    (".h"))
   ;;   ("\\.h\\'"
   ;;    (".cpp" ".c" ".cc" ".C" ".CC" ".cxx" ".c++" ".m"))
   ;;   ("\\.C\\'"
   ;;    (".H" ".hh" ".h"))
   ;;   ("\\.H\\'"
   ;;    (".C" ".CC"))
   ;;   ("\\.CC\\'"
   ;;    (".HH" ".H" ".hh" ".h"))
   ;;   ("\\.HH\\'"
   ;;    (".CC"))
   ;;   ("\\.c\\+\\+\\'"
   ;;    (".h++" ".hh" ".h"))
   ;;   ("\\.h\\+\\+\\'"
   ;;    (".c++"))
   ;;   ("\\.cpp\\'"
   ;;    (".hpp" ".hh" ".h"))
   ;;   ("\\.hpp\\'"
   ;;    (".cpp"))
   ;;   ("\\.cxx\\'"
   ;;    (".hxx" ".hh" ".h"))
   ;;   ("\\.hxx\\'"
   ;;    (".cxx")))))
            (let ((tags_path (locate-dominating-file (file-name-directory (buffer-file-name)) "TAGS")))
                 (if tags_path
                     (visit-tags-table tags_path)))
            ))
;;(add-hook 'c++-mode-hook 'cac-c++-mode-hook)
;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (c-set-offset 'innamespace 0)
;;             (c-set-offset 'topmost-intro 0)
;;             (setq-default indent-tabs-mode nil)))



;; Below the PWD variable is bash's environment variable holding the path at the
;; time Emacs was started. Therefore it contains the "base" directory of Emacs.
;; With the */* represents all subdirectories up to two-levels deep from the
;; preceeding directory. (See help on ff-search-directories.)
;; The * pattern also covers just the preceeding directory.
;; Acutally these values for the search directories mimick closely Vim's
;;
;;   set path=include/**,src/**,export/**,source/**,../include/**,../export/**,../src/**,../source/**
(setq cc-search-directories '("$PWD/include/*/*" "$PWD/export/*" "$PWD/src/*/*" "$PWD/source/*/*"
                              "../include/*/*" "../export/*/*" "../src/*" "../source/*" "."))
(setq-default indent-tabs-mode nil) ;; DO NOT USE TABS! Linux-style uses tabs... So this won't work...
;; Theming
;;(load-theme 'tango-dark t)
;;(load-theme 'wombat t)
;;(load-theme 'modus-vivendi t)
;;(load-theme 'gruvbox t)
;;(load-theme 'desert t)
;;(load-theme 'wheatgrass t)
;;(load-theme 'zenburn t)
;;(load-theme 'manoj-dark t)
;;(load-theme 'modus-vivendi t)
(load-theme 'modus-vivendi-tinted t)
;;(load-theme 'gruvbox-dark-hard t)
;;(load-theme 'leuven-dark t)
;;(add-to-list 'default-frame-alist '(background-color  . "black"))
;;(set-face-attribute 'region nil :background "mediumblue") ;; Zenburn needs improvement in region highlight
; In order to have all those special color names, like 'gainsboro' etc., one
; needs to enable 24-bit colors in the terminal.  This can done by putting the
; setting
;
; export COLORTERM=truecolor
;
; in .bashrc.  Also one needs to configure tmux appropriately (see
; christosc/dotfiles/tmux.conf).

; If you can find the specific color theme, use that, otherwise make a custom
; theme.
;;(if  nil
;;     (progn
;;       (load-theme 'zenburn t)
;;       ;;(load-theme 'gruvbox t)
;;       ;;(load-theme 'gruvbox-dark-hard t)
;;       ;;(load-theme 'tsdh-dark t)
;;       )
;;       ;(add-to-list 'default-frame-alist '(background-color  . "black")))
;;   (progn
;;     ; You can't just set the background color with something like (set-background-color
;;     ; "grey"), because it will get overriden later in the start-up process of
;;     ; Emacs. Instead you have to set it in the `default-frame-alist'.
;;     ;(add-to-list 'default-frame-alist '(background-color  . "gray10"))
;;     (add-to-list 'default-frame-alist '(background-color  . "black"))
;;     (add-to-list 'default-frame-alist '(foreground-color . "white"))
;;     (set-face-attribute 'region nil :background "mediumblue") ;; Zenburn needs improvement in region highlight
;;     (set-face-attribute 'minibuffer-prompt nil :foreground "gray")
;;     (set-face-attribute 'font-lock-function-name-face nil :foreground "darkorange")
;;     (set-face-attribute 'font-lock-builtin-face nil :foreground "lightsteelblue")
;;     (set-face-attribute 'font-lock-string-face nil :foreground "lemonchiffon3")
;;     (set-face-attribute 'font-lock-comment-face nil :foreground "grey55")
;;     (set-face-attribute 'font-lock-variable-name-face nil :foreground "lavender")
;;     (set-face-attribute 'font-lock-keyword-face nil :foreground "lightsteelblue")
;;     (set-face-attribute 'font-lock-type-face nil  :foreground "darkolivegreen3")
;;     (set-face-attribute 'font-lock-constant-face nil :foreground "lavender")
;;     (set-face-attribute 'lazy-highlight nil :background "darkgoldenrod")
;;     (set-face-attribute 'match nil :background "mediumblue")
;;     (set-face-attribute 'font-lock-preprocessor-face nil :foreground "lightsteelblue")
;;     (set-face-attribute 'completions-common-part nil :foreground "cyan")
;;     (set-face-attribute 'show-paren-match nil :foreground "black" :background "cyan" :inverse-video t)
;;     (set-face-attribute 'completions-highlight nil :foreground "lavender" :background "black" :inverse-video t)
;;     (require 'xref) ; load xref package to be able to set its color next...
;;     (set-face-attribute 'xref-match nil :background "mediumblue")

;;     (set-face-attribute 'isearch-fail nil :foreground "red")
;;     (setq diff-font-lock-syntax nil)
;;     (defun my-diff-fonts ()
;;       "Adjust the font attributes used in this mode."
;;       (set-face-attribute 'diff-removed nil :foreground "Black")
;;       (set-face-attribute 'diff-added nil :foreground "Black")
;;       (set-face-attribute 'diff-file-header nil :foreground "black" :background "brightblue")
;;       (set-face-attribute 'diff-header nil :foreground "Black" :background "brightblue")
;;       )
;;     ;; (add-hook 'diff-mode-hook 'my-diff-fonts)
;;     (add-hook 'dired-mode-hook
;;               (lambda ()
;;                 (set-face-attribute 'dired-directory nil :foreground "brightblue")))
;;     (set-face-attribute 'help-key-binding nil :background "darkblue" :foreground "white")
;;     ) ; progn
;;   ) ; (if custom-theme-enabled)

;; Whiteboard seems a nice theme for light background terminal, but it
;; doesn't color comments in any way, which is not helpful.
;; (load-theme 'whiteboard t)


;; Make comment characters not be "electric". It's very annoying...
(eval-after-load 'cc-mode
  '(progn
     (define-key c-mode-base-map "/" 'self-insert-command)
     (define-key c-mode-base-map "*" 'self-insert-command)))

;; Define alternative keybinding for terminal Emacs (upd: I'll try Steve Yegge's
;; alternative; see below)
;; (global-set-key (kbd "<f5>") 'query-replace-regexp)

;;It's very annoying to detect whitespace right before committing.
;;(setq-default show-trailing-whitespace t)

;; Load mac-greek input method and set it as the default alternative.
(require 'macgreek)
(setq default-input-method "mac-greek")

;; It seems that by default the value of fill-column is 70. It's a bit
;; too restricting.
(setq-default fill-column 80)
(setq server-use-tcp t)

;; Enable recent mode by default (taken from Emacs wiki).
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)

;; Most often Javascript config files are indented by 2 spaces.
(setq js-indent-level 2)

;; Don't ask confirmation when visiting a versioned file through a symlink.
(setq vc-follow-symlinks t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(setq confirm-kill-emacs 'y-or-n-p)

;; (setq icomplete-mode t)
;(setq backup-directory-alist '(("~/.saves")))
(setq backup-directory-alist `(("." . "~/.saves")))
;; By activating helm-mode we can search a project as usual with C-x p f, but
;; this time it gets narrowed down depending on what you type in the search
;; field.
;;(helm-mode 1)
;; Helm documentation asks to have 'flex in the completion styles variable.
;;(add-to-list 'completion-styles 'flex)
;;(setq completion-styles '(flex))


;; By adding the following emacs doesn't change directory each time we open a
;; file.
;; NOTE: Unfortunately this seems to somehow interfere with Emacs' tag search,
;; causing it to not be able to find them. I had to comment it out.
;; (add-hook 'find-file-hook
;;           (lambda ()
;;             (setq default-directory command-line-default-directory)))

;; (helm-mode 1)
;; (setq helm-autoresize-max-height 0)
;; (setq helm-autoresize-min-height 20)
;; (helm-autoresize-mode 1)


;; Don't use helm completion for switching buffers
;; (add-to-list 'helm-completing-read-handlers-alist '(switch-to-buffer . nil))
;; ;; Don't use helm completion for C-h v
;; (add-to-list 'helm-completing-read-handlers-alist '(describe-variable . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(describe-function . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(xref-find-definitions . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(kill-buffer . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(completion-at-point . nil))

;; (defun my-helm-fonts ()
;;   "Adjust the font attributes used in this mode."
;;   (set-face-attribute 'helm-selection nil :inverse-video t)
;;   (set-face-attribute 'helm-selection-line nil :inverse-video t)
;; )
;; (add-hook 'helm-mode-hook 'my-helm-fonts)
;; (set-face-attribute 'header-line-highlight nil :inverse-video t)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
;;(global-set-key (kbd "C-c h") 'helm-command-prefix)

;; Steve Yegge's suggested keybindings
; Some of these keybindings were taken from his "Effective Emacs" post, while
; others from the "Emergency Emacs" video of his.
; Beside the following keybindings he also mentions that he binds "M-j" to
; replay macros, but it seems that the default keybinding for M-j is very
; useful.
;;(global-set-key "\C-x\C-m" 'execute-extended-command)
;;(global-set-key "\C-c\C-m" 'execute-extended-command)
;; (global-set-key "\C-w" 'backward-kill-word)
;; (global-set-key "\C-x\C-k" 'kill-region)  ;; C-x k is kill-buffer
;; (global-set-key "\C-c\C-k" 'kill-region)
;;(global-set-key "\C-xe" 'end-of-buffer)
;;(global-set-key "\C-xt" 'beginning-of-buffer)
;;(global-set-key "\C-xi" 'info)
;;(global-set-key [?\C-h] 'delete-backward-char)
;;(global-set-key [?\C-x ?h] 'help-command) ;; overrides mark-whole-buffer
;;(global-set-key "\C-h" 'backward-delete-char) ; normally 'help'.S.Y. puts this in an "(unless window-system ...)" statement
;;(global-set-key "\C-x\C-h" 'help) ; was undefined
;(define-key help-map "i" 'find-function) ; was `info'
;(define-key help-map "l" 'find-library) ; was `view-lossage'
;(define-key help-map "r" 'find-variable) ; was `info-emacs-manual'
;; (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(defalias 'qrr 'query-replace-regexp)
(global-set-key [f5] 'call-last-kbd-macro) ; S.Y. uses `M-j'
;; (global-set-key "\M-s" 'isearch-forward-regexp) ; was `isearch-forward-symbol-at-point'
;; (global-set-key "\M-r" 'isearch-backward-regexp) ; was `move-to-window-line-top-bottom'
;; (global-set-key "\C-\M-s" 'isearch-forward-symbol-at-point)
; The following bindings were alluded to by S.Y. in "Emergency Emacs".
;;(global-set-key "\M-p" 'previous-line) ; was undefined
;;(global-set-key "\M-n" 'next-line) ; was undefined
; About the following I'm not sure whether S.Y. alluded to them in his video,
; but I'm adding them myself for symmetry.
;;(global-set-key "\M-a" 'move-beginning-of-line) ; was `backward-sentence'
;;(global-set-key "\M-e" 'move-end-of-line) ; was `forward-;(global-set-key "\M-l" 'recenter-top-bottom) ; was `downcase-word'
;(global-set-key "\C-\M-l" 'downcase-word)    ; was `reposition-window'
;;(global-set-key "\C-\M-j" 'call-last-kbd-macro) ; was `default-indent-new-line'

;; I think I don't like blinking cursor in terminal Emacs...
(unless window-system
  (setq visible-cursor nil))

; Reduce the number of beeps Emacs is making. This is from Emacs Wiki (Alarm
; Bell)
(setq ring-bell-function
      (lambda ()
	(unless (memq this-command
		      '(isearch-abort abort-recursive-edit exit-minibuffer keyboard-quit))
	  (ding))))


(defalias 'fr 'fill-region)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'fnd 'find-name-dired)
;; (add-hook 'server-after-make-frame-hook
;;           (lambda ()
;;             (desktop-read)))



(setq sentence-end-double-space nil)

;; Wrap on whole words.
;; I'm not activating this setting, because in its default state without this setting, emacs prints a continuation line character which is rather helpful. I think I prefer it this way.
;; (setq-default word-wrap t)


;; Associate .h files with C++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Reverse direction movement in other-window
(global-set-key (kbd "C-x O") '(lambda () (interactive) (other-window -1)))

(when (and (eq system-type 'windows-nt) (require 'plantuml-mode nil 'noerror))
  (setq plantuml-jar-path "C:/Users/chryssoc/Applications/plantuml-1.2023.12.jar")
  (setq plantuml-default-exec-mode 'jar)
  )


;; Move betweeen windows with M-left, M-right etc.
(windmove-default-keybindings 'meta)

(setq org-todo-keywords
      '((sequence "TODO(t!)" "VERIFY(v!)" "INPROGRESS(i!)" "WAIT(w@/!)" "|" "DONE(d!)" "BLOCKED(b!)")))

(setq confirm-kill-emacs 'yes-or-no-p)

;; When I navigate tags I want the precise case of the word under the cursor.
(set-default 'tags-case-fold-search nil)

;; 1/10-style count in seach results
(setq isearch-lazy-count t)

;; Jump directly to first definition (tag), instead of sticking in the xref
;; window.
(use-package xref
  :config
  (setq xref-auto-jump-to-first-xref 'move)
  (setq xref-auto-jump-to-first-definition t))

;; I'm using this file, .project.el, as a marker where my project's root directory
;; lies in the filesystem. Thus I can use all the project.el commands with
;; regard to the directory where that .project file is found.
;; E.g. I can use the xref-find-references command, bound to M-?.
(setq project-vc-extra-root-markers '(".project.el" ".projectile"))

;;(setq package-check-signature 'allow-unsigned)

;; !!!: This is the way to circuvent restrictions imposed by the proxy in a corporate environment.
;; (Solution given by ChatGPT.)
;; emacs-antiproxy: This approach involves setting up a local mirror of package
;; archives, which can be beneficial when dealing with restrictive proxies or
;; firewalls. By cloning a mirror repository, you can access packages locally
;; without direct internet access:​ GitHub
;;
;;     git clone --depth 1 https://github.com/d12frosted/elpa-mirror.git ~/.emacs.d/mirror-elpa/
;;
;; Then, configure Emacs to use this local mirror:​
;;
;; (setq package-archives '(("melpa" . "~/.emacs.d/mirror-elpa/melpa/")
;;                          ("org"   . "~/.emacs.d/mirror-elpa/org/")
;;                          ("gnu"   . "~/.emacs.d/mirror-elpa/gnu/")))
;; (package-initialize)
;;
;; This method allows you to install packages without needing to traverse the proxy. ​
(setq package-check-signature nil)
(setq package-archives '(("melpa" . "/data/chryssoc/mirror-elpa/melpa/")
                         ("org"   . "/data/chryssoc/mirror-elpa/org/")
                         ("gnu"   . "/data/chryssoc/mirror-elpa/gnu/")))
(package-initialize)

;; Eglot is built into Emacs since version 29
;; Enable eglot for C and C++ modes
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; Enable eglot for Python mode
(add-hook 'python-mode-hook 'eglot-ensure)

;; Commenting out lsp-mode; I'll try built-in eglot...
;; (with-eval-after-load 'lsp-mode
;;   (define-key lsp-mode-map (kbd "C-c l r") 'lsp-find-references))

;; (with-eval-after-load 'lsp-ui
;;   (define-key lsp-mode-map (kbd "C-c l d") 'lsp-ui-doc-show)
;;   (define-key lsp-mode-map (kbd "C-c k") 'lsp-ui-doc-glance))

;; (with-eval-after-load 'lsp-mode
;;   (setq lsp-ui-sideline-enable t
;;         lsp-ui-sideline-show-diagnostics t))

;; (with-eval-after-load 'lsp-mode
;;   (define-key lsp-mode-map (kbd "C-c C-o") 'lsp-clangd-find-other-file))

;; (use-package lsp-mode
;;   :ensure t
;;   :hook ((c-mode c++-mode) . lsp-deferred)
;;   :commands (lsp lsp-deferred)
;;   :config
;;   (setq lsp-clients-clangd-executable "/data/chryssoc/bin/clangd")  ;; Update this path if necessary
;;   (setq lsp-clients-clangd-args '("--log=verbose" "--background-index" "--clang-tidy"))
;;   (setq lsp-log-io t) ;; enable verbose logging
;;   ;; Additional configurations
;;   )

;; (setq lsp-log-io t) ;; enable verbose logging
;; ;;(setq lsp-clients-clangd-args '("--log=verbose"))

;; (use-package lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode
;;   :config
;;   (setq lsp-ui-sideline-enable t)
;;   (setq lsp-ui-sideline-show-diagnostics t)
;;   )

(setq lsp-clients-clangd-executable "/data/chryssoc/bin/clangd")

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 1.0))  ;; Adjust as needed

(require 'eglot)
(add-to-list 'eglot-server-programs
             '((c-mode c++-mode)
               . ("clangd" "--header-insertion=never")))

(require 'quelpa)
(require 'quelpa-use-package)

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main"))

(add-hook 'prog-mode-hook 'copilot-mode)

(use-package copilot-chat)
