;;; init.el --- Christos's Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration centred on C/C++ development with
;; tree-sitter major modes, Eglot + clangd, and clang-format on save.
;;
;; Daily C++ editing is local Emacs.  Remote trees on labbbn10 (~200 ms
;; RTT) are visited via TRAMP.  emacsclient on the lab box is only for
;; an emergency tty session, not the default workflow.

;; ============================================================
;; Core Performance & I/O
;; ============================================================

;; Increase data Emacs reads from processes to 1MB. Crucial so that
;; clangd does not bottleneck on LSP traffic.
(setq read-process-output-max (* 1024 1024))

;; Lighter UI / scrolling, helpful in terminal and over SSH.
;; A short jit-lock defer avoids fontifying on the same command that
;; changed the buffer (0 used to hitch on a remote tty).
(setq fast-but-imprecise-scrolling t
      jit-lock-defer-time          0.05
      redisplay-skip-fontification-on-input t
      cursor-in-non-selected-windows nil
      recenter-redisplay           nil) ; don't flash on C-l in terminal


;; ============================================================
;; Garbage Collection
;; ============================================================

;; High threshold during startup, lower it once loaded.
;; Consider the `gcmh' package for adaptive handling later.
(setq gc-cons-threshold (* 100 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024))))

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

;; LOCALAPPDATA is unset on Ubuntu; fall back to user-emacs-directory.
(setq org-persist-directory
      (expand-file-name
       "org-persist"
       (or (and (eq system-type 'windows-nt)
                (getenv "LOCALAPPDATA")
                (expand-file-name "emacs" (getenv "LOCALAPPDATA")))
           user-emacs-directory)))

;; ============================================================
;; Package Management
;; ============================================================

;; Archives live in early-init.el so the automatic package-initialize
;; sees MELPA.  Do not call package-initialize here.

;; Extra load paths — abide to the user-emacs-directory on every platform
(add-to-list 'load-path (locate-user-emacs-file "elisp"))
(add-to-list 'custom-theme-load-path (locate-user-emacs-file "themes"))


;; ============================================================
;; UI & Editing Basics
;; ============================================================

(menu-bar-mode -1)

(setq inhibit-startup-screen t)

;; Don't request the terminal's "very visible" (blinking) cursor;
;; use the normal static cursor instead.
(setq visible-cursor nil)

(setq column-number-mode        t
      completion-ignore-case    t
      vc-follow-symlinks        t
      sentence-end-double-space nil
      isearch-lazy-count        t
      set-mark-command-repeat-pop t)

(setq-default fill-column 100)

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

(with-eval-after-load 'eglot
  (when (boundp 'eglot-mode-line-format)
    (setq eglot-mode-line-format
          (remove 'eglot-mode-line-pending-requests eglot-mode-line-format))))

(defun my/eglot-enable-semantic-tokens ()
  "Activate LSP semantic tokens as corrective layer over tree-sitter.
Skip remote buffers: the extra LSP traffic is not worth 200 ms RTT."
  (when (and (eglot-managed-p)
             (not (file-remote-p default-directory))
             (fboundp 'eglot-semantic-tokens-mode)
             (eglot-server-capable :semanticTokensProvider))
    (eglot-semantic-tokens-mode 1)))

(add-hook 'eglot-managed-mode-hook #'my/eglot-enable-semantic-tokens)

(setopt eldoc-idle-delay 1.0)
(setopt eldoc-documentation-strategy #'eldoc-documentation-default)  ; πρώτη ποὺ ἀπαντᾶ, στοπ
(setopt eldoc-echo-area-use-multiline-p nil)                          ; μία γραμμή, χωρὶς resize

(load-theme 'modus-vivendi t)

;; Tame the bell — only ring on genuine errors, not on minibuffer aborts.
(setq ring-bell-function
      (lambda ()
        (unless (memq this-command
                      '(isearch-abort abort-recursive-edit
                                      exit-minibuffer keyboard-quit))
          (ding))))


;; Greek glyphs are routed to DejaVu Sans Mono: JetBrains Mono lacks
;; the Greek Extended block (U+1F00..U+1FFF), where all polytonic
;; precomposed characters live (breathings, perispomeni, iota subscript).
;; For using a single monospaced font that also includes the Greek "extended"
;; characters, see the Iosevka font.
;; Affects the current/initial frame.
(defun my/setup-gui-fonts (&optional frame)
  "Configure fonts; runs only on graphical frames."
  (when (display-graphic-p frame)
    (with-selected-frame (or frame (selected-frame))
      (set-face-attribute 'default nil
                          :family "JetBrains Mono"
                          :height 130)
      ;; Route all Greek (basic + Extended polytonic) to DejaVu Sans Mono.
      (set-fontset-font t 'greek             (font-spec :family "DejaVu Sans Mono"))
      (set-fontset-font t '(#x1F00 . #x1FFF) (font-spec :family "DejaVu Sans Mono")))
    ;; One-shot: the settings are global, no need to re-run per frame.
    (remove-hook 'after-make-frame-functions #'my/setup-gui-fonts)))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/setup-gui-fonts)
  (when (display-graphic-p)
    (my/setup-gui-fonts)))

;; Wrap long lines visually in every buffer.
(global-visual-line-mode 1)


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
(windmove-default-keybindings)
(windmove-default-keybindings 'meta) ;; use 'meta to avoid clash with org-mode keybindings

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
(setq project-vc-extra-root-markers '(".hg" ".git" ".project.el" ".projectile"))

;; Remote project detection χωρὶς vc: τὸ vc-ignore-dir-regexp exclusion
;; (ἀπαραίτητο γιὰ τὸ save) μπλοκάρει καὶ τὸ project-try-vc μαζὶ μὲ τὰ
;; extra-root-markers του — ὁπότε ἀνιχνεύουμε μόνοι μας.
(defun my/project-remote-by-marker (dir)
  (when (file-remote-p dir)
    (when-let ((root (or (locate-dominating-file dir ".hg")
                         (locate-dominating-file dir ".git"))))
      (cons 'transient root))))

(add-hook 'project-find-functions #'my/project-remote-by-marker)

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

;; Route all xref/project file searches through ripgrep
(setq xref-search-program 'ripgrep)

;;(use-package vertico :ensure t :init (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom (completion-styles '(orderless basic)))

(use-package marginalia :ensure t :init (marginalia-mode 1))

;; ;; 4. Consult
;; (use-package consult
;;   :vc (:url "https://github.com/minad/consult.git"))
;; (use-package consult
;;   :ensure t
;;   :bind (("C-c n s" . my/notes-search)
;;          ("M-s l"   . consult-line)
;;          ("C-x b"   . consult-buffer)))

;; Search across all notes with ripgrep
;; (defun my/notes-search ()
;;   "Search the notes repository with ripgrep."
;;   (interactive)
;;   (consult-ripgrep "~/notes"))

;; Built-in, terminal-friendly, zero packages — different UX (inline ghost preview)
;; Skip on TRAMP buffers: CAPF/Eglot would add a round trip per pause.
(add-hook 'prog-mode-hook
          (lambda ()
            (unless (file-remote-p default-directory)
              (completion-preview-mode 1))))

;; (fido-vertical-mode 1)
;; (setq completion-styles '(flex basic)
;;       completion-category-overrides '((file (styles partial-completion))))

;; (use-package alabaster-themes
;;   :ensure t)

(use-package kkp
  :ensure t
  :hook (tty-setup . global-kkp-mode)
  :config
  ;; (setq kkp-alt-modifier 'alt) ;; use this if you want to map the Alt keyboard modifier to Alt in Emacs (and not to Meta)
  )

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

(dolist (entry '((bash . (sh-mode  . bash-ts-mode))
                 (cpp  . (c++-mode . c++-ts-mode))
                 (c    . (c-mode   . c-ts-mode))
                 (lua  . (lua-mode . lua-ts-mode))))
  (when (treesit-language-available-p (car entry))   ; C primitive, no require, no void-function
    (add-to-list 'major-mode-remap-alist (cdr entry))))

(use-package yang-mode
  :ensure t
  :mode "\\.yang\\'")

;; ============================================================
;; Eglot + clangd
;; ============================================================

;; clangd command line. Matches the flags used in the Neovim setup.
(with-eval-after-load 'eglot
  ;; Connect asynchronously; never block the UI on LSP handshake.
  (setq eglot-sync-connect nil)

  ;; Disable the events log buffer — over a long session it consumes
  ;; significant memory and slows the editor noticeably.
  (setq eglot-events-buffer-size 0)

  ;; Inlay hints are visually noisy and can be slow; off by default.
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider :documentOnTypeFormattingProvider))


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

;; Auto-start eglot only on local files.  A remote clangd handshake on
;; a 200 ms link freezes the session; use M-x eglot when you mean it.
(defun my/eglot-ensure-local ()
  (unless (file-remote-p default-directory)
    (eglot-ensure)))

(dolist (hook '(c-mode-hook
                c++-mode-hook
                c-ts-mode-hook
                c++-ts-mode-hook
                python-mode-hook
                python-ts-mode-hook))
  (add-hook hook #'my/eglot-ensure-local))


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
;;(setq c-ts-mode-indent-offset 4)

(use-package c-ts-mode
  :ensure nil
  :custom
  (c-ts-mode-indent-offset 4)
  )

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

(use-package desktop
  :ensure nil
  :if (and (display-graphic-p) (not (daemonp)))
  :custom
  (desktop-restore-eager 5)
  (desktop-auto-save-timeout 30)
  (desktop-load-locked-desktop 'check-pid)
  :config
  (desktop-save-mode 1))

(setq tab-bar-select-restore-windows nil)

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

(defun cc/soften-electric-indent ()
  "Keep new-line indentation but never reindent existing lines."
  (setq-local electric-indent-inhibit t))

(add-hook 'c++-ts-mode-hook #'cc/soften-electric-indent)

(defun my/c++-setup ()
  (setq fill-column 100)
  (display-fill-column-indicator-mode 1)

  ;; ;; Disable electric indent for trigger characters
  ;; (electric-indent-local-mode -1)
  ;; ;; Bind Return to indent the new line
  ;; ;;(local-set-key (kbd "RET") #'newline-and-indent))
  ;; (local-set-key (kbd "RET") #'newline-and-indent)
)

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
  "Copy TEXT to the system clipboard via OSC 52.
Cap the payload: a whole-buffer yank over SSH/tmux stalls the tty."
  (when (< (length text) 100000)
    (osc52-send-string text)))

;; Activate OSC 52 only on TTY frames; GUI frames use the native
;; selection mechanism of the OS (e.g., w32 clipboard on Windows).
(unless (display-graphic-p)
  (setq interprogram-cut-function #'osc52-copy-to-clipboard))

(setq select-enable-clipboard t)

(defun my/next-error-navigation-p (_buffer-name _alist)
  "Non-nil when `display-buffer' is called during next-error navigation."
  (memq this-command
        '(next-error previous-error first-error
          next-error-no-select previous-error-no-select
          compile-goto-error)))

