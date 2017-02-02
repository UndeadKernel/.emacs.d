;;; core-workgroups.el

;; I use workgroups to accomplish two things:
;;   1. Vim-like tab emulation (type :tabs to see a list of tabs -- maybe I'll
;;      add some code to make a permanent frame header to display these some
;;      day)
;;   2. Session persistence
;;   3. Tab names reflect the project open in them, unless they've been
;;      explicitly renamed

(defvar doom-wg-frames '()
  "A list of all the frames opened as separate workgroups. See
defuns/defuns-workgroups.el.")

(defvar doom-wg-names '()
"Keeps track of the fixed names for workgroups (set with :tabrename), so that
these workgroups won't be auto-renamed.")

(defconst doom-wg-perpetual "perpetual"
  "Name of the session that will be used to perpetually store a tab configuration")

(use-package workgroups2
  :when window-system
  :init
  (setq-default
   wg-session-file (concat doom-cache-dir "/workgroups/last")
   wg-workgroup-directory (concat doom-cache-dir "/workgroups/")
   wg-first-wg-name "*untitled*"
   wg-session-load-on-start nil
   wg-mode-line-display-on nil
   wg-mess-with-buffer-list nil
   wg-emacs-exit-save-behavior 'save ; Options: 'save 'ask nil
   wg-workgroups-mode-exit-save-behavior 'save
   wg-log-level 0

   ;; NOTE: Some of these make workgroup-restoration unstable
   wg-restore-mark t
   wg-restore-frame-position t
   wg-restore-remote-buffers nil
   wg-restore-scroll-bars nil
   wg-restore-fringes nil
   wg-restore-margins nil
   wg-restore-point-max t ; Throws silent errors if non-nil

   wg-list-display-decor-divider " "
   wg-list-display-decor-left-brace ""
   wg-list-display-decor-right-brace "| "
   wg-list-display-decor-current-left ""
   wg-list-display-decor-current-right ""
   wg-list-display-decor-previous-left ""
   wg-list-display-decor-previous-right "")

  :config
  ;; Remember fixed workgroup names between sessions
  (push 'doom-wg-names savehist-additional-variables)

  ;; `wg-mode-line-display-on' wasn't enough
  (advice-add 'wg-change-modeline :override 'ignore)

  ;; Don't remember popup and neotree windows
  (add-hook 'kill-emacs-hook 'doom|wg-cleanup)

  (after! projectile
    ;; Create a new workgroup on switch-project
    (setq projectile-switch-project-action 'doom/wg-projectile-switch-project))

  ;; This helps abstract some of the underlying functions away, just in case I want to
  ;; switch to a different package in the future, like persp-mode, eyebrowse or wconf.
  (defalias 'doom/tab-save 'doom/workgroup-save)
  (defalias 'doom/tab-load 'doom/workgroup-load)
  (defalias 'doom/tab-display 'doom/workgroup-display)
  (defalias 'doom/tab-create 'doom/workgroup-new)
  (defalias 'doom/tab-rename 'doom/workgroup-rename)
  (defalias 'doom/tab-kill 'doom/workgroup-delete)
  (defalias 'doom/tab-kill-others 'doom/kill-other-workgroups)
  (defalias 'doom/tab-switch-to 'doom/switch-to-workgroup-at-index)
  (defalias 'doom/tab-left 'doom/switch-to-workgroup-left)
  (defalias 'doom/tab-right 'doom/switch-to-workgroup-right)
  (defalias 'doom/tab-switch-last 'wg-switch-to-previous-workgroup)

  (add-hook! emacs-startup
    (workgroups-mode +1)
    (wg-create-workgroup wg-first-wg-name)))

(unless window-system
  (defalias 'wg-workgroup-associated-buffers 'ignore)
  (defalias 'wg-current-workgroup 'ignore)
  (defalias 'wg-save-session 'ignore))

(provide 'core-workgroups)
;;; core-workgroups.el ends here
