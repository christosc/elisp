;;; init.el --- Christos's Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration centred on C/C++ development with
;; tree-sitter major modes, Eglot + clangd, and clang-format on save.

;; On the remote development machine's .bashrc:
;; Use emacsclient as the canonical entry point. The -a '' (empty
;; alternate editor) tells emacsclient to auto-start a daemon on first
;; use, and reuse it thereafter. No explicit daemon management needed.
;; alias e='emacsclient -nw -a ""'
;; alias ec='emacsclient -c -a ""'
;; export EDITOR='emacsclient -nw -a ""'
;; export VISUAL="$EDITOR"

;; alias e="emacs"
;; alias em="emacs"
;; alias emc="emacsclient -nw"
;; export EDITOR=emacs

;;; Code:

;; =============================================================================
;; TO BE ENABLED IF YOU ARE USING EMACS IN TERMINAL FROM A TERMINAL EMULATOR
;; IN WINDOWS (WINDOWS TERMINAL, ALACRITTY ETC.) IN A REAL LINUX SIMULATOR THOSE
;; HACKS DO NOT SEEM TO BE NEEDED!
;; =============================================================================
;;
;; Some key definitions that are useful to preserve C-M-% for query-replace-regexp.
;; The first two are useful for Windows Terminal, which can map the full combo of C-M-% to an escape
;; sequence.
;; The third is useful for Alacritty, which cannot remap the full combo of C-M-% to a sequence.
;; Thst's why we use ESC C-% key combo, and encode only the C-% part.
;; Also we present two escape sequences for C-M-%, which capture both types of escape sequence
;; translation in tmux:
;;
;;     set -g extended-keys-format csi-u
;;     set -g extended-keys-format xterm
;;
;; In Windows Terminal settings, in segement "actions", I have:
;; { "command": { "action": "sendInput", "input": "\u001b[37;7u" }, "keys": "ctrl+alt+shift+5" }

;; (define-key input-decode-map "\e[37;7u"    (kbd "C-M-%"))  ; csi-u
;; (define-key input-decode-map "\e[27;7;37~" (kbd "C-M-%"))  ; csi-tilde

;; In alacritty.toml I have:
;; [[keyboard.bindings]]
;; key = "%"
;; mods = "Control|Shift"
;; chars = "\u001b[37;5u"

;; (define-key input-decode-map "\e[37;5u"    (kbd "C-%"))  ; csi-u (to be used with ESC prefix)

;; ============================================================
;; Core Performance & I/O
;; ============================================================

;; Increase data Emacs reads from processes to 1MB. Crucial so that
;; clangd does not bottleneck on LSP traffic.
;;(setq read-process-output-max (* 1024 1024))

;; Lighter UI / scrolling, helpful in terminal and over SSH.
;; jit-lock-defer-time prevents micro-stutters from font-lock.
(setq fast-but-imprecise-scrolling t
      jit-lock-defer-time          0
      cursor-in-non-selected-windows nil
      recenter-redisplay           nil) ; don't flash on C-l in terminal


;; ============================================================
;; Garbage Collection
;; ============================================================