(defun my/display-next-error-source (buffer alist)
  "Display source BUFFER by reusing a sensible existing window."
  (if (with-current-buffer (window-buffer (selected-window))
        (derived-mode-p 'compilation-mode))
      ;; From the *grep* window: reuse a window showing ordinary file
      ;; content.  `compilation-mode' and `xref--xref-buffer-mode' both
      ;; derive from `special-mode', so *grep* and *xref* are skipped.
      (let ((win (get-window-with-predicate
                  (lambda (w)
                    (and (not (window-dedicated-p w))
                         (with-current-buffer (window-buffer w)
                           (not (derived-mode-p 'special-mode))))))))
        (if win
            (progn (set-window-buffer win buffer) win)
          ;; No ordinary window available: pop up a new one rather than
          ;; clobbering a special buffer such as *xref*.
          (display-buffer-pop-up-window buffer alist)))
    ;; Navigating from within the source window: reuse it in place.
    (display-buffer-same-window buffer alist)))

(add-to-list 'display-buffer-alist
             '(my/next-error-navigation-p
               (display-buffer-reuse-window
                my/display-next-error-source)))

;; Use vertical splits for side-by-side diffs, mimicking Neovim's behavior
(setq ediff-split-window-function 'split-window-horizontally)

;; Buffer layout
(add-to-list 'display-buffer-alist
             '("\\*\\(grep\\|Buffer List\\)\\*"
               (display-buffer-reuse-window
                display-buffer-below-selected)
               (window-height . 0.3)))


;;;; TRAMP --------------------------------------------------------------------

(setq tramp-default-method "ssh")
(setq tramp-copy-size-limit (* 1 1024 1024))   ; inline ἕως 1MB

;; Visit files under their true name only on the clangd hosts: keeps
;; buffer-file-name in sync with compile_commands.json, but a global
;; t adds remote realpath/stat work on every visit.
(setq find-file-visit-truename nil)
(connection-local-set-profile-variables
 'remote-clangd-paths
 '((find-file-visit-truename . t)))

;; Ἀνάθεση τοῦ connection sharing στὸ ~/.ssh/config (ControlMaster/Persist),
;; ὄχι στὰ δικά του -o options. Emacs 30+ ὄνομα (πρώην
;; tramp-use-ssh-controlmaster-options, Tramp 2.7)· στὸν 31 εἶσαι καλυμμένος.
;; Τρίτη τιμή: 'suppress = ἀγνόησε ἐντελῶς τὸ ~/.ssh/config.
(setq tramp-use-connection-share nil)

;; Λιγότερα round trips σὲ κάθε save/stat πάνω στὸ ἀργὸ link.
(setq remote-file-name-inhibit-locks t          ; ὄχι .#lockfiles στὸ remote
      remote-file-name-inhibit-cache 300        ; ἐμπιστεύσου τὸ cache ἐπὶ 5 min
      remote-file-name-inhibit-auto-save-visited t
      auto-revert-remote-files nil              ; default; keep it explicit
      enable-remote-dir-locals nil
      tramp-verbose 2                           ; errors+warnings ὅσο στήνεσαι· μετὰ 1
      tramp-auto-save-directory                 ; #autosave# τοπικά
      (expand-file-name "tramp-autosave" user-emacs-directory))

;; Backups: ΝΑΙ, ἀλλὰ ἐκτὸς source tree.
;; Ὁ tramp-handle-find-backup-file-name προτιμᾶ αὐτὸ τὸ alist ἔναντι τοῦ
;; backup-directory-alist καί, ἐπειδὴ τὸ DIRECTORY εἶναι τοπικὸ ἀπόλυτο ὄνομα,
;; τοῦ προσθέτει τὸ prefix (method/user/host) τοῦ ἀρχείου. Ἄρα τὸ backup μένει
;; στὸν ἴδιο server (server-side cp, ὄχι μεταφορὰ πάνω ἀπ' τὸ δίκτυο), σὲ ἕνα
;; flat directory μὲ mangled ὀνόματα (/ -> !) — ἀόρατο στὸ grep τοῦ project.
(setq tramp-backup-directory-alist '(("." . "~/.cache/emacs/tramp-backups")))

;; Πλῆρες vc τοπικά (τὸ project σου εἶναι Hg)…
(setq vc-handled-backends '(Hg Git))

(setopt auto-revert-check-vc-info nil)

;; Capture the pristine value once, so repeated config reloads
;; cannot compound the regexp.
(defvar cc/vc-ignore-dir-regexp-pristine vc-ignore-dir-regexp
  "Value of `vc-ignore-dir-regexp' before any local modification.")

;; Ὅ,τι ἀγγίζει σύμβολα τοῦ ἴδιου τοῦ tramp περιμένει τὸ πρῶτο remote access.
(with-eval-after-load 'tramp
  ;; Τὸ PATH τοῦ remote χρήστη (~/.profile κ.λπ.) ὁρατὸ στὸ TRAMP.
  ;; Prepend: προηγεῖται τῶν defaults, ὥστε τὸ /data/chryssoc toolchain νὰ νικᾶ.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  ;; VC walks parents with many stats — disable on TRAMP names.
  ;; project.el still works via my/project-remote-by-marker.
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)"
                cc/vc-ignore-dir-regexp-pristine
                tramp-file-name-regexp)))

;; Τὸ M-x shell στὰ remote ὡς login bash (κληρονομεῖ πλῆρες περιβάλλον).
;; Τὸ --noediting εἶναι μέρος τῆς default τιμῆς τοῦ shell.el γιὰ bash: τὸ
;; comint δίνει pty, ὁπότε χωρὶς αὐτὸ ὁ bash ἀνοίγει readline καὶ γεμίζει τὸ
;; buffer μὲ escape sequences καὶ bracketed-paste σκουπίδια.
(connection-local-set-profile-variables
 'remote-bash-profile
 '((explicit-shell-file-name . "/usr/bin/bash")
   (explicit-bash-args       . ("--noediting" "-l" "-i"))))

