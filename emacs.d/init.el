;; .emacs

;; !!!: For better colors in terminal emacs set 'TERM' env variable to 'screen-256color'.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-switches "-u")
 '(package-selected-packages '(markdown-mode yaml-mode))
 '(safe-local-variable-values '((ymodule . "dhcpclient"))))

;;; uncomment for CJK utf-8 support for non-Asian users
;;(require 'un-define)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-function-name-face ((t (:foreground "brightblue"))))
 '(highlight-doxygen-comment ((t (:inherit font-lock-doc-face))))
 '(minibuffer-prompt ((t (:foreground "cyan")))))

;; Don't hide the menu so that we can learn some useful keyboard shortcuts.
;;(menu-bar-mode -1)

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
(load-file "../private.el")
(require 'yang-mode)
(require 'protobuf-mode) ;; mode installed manually
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
(global-set-key (kbd "C-c o") 'occur-curr-word)

(global-set-key (kbd "C-c t") 'grep-cpp-def)
(global-set-key (kbd "C-c r") 'revert-buffer)

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
(global-set-key (kbd "C-c a") 'ff-find-other-file)

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
          (lambda () (setq indent-tabs-mode nil)))
;;(add-hook 'c++-mode-hook 'cac-c++-mode-hook)
;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (c-set-offset 'innamespace 0)
;;             (c-set-offset 'topmost-intro 0)
;;             (setq-default indent-tabs-mode nil)))



(setq cc-search-directories '("." "../include/*" "../export/*" "../src/*" "../source/*" ".." "/usr/include" "/usr/local/include/*"))
(setq-default indent-tabs-mode nil) ;; DO NOT USE TABS! Linux-style uses tabs... So this won't work...

;; Theming
;;(load-theme 'tango-dark t)
;;(load-theme 'wombat t)
;;(load-theme 'modus-vivendi t)
;;(load-theme 'tsdh-dark t)
(load-theme 'desert t)
;; Whiteboard seems a nice theme for light background terminal, but it
;; doesn't color comments in any way, which is not helpful.
;;(load-theme 'whiteboard t)
;;(set-face-foreground 'font-lock-comment-face "dark blue")

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