;; High threshold during startup, lower it once loaded.
;; Consider the `gcmh' package for adaptive handling later.
;; (setq gc-cons-threshold (* 100 1024 1024))
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (setq gc-cons-threshold (* 16 1024 1024))))

;; ============================================================
;; Native Compilation
;; ============================================================

(setq native-comp-jit-compilation              t
      package-native-compile                   t
      native-comp-async-report-warnings-errors nil
      native-comp-async-jobs                   (max 2 (/ (num-processors) 2)))

;; ============================================================
;; Cache management
;; ============================================================

(setq org-persist-directory
      (expand-file-name "emacs/org-persist/"
                        (getenv "LOCALAPPDATA")))

;; ============================================================
;; Package Management
;; ============================================================

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Extra load paths — abide to the user-emacs-directory on every platform
(add-to-list 'load-path (locate-user-emacs-file "elisp"))
(add-to-list 'custom-theme-load-path (locate-user-emacs-file "themes"))


;; ============================================================
;; UI & Editing Basics
;; ============================================================

(menu-bar-mode -1)
(setq column-number-mode        t
      completion-ignore-case    t
      vc-follow-symlinks        t
      ;;confirm-kill-emacs        'yes-or-no-p
      sentence-end-double-space nil
      isearch-lazy-count        t
      set-mark-command-repeat-pop t)

(setq-default fill-column 100)

;; (display-fill-column-indicator-mode 1)

;; Tag navigation should not be case-folded.
(set-default 'tags-case-fold-search nil)

;; Collect backups in one directory rather than scattering them.
(setq backup-directory-alist '(("." . "~/.saves")))

;; Server for emacsclient.
(setq server-use-tcp t)

;; Terminal mouse support.
(xterm-mouse-mode t)
(mouse-wheel-mode t)

(setq custom-safe-themes t)
(which-function-mode 1)

;; (if (not (display-graphic-p))
;;     ;; In terminal do not use colors
;;     (global-font-lock-mode -1))

;; (with-eval-after-load 'flymake
;;   (set-face-attribute 'flymake-error   nil :inherit nil :foreground 'unspecified :underline t)
;;   (set-face-attribute 'flymake-warning nil :inherit nil :foreground 'unspecified :underline t)
;;   (set-face-attribute 'flymake-note    nil :inherit nil :foreground 'unspecified :underline t))

;; (with-eval-after-load 'eglot
;;   (dolist (f '(eglot-diagnostic-tag-unnecessary-face
;;                eglot-diagnostic-tag-deprecated-face))
;;     (set-face-attribute f nil
;;                         :inherit nil :weight 'unspecified :strike-through nil
;;                         :foreground 'unspecified :underline t)))

(with-eval-after-load 'eglot
  (when (boundp 'eglot-mode-line-format)
    (setq eglot-mode-line-format
          (remove 'eglot-mode-line-pending-requests eglot-mode-line-format))))

(defun my/eglot-enable-semantic-tokens ()
  "Activate LSP semantic tokens as corrective layer over tree-sitter."
  (when (and (eglot-managed-p)
             (fboundp 'eglot-semantic-tokens-mode)
             (eglot-server-capable :semanticTokensProvider))
    (eglot-semantic-tokens-mode 1)))

(add-hook 'eglot-managed-mode-hook #'my/eglot-enable-semantic-tokens)

(load-theme 'modus-vivendi t)

;; ;; on Windows set a dark theme
;; (if (display-graphic-p)
;;     ;; GUI (usually your Windows instance)
;;     (load-theme 'modus-vivendi t)
;;   (progn (load-theme 'modus-vivendi-tinted)
;;          (set-face-attribute 'region nil :background "blue"))
;;   )


;; Tame the bell — only ring on genuine errors, not on minibuffer aborts.
(setq ring-bell-function
      (lambda ()
        (unless (memq this-command
                      '(isearch-abort abort-recursive-edit
                                      exit-minibuffer keyboard-quit))
          (ding))))


;; Use JetBrains Mono at 11pt on Windows only, to match the bundled
;; WezTerm default font. On Linux Emacs 31 keep the system default.
;;
;; Greek glyphs are routed to DejaVu Sans Mono: JetBrains Mono lacks
;; the Greek Extended block (U+1F00..U+1FFF), where all polytonic
;; precomposed characters live (breathings, perispomeni, iota subscript).
;; For using a single monospaced font that also includes the Greek "extended"
;; characters, see the Iosevka font.
(when (eq system-type 'windows-nt)
  ;; Affects the current/initial frame.
  (set-face-attribute 'default nil
                      :family "JetBrains Mono"
                      :height 110)
  ;; Affects all frames created afterwards (including emacsclient frames).
  (add-to-list 'default-frame-alist
               '(font . "JetBrains Mono-11"))
  ;; Route all Greek (basic + Extended polytonic) to DejaVu Sans Mono.
  ;; Modifies the default fontset, so applies globally across frames.
  (set-fontset-font t 'greek             (font-spec :family "DejaVu Sans Mono"))
  (set-fontset-font t '(#x1F00 . #x1FFF) (font-spec :family "DejaVu Sans Mono")))

;; ============================================================
;; Encoding & Input Method
;; ============================================================

(set-language-environment "UTF-8")
(prefer-coding-system        'utf-8-unix)
(set-default-coding-systems  'utf-8-unix)
(set-keyboard-coding-system  'utf-8-unix)

(require 'macgreek)
(setq default-input-method "mac-greek")

;; ============================================================
;; Window Movement
;; ============================================================

;; ;; Shift-arrow and Meta-arrow both navigate between windows.
;; (windmove-default-keybindings)
;; (windmove-default-keybindings 'meta)

;; Automatically switch focus to the help window when it opens
;;(setq help-window-select t)

;; Enable Winner mode to easily undo/redo window layout changes
(winner-mode 1)

;; Reverse direction with C-x O.
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))

;; ============================================================
;; Project Root Markers
;; ============================================================

;; A .project.el or .projectile file marks a project root for project.el,
;; which means xref-find-references and friends know where to look.
(setq project-vc-extra-root-markers '(".project.el" ".projectile"))

;; ============================================================
;; Xref
;; ============================================================

(setq xref-auto-jump-to-first-xref       'move
      xref-auto-jump-to-first-definition t)

;;============================ Various packages ===============

;; (use-package alabaster-themes
;;   :vc (:url "https://github.com/vedang/alabaster-themes")
;;   :ensure t
;;   :config
;;   ;; Load the light theme
;;   (load-theme 'alabaster-themes-dark-mono t)
;;   ;; Interactively select a theme
;;   :commands (alabaster-themes-select))

;; ;; Has to be put first: installation of the compatibility libraty via Git
;; (use-package compat
;;   :vc (:url "https://github.com/emacs-compat/compat.git"))

;; ;; ;; 1. Vertico
;; (use-package vertico
;;   :vc (:url "https://github.com/minad/vertico.git")
;;   :init
;;   (vertico-mode))

;; ;; 2. Orderless
;; (use-package orderless
;;   :vc (:url "https://github.com/oantolin/orderless.git")
;;   :custom
;;   (completion-styles '(orderless basic))
;;   (completion-category-defaults nil)
;;   (completion-category-overrides '((file (styles partial-completion)))))

;; ;; 3. Marginalia
;; (use-package marginalia
;;   :vc (:url "https://github.com/minad/marginalia.git")
;;   :init
;;   (marginalia-mode))

;; ;; 4. Consult
;; (use-package consult
;;   :vc (:url "https://github.com/minad/consult.git"))

;; (fido-vertical-mode 1)
;; (setq completion-styles '(flex basic)
;;       completion-category-overrides '((file (styles partial-completion))))

(use-package alabaster-themes
  :ensure t)


;; ;
;; ============================================================
;; eat
;; ============================================================

;; Cross-platform pure-Elisp terminal emulator. Works over TRAMP and
;; on Windows without any native compilation. Replaces ansi-term/vterm.
(use-package eat
  :ensure t
  :hook
  ;; Integration with eshell for visual commands (vim, htop, etc.):
  (eshell-load . eat-eshell-mode)
  (eshell-load . eat-eshell-visual-command-mode)
  :custom
  ;; Smoother but slightly slower; lower for higher throughput.
  (eat-kill-buffer-on-exit t)
  ;; Make `q' quit read-only buffers like in less/man.
  (eat-enable-yank-to-terminal t))