;; Ἐφαρμογὴ ἀνὰ μηχάνημα, ὄχι σὲ σκέτο (:application tramp): ἐκεῖνο θὰ ἔπιανε
;; καὶ sudo:, docker: κ.λπ., ὅπου τὸ /usr/bin/bash μπορεῖ καὶ νὰ μὴν ὑπάρχει.
;; Τὸ :machine ταιριάζει κυριολεκτικὰ μὲ ὅ,τι γράφεις στὸ path — δὲν γίνεται
;; alias resolution — ὁπότε πρόσθεσε κάθε γραφὴ ποὺ χρησιμοποιεῖς (alias/FQDN/IP).
;; Ἕνα call ἀνὰ host: δεύτερο call ἀντικαθιστᾶ τὴ λίστα προφίλ, δὲν τὴν προσαρτᾶ.
(dolist (host '("labbbn10" "10.80.89.54"))
  (connection-local-set-profiles
   `(:application tramp :machine ,host)
   'remote-clangd-paths
   'remote-bash-profile))

(defun my/which-func-remote-add-log ()
  "Name the defun via `add-log-current-defun' in remote buffers.
`which-func-functions' runs before `which-function' consults Imenu, so this
keeps Eglot's synchronous textDocument/documentSymbol off the wire.  In
`c++-ts-mode' this dispatches to `treesit-add-log-current-defun', which parses
locally.  Returns nil elsewhere, leaving the normal Imenu path intact."
  (and (file-remote-p default-directory)
       (add-log-current-defun)))

(with-eval-after-load 'which-func
  (add-hook 'which-func-functions #'my/which-func-remote-add-log))

;; One remote call instead of tens for project/dir-locals roots.
(use-package tramp-hlo
  :ensure t
  :config (tramp-hlo-setup))


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

;; ============================================================
;; Customize (managed by Emacs — keep at the bottom)
;; ============================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-ts-indent-offset 4 nil nil "Customized with use-package c-ts-mode")
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
