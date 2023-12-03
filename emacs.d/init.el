;; .emacs

;; !!!: For better colors in terminal emacs set 'TERM' env variable to 'screen-256color'.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7" "b1a691bb67bd8bd85b76998caf2386c9a7b2ac98a116534071364ed6489b695d" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" default))
 '(diff-switches "-u")
 '(package-selected-packages '(gruvbox-theme helm zenburn-theme markdown-mode yaml-mode)))

;;; uncomment for CJK utf-8 support for non-Asian users
;;(require 'un-define)

;; Don't hide the menu so that we can learn some useful keyboard shortcuts.
(menu-bar-mode -1)

;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.2")
;; (require 'package)
;; ;;Any add to list for package-archives (to add marmalade or melpa) goes here
;; (add-to-list 'package-archives
;;     '("MELPA" .
;;       "https://melpa.org/packages/"))

;; (package-initialize)
(add-to-list 'load-path "/data/chryssoc/work/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load "private.el")
(require 'yang-mode)
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
(delete-selection-mode 1)

;; Activate easy movement between windows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; I'll try to get used to the default windmove keybindings...
(global-set-key (kbd "C-c h") 'windmove-left)
(global-set-key (kbd "C-c l") 'windmove-right)
(global-set-key (kbd "C-c k") 'windmove-up)
(global-set-key (kbd "C-c j") 'windmove-down)
;; (global-set-key (kbd "C-c <left>")  'windmove-left)
;; (global-set-key (kbd "C-c <right>") 'windmove-right)
;; (global-set-key (kbd "C-c <up>")    'windmove-up)
;; (global-set-key (kbd "C-c <down>")  'windmove-down)
;; </windmove>


;; Enable mouse support
(xterm-mouse-mode 1)
;; </mouse-support>

;; Ignore case when auto-completing in the minibuffer (does it work?)
(setq completion-ignore-case  t)
;; </case-insensitive-auto-completion-mini-buffer>

;; Show column number at the modeline
(setq column-number-mode t)

;; Ignore case when completing buffer names in minibuffer
;; (setq read-buffer-completion-ignore-case t)


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

;; Switch between header-implementation files.
(global-set-key (kbd "C-c o") 'ff-find-other-file)

(defun cac-c++-mode-hook()
  (c-set-offset 'innamespace 0)
  (c-set-offset 'topmost-intro 0)
  (setq-default indent-tabs-mode nil)
  )

(c-add-style "cac"
             '("linux"
               (c-basic-offset . 4)
               (c-offsets-alist
               (innamespace . 0)
               (topmost-intro . 0))
               (indent-tabs-mode . nil)))

(setq c-default-style "cac")
;; For some reason setting indent-tabs-mode to nil in the style above, doesn't seem to suffice.
;; I needed to add this hook instead.
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq indent-tabs-mode nil)
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



(setq cc-search-directories '("." "../include/*" "../export/*" "../src/*" "../source/*" ".." "/usr/include" "/usr/local/include/*"))
(setq-default indent-tabs-mode nil) ;; DO NOT USE TABS! Linux-style uses tabs... So this won't work...
(set-background-color "black")
(set-foreground-color "white")
;; Theming
;;(load-theme 'tango-dark t)
;;(load-theme 'wombat t)
;;(load-theme 'modus-vivendi t)
;;(load-theme 'tsdh-dark t)
;;(load-theme 'desert t)
;;(load-theme 'wheatgrass t)
;;(load-theme 'zenburn t)
;;(load-theme 'manoj-dark t)
;;(load-theme 'gruvbox t)

; In order to have all those special color names, like 'gainsboro' etc., one
; needs to enable 24-bit colors in the terminal.  This can done by putting the
; setting
;
; export COLORTERM=truecolor
;
; in .bashrc.  Also one needs to configure tmux appropriately (see
; christosc/dotfiles/tmux.conf).
(set-face-attribute 'region nil :background "grey40") ;; Zenburn needs improvement in region highlight
(set-face-attribute 'minibuffer-prompt nil :foreground "gray")
(set-face-attribute 'font-lock-function-name-face nil :foreground "white")
(set-face-attribute 'font-lock-builtin-face nil :foreground "lightsteelblue")
(set-face-attribute 'font-lock-string-face nil :foreground "mediumseagreen")
(set-face-attribute 'font-lock-comment-face nil :foreground "slategrey")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "white")
(set-face-attribute 'font-lock-keyword-face nil :foreground "royalblue1")
(set-face-attribute 'font-lock-type-face nil  :foreground "white")
(set-face-attribute 'font-lock-constant-face nil :foreground "white")
(set-face-attribute 'lazy-highlight nil :background "darkgoldenrod")
(set-face-attribute 'match nil :background "beige")
(set-face-attribute 'font-lock-preprocessor-face nil :foreground "firebrick")
(set-face-attribute 'completions-common-part nil :foreground "cyan")


(set-face-attribute 'isearch-fail nil :foreground "red")
(setq diff-font-lock-syntax nil)
(defun my-diff-fonts ()
  "Adjust the font attributes used in this mode."
  (set-face-attribute 'diff-removed nil :foreground "Black")
  (set-face-attribute 'diff-added nil :foreground "Black")
  (set-face-attribute 'diff-header nil :foreground "Black")
)
(add-hook 'diff-mode-hook 'my-diff-fonts)
(add-hook 'dired-mode-hook
          (lambda ()
            (set-face-attribute 'dired-directory nil :foreground "brightblue")))
;; Whiteboard seems a nice theme for light background terminal, but it
;; doesn't color comments in any way, which is not helpful.
;; (load-theme 'whiteboard t)


;; Make comment characters not be "electric". It's very annoying...
(eval-after-load 'cc-mode
  '(progn
     (define-key c-mode-base-map "/" 'self-insert-command)
     (define-key c-mode-base-map "*" 'self-insert-command)))

;; Define alternative keybinding for terminal Emacs
(global-set-key (kbd "<f5>") 'query-replace-regexp)

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

;; (setq url-proxy-services
;;       '(("http"     . "http://87.254.212.120:8080")
;;         ("https"     . "http://87.254.212.120:8080")))

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
;;(global-set-key (kbd "C-c h") 'helm-command-prefix)