;; Eat's own terminfo requires a tic-compiled entry on every remote host,
;; which is awkward to install across machines (especially without sudo).
;; Advertising as xterm-256color uses terminfo that exists everywhere.
(setq eat-term-name "xterm-256color")

;; ============================================================
;; Tree-sitter
;; ============================================================

(require 'treesit)

;; Grammar sources — built-in treesit (Emacs 29+)
(setq treesit-language-source-alist
      '((lua  "https://github.com/tree-sitter-grammars/tree-sitter-lua" "v0.3.0")
        (yang "https://github.com/Hubro/tree-sitter-yang")))

;; Remap legacy mode → ts-mode (only where there is both legacy mode and ts-mode)
;;(add-to-list 'major-mode-remap-alist '(lua-mode . lua-ts-mode))

;; Open Lua files immediately in ts-mode
;;(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))

(dolist (entry '((bash . (sh-mode   . bash-ts-mode))
                 (cpp  . (c++-mode  . c++-ts-mode))
                 (c    . (c-mode    . c-ts-mode))
                 (lua  . (lua-mode  . lua-ts-mode))))
  (when (treesit-ready-p (car entry) t)        ; t = silently, without warning
    (add-to-list 'major-mode-remap-alist (cdr entry))))

(use-package yang-mode
  :ensure t
  :mode "\\.yang\\'")

;; ============================================================
;; Eglot + clangd
;; ============================================================

(require 'eglot)

;; Connect asynchronously; never block the UI on LSP handshake.
(setq eglot-sync-connect nil)

;; Disable the events log buffer — over a long session it consumes
;; significant memory and slows the editor noticeably.
(setq eglot-events-buffer-size 0)

;; Inlay hints are visually noisy and can be slow; off by default.
(setq eglot-ignored-server-capabilities '(:inlayHintProvider))

;; clangd command line. Matches the flags used in the Neovim setup.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-mode c++-ts-mode c-mode c-ts-mode)
                 . ("clangd"
                    "--background-index"
                    "--clang-tidy"
                    "--log=error"
                    "--completion-style=detailed"
                    "--header-insertion=iwyu"
                    "--j=4"
                    "--pch-storage=memory"
                    "--all-scopes-completion"
                    "--limit-references=0"))))

