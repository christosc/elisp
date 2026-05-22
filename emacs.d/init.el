;;; init.el --- Christos's Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration centred on C/C++ development with
;; tree-sitter major modes, Eglot + clangd, and clang-format on save.

;;; Code:

;; ============================================================
;; Core Performance & I/O
;; ============================================================

;; Increase data Emacs reads from processes to 1MB. Crucial so that
;; clangd does not bottleneck on LSP traffic.
(setq read-process-output-max (* 1024 1024))

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
(setq gc-cons-threshold (* 100 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; ============================================================
;; Native Compilation
;; ============================================================

(setq native-comp-jit-compilation              t
      package-native-compile                   t
      native-comp-async-report-warnings-errors nil
      native-comp-async-jobs                   (max 2 (/ (num-processors) 2)))

;; ============================================================
;; Package Management
;; ============================================================

(require 'package)
(package-initialize)

;; Extra load paths (Windows + Linux home).
(add-to-list 'load-path "C:/Users/chryssoc/AppData/Roaming/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; ============================================================
;; UI & Editing Basics
;; ============================================================

(menu-bar-mode -1)
(setq column-number-mode        t
      completion-ignore-case    t
      vc-follow-symlinks        t
      confirm-kill-emacs        'yes-or-no-p
      sentence-end-double-space nil
      isearch-lazy-count        t
      set-mark-command-repeat-pop t)

(setq-default fill-column 80)

;; Tag navigation should not be case-folded.
(set-default 'tags-case-fold-search nil)

;; Collect backups in one directory rather than scattering them.
(setq backup-directory-alist '(("." . "~/.saves")))

;; Server for emacsclient.
(setq server-use-tcp t)

;; Terminal mouse support.
(xterm-mouse-mode t)
(mouse-wheel-mode t)

;; on Windows set a dark theme
(if (display-graphic-p)
    ;; GUI (usually your Windows instance)
    (load-theme 'wombat t))

;; Tame the bell — only ring on genuine errors, not on minibuffer aborts.
(setq ring-bell-function
      (lambda ()
        (unless (memq this-command
                      '(isearch-abort abort-recursive-edit
                                      exit-minibuffer keyboard-quit))
          (ding))))

;; Recent files.
(recentf-mode 1)
(setq recentf-max-menu-items  25
      recentf-max-saved-items 25)

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

(prefer-coding-system        'utf-8-unix)
(set-default-coding-systems  'utf-8-unix)
(set-keyboard-coding-system  'utf-8-unix)

(require 'macgreek)
(setq default-input-method "mac-greek")

;; ============================================================
;; Window Movement
;; ============================================================

;; Shift-arrow and Meta-arrow both navigate between windows.
(windmove-default-keybindings)
(windmove-default-keybindings 'meta)

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

;; ============================================================
;; Tree-sitter
;; ============================================================

(require 'treesit)

(setq treesit-language-source-alist
      '((c          . ("https://github.com/tree-sitter/tree-sitter-c"))
        (cpp        . ("https://github.com/tree-sitter/tree-sitter-cpp"))
        (python     . ("https://github.com/tree-sitter/tree-sitter-python"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))))


;; Pin to ABI 14 grammars whenever the running Emacs cannot load ABI 15.
;; Self-adjusts if a future Emacs upgrade lifts the ABI ceiling.
(when (and (fboundp 'treesit-library-abi-version)
           (< (treesit-library-abi-version) 15))
  (setq treesit-language-source-alist
        '((c   "https://github.com/tree-sitter/tree-sitter-c"   "v0.23.2")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4"))))

;; Manual install of grammars only:
;;   M-x treesit-install-language-grammar RET <lang> RET
(setq treesit-auto-install nil)

;; Route mainstream programming modes through their tree-sitter variants.
(setq major-mode-remap-alist
      '((c-mode      . c-ts-mode)
        (c++-mode    . c++-ts-mode)
        (python-mode . python-ts-mode)
        (sh-mode     . bash-ts-mode)))

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

(global-set-key (kbd "C-x C-r") #'recentf-open-files)
(global-set-key (kbd "C-c d")   #'goto-definition)
(global-set-key (kbd "C-c g .") #'grep-word-under-curr-dir)
(global-set-key (kbd "C-c g p") #'grep-word-under-parent-dir)
(global-set-key (kbd "C-c c o") #'occur-curr-word)
(global-set-key (kbd "C-c t")   #'grep-cpp-def)
(global-set-key (kbd "C-c r")   #'revert-buffer)
(global-set-key (kbd "C-c F")   #'find-name-dired) ;; C-c f is taken by eglot format region
(global-set-key (kbd "C-c o")   #'ff-find-other-file)
(global-set-key (kbd "C-c +")   #'increment-number-at-point)
(global-set-key (kbd "C-c -")   #'decrement-number-at-point)
(global-set-key (kbd "<f5>")    #'call-last-kbd-macro)
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

;; ============================================================
;; OSC 52 Clipboard Integration
;; (sends yanks from a terminal session to the host clipboard)
;; ============================================================

(defun osc52-send-string (string)
  "Send STRING to the terminal clipboard via OSC 52."
  (let ((encoded (base64-encode-string string t)))
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
;; Private definitions (host-specific, not in version control)
;; ============================================================

(let ((private-file "private.el"))
  (if (locate-file private-file load-path)
      (progn
        (message "Loading private.el")
        (load private-file))
    (message "No file private.el found")))

;; ============================================================
;; Customize (managed by Emacs — keep at the bottom)
;; ============================================================

(custom-set-variables
 '(custom-safe-themes
   '("d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7"
     "b1a691bb67bd8bd85b76998caf2386c9a7b2ac98a116534071364ed6489b695d"
     "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838"
     "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7"
     default))
 '(diff-switches "-u")
 '(package-selected-packages
   '(company corfu eglot-copilot eldoc-box gruvbox-theme markdown-mode
             olivetti protobuf-mode yaml yaml-mode zenburn-theme))
 '(package-vc-selected-packages
   '((flymake-popon :vc-backend Git
                    :url "https://github.com/doomelpa/flymake-popon.git")
     (eldoc-box    :vc-backend Git
                   :url "https://github.com/casouri/eldoc-box.git")
     (corfu        :vc-backend Git
                   :url "https://github.com/minad/corfu")
     (olivetti     :vc-backend Git
                   :url "https://github.com/rnkn/olivetti"))))

(custom-set-faces)


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
(setq vc-handled-backends '(Hg))

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

(provide 'init)
;;; init.el ends here
