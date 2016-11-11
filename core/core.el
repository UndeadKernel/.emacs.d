;;; core.el --- The heart of the beast
;;
;;; Naming conventions:
;;
;;   doom-...     A public variable/constant or function
;;   doom--...    An internal variable or function (non-interactive)
;;   doom/...     An autoloaded interactive function
;;   doom:...     An ex command
;;   doom|...     A hook
;;   doom*...     An advising function
;;   ...!         Macro, shortcut alias or subst defun
;;   @...         Autoloaded interactive lambda macro for keybinds
;;
;;; Autoloaded functions are in {core,modules}/defuns/defuns-*.el

;; Premature optimization for faster startup
(setq-default gc-cons-threshold 339430400
              gc-cons-percentage 0.6)

(defalias '! 'eval-when-compile)

(defconst doom-emacs-dir    (! (expand-file-name user-emacs-directory)))
(defconst doom-core-dir     (! (expand-file-name "core" doom-emacs-dir)))
(defconst doom-modules-dir  (! (expand-file-name "modules" doom-emacs-dir)))
(defconst doom-private-dir  (! (expand-file-name "private" doom-emacs-dir)))
(defconst doom-packages-dir (! (expand-file-name (format ".cask/%s.%s/elpa" emacs-major-version emacs-minor-version) doom-emacs-dir)))
(defconst doom-ext-dir      (! (expand-file-name "ext" doom-emacs-dir)))
(defconst doom-themes-dir   (! (expand-file-name "themes" doom-private-dir)))
(defconst doom-cache-dir
  (! (format "%s/cache/%s" doom-private-dir (system-name)))
  "Hostname-based elisp cache directories")