;; Auto-start eglot for the relevant modes.
(dolist (hook '(c-mode-hook
                c++-mode-hook
                c-ts-mode-hook
                c++-ts-mode-hook
                python-mode-hook
                python-ts-mode-hook))
  (add-hook hook #'eglot-ensure))


;; ----------------------------------------------------------------
;; clang-format integration via clangd's LSP formatter.
;;
;; The .clang-format file is read by clangd, not by Emacs. So:
;;
;;   1. c-ts-mode's live indentation defaults to 2 spaces. Set
;;      `c-ts-mode-indent-offset' to 4 so TAB and RET produce a
;;      result that matches what clang-format would emit. This is
;;      a hint for live typing only; .clang-format remains the
;;      single source of truth.
;;
;;   2. On save, delegate to `eglot-format-buffer', which routes
;;      through clangd and therefore honours .clang-format fully
;;      (style, column limit, brace placement, etc.).
;;
;;   3. `C-c f' triggers eglot-format manually on the region or
;;      buffer.
;; ----------------------------------------------------------------

(setq-default indent-tabs-mode nil)
(setq c-ts-mode-indent-offset 4)

(defun cac/eglot-format-on-save ()
  "Enable clangd-driven formatting on save in the current buffer."
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))

;; (dolist (hook '(c-ts-mode-hook c++-ts-mode-hook))
;;   (add-hook hook #'cac/eglot-format-on-save))

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c f") #'eglot-format))

(require 'cl-lib)

(defvar my/imenu-kind-order
  '("Namespace" "Class" "Struct" "Interface" "Enum" "EnumMember"
    "Constructor" "Method" "Function" "Field" "Property"
    "Constant" "Variable" "TypeParameter")
  "Preferred order of imenu kind headers; unlisted kinds go last.")

(defun my/imenu-kind-rank (kind)
  "Rank of KIND in the preferred order (unknown kinds last)."
  (or (seq-position my/imenu-kind-order kind #'equal)
      most-positive-fixnum))

(with-eval-after-load 'eglot
  (defun my/eglot-imenu-by-kind ()
    "Eglot imenu index regrouped under kind headers, in a sensible order.
Eglot returns a flat index whose entries carry the kind in the
`imenu-kind' text property; this wraps it into a nested alist so
imenu-list shows collapsible kind headers."
    (let ((flat (eglot-imenu))
          (groups nil))
      (cl-labels
          ((collect (entries)
             (dolist (e entries)
               (if (imenu--subalist-p e)
                   (collect (cdr e))
                 (let* ((name (car e))
                        (kind (or (get-text-property 0 'imenu-kind name) "Other"))
                        (cell (assoc kind groups)))
                   (if cell
                       (setcdr cell (cons e (cdr cell)))
                     (push (cons kind (list e)) groups)))))))
        (collect flat))
      (setq groups
            (mapcar (lambda (g) (cons (car g) (nreverse (cdr g)))) groups))
      (sort groups
            (lambda (a b)
              (< (my/imenu-kind-rank (car a))
                 (my/imenu-kind-rank (car b)))))))

  (defun my/eglot-enable-kind-imenu ()
    "Group imenu by symbol kind in Eglot-managed buffers."
    (when (eglot-managed-p)
      (setq-local imenu-create-index-function #'my/eglot-imenu-by-kind)))

  (add-hook 'eglot-managed-mode-hook #'my/eglot-enable-kind-imenu))

(setq imenu-list-auto-resize t)

;; ============================================================
;; Flymake (diagnostics)
;; ============================================================

;; Wait 0.5s after typing stops before querying diagnostics, so we
;; do not spam clangd with requests.
(setq flymake-no-changes-timeout 0.5)

(with-eval-after-load 'flymake
  (define-key flymake-mode-map (kbd "M-n") #'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") #'flymake-goto-prev-error))

;; Popup diagnostics inline (useful in terminal Emacs).
(require 'flymake-popon nil 'noerror)

;; ============================================================
;; Other Modes & File Associations
;; ============================================================

;; Most JS config files are 2-space indented.
(setq js-indent-level 2)

(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

(when (and (eq system-type 'windows-nt)
           (require 'plantuml-mode nil 'noerror))
  (setq plantuml-jar-path "C:/Users/chryssoc/Applications/plantuml-1.2023.12.jar"
        plantuml-default-exec-mode 'jar))

(use-package imenu-list
  :ensure t
  :bind ("C-c M" . imenu-list-smart-toggle)
  :custom
  (imenu-list-focus-after-activation t)
  (imenu-list-auto-resize t)
  (imenu-list-position 'right))

;; ============================================================
;; Org Mode
;; ============================================================

(setq org-todo-keywords
      '((sequence "TODO(t!)" "VERIFY(v!)" "INPROGRESS(i!)" "WAIT(w@/!)"
                  "|" "DONE(d!)" "BLOCKED(b!)")))

;; ============================================================
;; Custom Commands
;; ============================================================

(defun grep-word-under-dir (dir)
  "Grep the symbol at point under DIR."
  (let* ((cur-word (thing-at-point 'symbol))
         (args (concat "grep -nH --null"
                       " --exclude-dir={[uU]nittests,[tT]est,build,.hg,.git}"
                       " --exclude='*.sw?' --exclude='#*#' --exclude='*~'"
                       " --exclude=tags --exclude='*.orig'"
                       " -e '\\<" cur-word "\\>' -rI " dir)))
    (grep args)))

(defun grep-word-under-curr-dir ()
  "Grep symbol at point under the current working directory."
  (interactive)
  (grep-word-under-dir "."))

(defun grep-word-under-parent-dir ()
  "Grep symbol at point under the parent of the current directory."
  (interactive)
  (grep-word-under-dir ".."))

(defun occur-curr-word ()
  "Run `occur' for the symbol at point."
  (interactive)
  (occur (thing-at-point 'symbol)))

(defun grep-cpp-def ()
  "Grep for `::SYMBOL' (a likely C++ definition) where SYMBOL is at point."
  (interactive)
  (let* ((cur-word (thing-at-point 'symbol))
         (args (concat "grep -nH --null"
                       " --exclude-dir={[uU]nittests,[tT]est,build,.hg,.git}"
                       " --exclude='*.sw?' --exclude='#*#' --exclude='*~'"
                       " --exclude=tags --exclude='*.orig'"
                       " -e '::" cur-word "\\>' -rI .")))
    (grep args)))

(defun goto-definition ()
  "Heuristic jump to a C/C++ function definition for the symbol at point."
  (interactive)
  (let* ((cur-word (thing-at-point 'symbol t))
         (regexp (concat "\\w\\s-+\\(\\w+::\\)?" cur-word
                         "(\\|\\(\\*\\|>\\|&\\)"
                         "\\(\\s-*\\|\\(\\s-*\\w+::\\)\\)"
                         cur-word "(")))
    (unless (re-search-forward regexp nil t)
      (re-search-backward regexp))))

;; Emulate Vim's C-a / C-x for incrementing/decrementing numbers.
(defun increment-number-at-point ()
  "Increment the number at point."
  (interactive)
  (let ((old-point (point)))
    (unwind-protect
        (progn
          (skip-chars-backward "0-9")
          (or (looking-at "[0-9]+")
              (error "No number at point"))
          (replace-match
           (number-to-string (1+ (string-to-number (match-string 0))))))
      (goto-char old-point))))

(defun decrement-number-at-point ()
  "Decrement the number at point."
  (interactive)
  (let ((old-point (point)))
    (unwind-protect
        (progn
          (skip-chars-backward "0-9")
          (or (looking-at "[0-9]+")
              (error "No number at point"))
          (replace-match
           (number-to-string (1- (string-to-number (match-string 0))))))
      (goto-char old-point))))

;; ============================================================
;; Aliases & Keybindings
;; ============================================================

(defalias 'qrr 'query-replace-regexp)
(defalias 'fr  'fill-region)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'fnd 'find-name-dired)

;; --- Default bindings that doesn't reach terminal ---
(keymap-global-set "C-c r" #'query-replace-regexp) ; instead C-M-%
(keymap-global-set "C-c /" #'comment-line)         ; instead C-x C-;
(keymap-global-set "C-c m" #'imenu)

;; Note M-% (query-replace) and M-; (comment-dwim)
;; do work already, so they don't need rebinding.

(global-set-key (kbd "C-c C-r") #'recentf-open-files)
(global-set-key (kbd "C-c d")   #'goto-definition)
(global-set-key (kbd "C-c g .") #'grep-word-under-curr-dir)
(global-set-key (kbd "C-c g p") #'grep-word-under-parent-dir)
(global-set-key (kbd "C-c c o") #'occur-curr-word)
(global-set-key (kbd "C-c t")   #'grep-cpp-def)
;;(global-set-key (kbd "C-c r")   #'revert-buffer) ;; reserved for query-replace-regexp
(global-set-key (kbd "C-c F")   #'find-name-dired) ;; C-c f is taken by eglot format region
(global-set-key (kbd "C-c +")   #'increment-number-at-point)
(global-set-key (kbd "C-c -")   #'decrement-number-at-point)

;; Readline-style word deletion. C-w deletes the previous word
;; instead of killing the region; kill-region moves to C-c w.
(global-set-key (kbd "C-w")   #'backward-kill-word)
(global-set-key (kbd "C-c w") #'kill-region)

;; Search paths used by ff-find-other-file. Mirrors the equivalent
;; Vim 'path' setting:
;;   set path=include/**,src/**,export/**,source/**,...
(setq cc-search-directories
      '("$PWD/include/*/*" "$PWD/export/*" "$PWD/src/*/*" "$PWD/source/*/*"
        "../include/*/*"   "../export/*/*" "../src/*"    "../source/*" "."))


;; --------------------------------------------------------------
;; Switch between .cpp/.h pairs in C and C++ buffers. Prefer
;; clangd's accurate textDocument/switchSourceHeader request when
;; eglot is active; fall back to the built-in ff-find-other-file
;; heuristic when not.
;; --------------------------------------------------------------

(defun my/clangd-switch-source-header ()
  "Switch between source and header using clangd's LSP extension."
  (interactive)
  (let ((server (and (fboundp 'eglot-current-server)
                     (eglot-current-server))))
    (unless server
      (user-error "Eglot is not active in this buffer"))
    (let ((other (eglot--request
                  server
                  :textDocument/switchSourceHeader
                  (eglot--TextDocumentIdentifier))))
      (if (and (stringp other) (not (string-empty-p other)))
          (find-file (eglot--uri-to-path other))
        (user-error "Clangd found no matching source/header file")))))

(defun my/switch-source-header ()
  "Switch between source and header files in C/C++.
Use clangd via eglot when available; fall back to ff-find-other-file."
  (interactive)
  (if (and (fboundp 'eglot-current-server)
           (eglot-current-server))
      (my/clangd-switch-source-header)
    (ff-find-other-file)))

;; Bind C-c o to my/switch-source-header in every relevant keymap.
;; Build each (define-key ...) form at loop time via backquote, so
;; the map symbol is interpolated as a literal — no closure capture
;; pitfalls.
(defun my/define-key-in-loaded-maps (key command map-specs)
  "Bind KEY to COMMAND in each (FEATURE . MAP-SYMBOL) of MAP-SPECS,
deferring each binding until its FEATURE is loaded."
  (pcase-dolist (`(,feature ,map-sym) map-specs)
    (eval-after-load feature
      `(define-key ,map-sym ,key ',command))))

(my/define-key-in-loaded-maps
 (kbd "C-c o") 'my/switch-source-header
 '((cc-mode    c-mode-base-map)
   (c-ts-mode  c-ts-base-mode-map)))

(defun my/c++-setup ()
  (setq fill-column 100)
  (display-fill-column-indicator-mode 1)
  ;; Disable electric indent for trigger characters
  (electric-indent-local-mode -1)
  ;; Bind Return to indent the new line
  ;;(local-set-key (kbd "RET") #'newline-and-indent))
  (local-set-key (kbd "RET") #'newline-and-indent))

(add-hook 'c++-mode-hook #'my/c++-setup)
;; Apply to both C and C++ tree-sitter modes
(add-hook 'c-ts-mode-hook #'my/c++-setup)
(add-hook 'c++-ts-mode-hook #'my/c++-setup)

(defun my/c++-ts-namespace-flush-left ()
  "Declaration/definitions directly inside a namespace start with zero indentation."
  (setf (alist-get 'cpp treesit-simple-indent-rules)
        (append
         '(((n-p-gp nil nil "namespace_definition") grand-parent 0)
           ;; optionally the same for extern "C" { ... }:
           ((n-p-gp nil nil "linkage_specification") grand-parent 0))
         (alist-get 'cpp treesit-simple-indent-rules))))

(add-hook 'c++-ts-mode-hook #'my/c++-ts-namespace-flush-left)

(add-hook 'c++-ts-mode-hook
          (lambda ()
            (setq-local treesit-font-lock-level 2)
            (treesit-font-lock-recompute-features)))

;; ============================================================
;; OSC 52 Clipboard Integration
;; (sends yanks from a terminal session to the host clipboard)
;; ============================================================

(defun osc52-send-string (str)
  "Send STRING to the terminal clipboard via OSC 52."
  (let ((encoded (base64-encode-string (encode-coding-string str 'utf-8) t)))
    (send-string-to-terminal (concat "\e]52;c;" encoded "\a"))))

(defun osc52-copy-to-clipboard (text)
  "Copy TEXT to the system clipboard via OSC 52."
  (osc52-send-string text))

;; Activate OSC 52 only on TTY frames; GUI frames use the native
;; selection mechanism of the OS (e.g., w32 clipboard on Windows).
(unless (display-graphic-p)
  (setq interprogram-cut-function #'osc52-copy-to-clipboard))

(setq select-enable-clipboard t)


;; ============================================================
;; Customize (managed by Emacs — keep at the bottom)
;; ============================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(aio alabaster-themes eat gruvbox-theme imenu-list json-mode polymode protobuf-mode request
         shell-maker transient yaml yang-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; ====================================================================
;;  TRAMP
;;  ===================================================================
;; Windows GUI Emacs runs ssh.exe via pipes, so OpenSSH refuses to allocate
;; a pty and TRAMP's prompt detection times out. -tt forces pty allocation.
;; Not needed (and harmful) on Linux/macOS, where TRAMP's defaults work.
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(when (eq system-type 'windows-nt)
  (with-eval-after-load 'tramp
    (add-to-list 'tramp-connection-properties
                 (list (regexp-quote "/ssh:")
                       "login-args"
                       '(("-tt")
                         ("-l" "%u")
                         ("-p" "%p")
                         ("%c")
                         ("-e" "none")
                         ("%h"))))))

;; -------- TRAMP performance settings --------

;; Prefer the ssh method on Windows (works with native ssh.exe).
;; If you switch to PuTTY for connection sharing, use 'plink' instead.
(setq tramp-default-method "ssh")

;; Skip probing for Git, SVN, Bzr, etc. — we only ever use Mercurial.
(setq vc-handled-backends '(Git Hg))

;; No remote backup files, no remote lockfiles.
(setq backup-enable-predicate
      (lambda (name)
        (and (normal-backup-enable-predicate name)
             (not (file-remote-p name 'method)))))
(setq remote-file-name-inhibit-locks t)

;; Cache remote file properties aggressively.
(setq remote-file-name-inhibit-cache nil)    ; default; do not flip to t for speed
(setq tramp-completion-reread-directory-timeout nil)

;; Default verbosity is enough for normal use; raise to 6 when debugging.
(setq tramp-verbose 3)

;; Use /usr/bin/bash automatically whenever `shell' is invoked from a
;; buffer whose default-directory is on a remote host. Local `shell'
;; invocations on Windows continue to use whatever shell-file-name is
;; configured locally (cmd.exe, PowerShell, MSYS2 bash, etc.).
(with-eval-after-load 'tramp
  (connection-local-set-profile-variables
   'remote-bash-profile
   '((explicit-shell-file-name . "/usr/bin/bash")
     (explicit-bash-args       . ("-l" "-i"))))

  (connection-local-set-profiles
   '(:application tramp)
   'remote-bash-profile))


;; -------   Org Mode -----------------------------------

;; Targeted silencer (Solution A): handles the case where some other
;; code path eventually reaches sh-set-shell.
(with-eval-after-load 'sh-script
  (advice-add 'sh-set-shell :around
              (lambda (orig &rest args)
                (let ((inhibit-message t))
                  (apply orig args)))))

;; Avoid invoking that path at all when typing in Org buffers (Solution B).
;; Plain Enter in Org just inserts a newline. Disabling electric-indent
;; locally makes org-return skip newline-and-indent, which in turn
;; skips org-edit-src-code's temp-buffer dance for src blocks.
(add-hook 'org-mode-hook
          (lambda () (electric-indent-local-mode -1)))

(provide 'init)
;;; init.el ends here

;; Use vertical splits for side-by-side diffs, mimicking Neovim's behavior
(setq ediff-split-window-function 'split-window-horizontally)

;; Buffer layout

(add-to-list 'display-buffer-alist
             '("\\*\\(grep\\|Buffer List\\)\\*"
               (display-buffer-reuse-window
                display-buffer-below-selected)
               (window-height . 0.3)))