;; window-system is deprecated. Not on my watch!
(unless (boundp 'window-system)
  (defvar window-system (framep-on-display)))

;;
(defvar doom-unreal-buffers
  '("^ ?\\*.+" image-mode dired-mode reb-mode messages-buffer-mode
    tabulated-list-mode comint-mode magit-mode)
  "A list of regexps or modes whose buffers are considered unreal, and will be
ignored when using `doom:next-real-buffer' and `doom:previous-real-buffer' (or
killed by `doom/kill-unreal-buffers', or after `doom/kill-real-buffer').")

(defvar doom-cleanup-processes-alist
  '(("pry" . ruby-mode)
    ("irb" . ruby-mode)
    ("ipython" . python-mode))
  "An alist of (process-name . major-mode), that `doom:cleanup-processes' checks
before killing processes. If there are no buffers with matching major-modes, it
gets killed.")

(defvar doom-unicode-font
  (font-spec :family "DejaVu Sans Mono" :size 13)
  "Font to fall back to for unicode glyphs.")


;;
;; Load path
;;

(defvar doom--load-path load-path
  "Initial `load-path', so we don't clobber it on consecutive reloads.")

(defsubst --subdirs (path &optional include-self)
  (let ((result (if include-self (list path) (list))))
    (mapc (lambda (file)
            (when (file-directory-p file)
              (push file result)))
          (ignore-errors (directory-files path t "^[^.]" t)))
    result))

;; Populate the load-path manually; cask shouldn't be an internal dependency
(setq load-path
      (! (append (list doom-private-dir)
                 (--subdirs doom-core-dir t)
                 (--subdirs doom-modules-dir t)
                 (--subdirs doom-packages-dir)
                 (--subdirs (expand-file-name "../bootstrap" doom-packages-dir))
                 doom--load-path))
      custom-theme-load-path
      (! (append (--subdirs doom-themes-dir t)
                 custom-theme-load-path)))

;;
;; Core configuration
;;

;; UTF-8 as the default coding system, please
(set-charset-priority 'unicode)        ; pretty
(prefer-coding-system        'utf-8)   ; pretty
(set-terminal-coding-system  'utf-8)   ; pretty
(set-keyboard-coding-system  'utf-8)   ; perdy
(set-selection-coding-system 'utf-8)   ; please
(setq locale-coding-system   'utf-8)   ; with sugar on top

;; Backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))

;; Don't pester me package.el. Cask is my one and only.
(setq-default
 package--init-file-ensured t
 package-user-dir doom-packages-dir
 package-enable-at-startup nil
 package-archives
 '(("gnu"   . "http://elpa.gnu.org/packages/")
   ("melpa" . "http://melpa.org/packages/")
   ("org"   . "http://orgmode.org/elpa/")))

;; Core settings
(setq byte-compile-warnings              nil
      ad-redefinition-action            'accept      ; silence the advised function warnings
      apropos-do-all                     t
      compilation-always-kill            t           ; kill compl. process before spawning another
      compilation-ask-about-save         nil         ; save all buffers before compiling
      compilation-scroll-output          t           ; scroll with output while compiling
      confirm-nonexistent-file-or-buffer t
      delete-by-moving-to-trash          t
      echo-keystrokes                    0.02        ; show me what I type
      ediff-diff-options                 "-w"
      ediff-split-window-function       'split-window-horizontally  ; side-by-side diffs
      ediff-window-setup-function       'ediff-setup-windows-plain  ; no extra frames
      enable-recursive-minibuffers       nil         ; no minibufferception
      idle-update-delay                  5           ; update a little less often
      major-mode                        'text-mode
      ring-bell-function                'ignore      ; silence of the bells!
      save-interprogram-paste-before-kill nil
      sentence-end-double-space          nil
      ;; http://ergoemacs.org/emacs/emacs_stop_cursor_enter_prompt.html
      minibuffer-prompt-properties
      '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)
      ;; persistent bookmarks
      bookmark-save-flag                 t
      bookmark-default-file              (concat doom-cache-dir "/bookmarks")
      ;; Emacs backups have saved my life before
      history-length                     1000
      create-lockfiles                   nil
      ;; Remember undo history
      undo-tree-auto-save-history        nil
      undo-tree-history-directory-alist `(("." . ,(concat doom-cache-dir "/undo/"))))

(require 'f)

;; Backup settings
(let ((bkp-dir (concat doom-cache-dir "/backups/")))
  (unless (f-directory? bkp-dir)
    (f-mkdir bkp-dir))
  (setq make-backup-files       nil
        vc-make-backup-files    nil
        backup-by-copying       t ; No symbolic links
        backup-directory-alist  `((".*" . ,bkp-dir))
        delete-old-versions     t
        kept-new-versions       6
        kept-old-versions       2
        version-control         t))

;; Autosave settings
(let ((autosave-dir (concat doom-cache-dir "/autosaves/")))
  (unless (f-directory? autosave-dir)
    (f-mkdir autosave-dir))
  (setq auto-save-list-file-prefix autosave-dir
        auto-save-file-name-transforms `((".*" ,autosave-dir t))))

;;
;; Bootstrap
;;

(autoload 'use-package "use-package" "" nil 'macro)
(require 'core-defuns)
(unless (require 'autoloads nil t)
  (doom-reload-autoloads)
  (unless (require 'autoloads nil t)
    (error "Autoloads weren't generated! Run `make autoloads`")))

(use-package anaphora
  :commands (awhen aif acond awhile))

;; TODO: remove it if nothing is affected
;; (use-package persistent-soft
;;   :commands (persistent-soft-store
;;              persistent-soft-fetch
;;              persistent-soft-exists-p
;;              persistent-soft-flush
;;              persistent-soft-location-readable
;;              persistent-soft-location-destroy)
;;   :init (defvar pcache-directory (concat doom-cache-dir "/pcache/")))

(use-package async
  :commands (async-start
             async-start-process
             async-get
             async-wait
             async-inject-variables))

(use-package json
  :commands (json-read-from-string json-encode json-read-file json-read))

(use-package help-fns+ ; Improved help commands
  :commands (describe-buffer describe-command describe-file
             describe-keymap describe-option describe-option-of-type))

;; TODO: do we need smex?
;; (use-package smex
;;   :commands (smex smex-major-mode-commands)
;;   :config
;;   (setq smex-completion-method 'ivy
;;         smex-save-file (concat doom-cache-dir "/smex-items"))
;;   (smex-initialize))


;;
;; Automatic minor modes
;;

(defvar doom-auto-minor-mode-alist '()
  "Alist of filename patterns vs corresponding minor mode functions, see
`auto-mode-alist'. All elements of this alist are checked, meaning you can
enable multiple minor modes for the same regexp.")

(defun doom|enable-minor-mode-maybe ()
  "Check file name against `doom-auto-minor-mode-alist'."
  (when buffer-file-name
    (let ((name buffer-file-name)
          (remote-id (file-remote-p buffer-file-name))
          (alist doom-auto-minor-mode-alist))
      ;; Remove backup-suffixes from file name.
      (setq name (file-name-sans-versions name))
      ;; Remove remote file name identification.
      (when (and (stringp remote-id)
                 (string-match-p (regexp-quote remote-id) name))
        (setq name (substring name (match-end 0))))
      (while (and alist (caar alist) (cdar alist))
        (if (string-match (caar alist) name)
            (funcall (cdar alist) 1))
        (setq alist (cdr alist))))))

(add-hook 'find-file-hook 'doom|enable-minor-mode-maybe)

;;
(add-hook! emacs-startup
  ;; We add this to `after-init-hook' to allow errors to stop it
  (defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
    "Prevent annoying \"Active processes exist\" query when you quit Emacs."
    (cl-flet ((process-list ())) ad-do-it)))

(provide 'core)
;;; core.el ends here
