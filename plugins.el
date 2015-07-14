;;---------------------- PATH ---------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/")

;;------------------- Switch Window ----------------------
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)

;;-------------------- Workgroups ------------------------
(require 'workgroups2)
;; Prefix key
(setq wg-prefix-key (kbd "C-c w"))
(setq wg-session-file "~/.emacs.d/.workgroups")
;; Keyboard shortcuts - load, save, switch
(global-set-key (kbd "<pause>")     'workgroups-mode)
(global-set-key (kbd "C-<pause>")   'wg-save-session)
(global-set-key (kbd "s-z")         'wg-switch-to-workgroup)
(global-set-key (kbd "s-/")         'wg-switch-to-previous-workgroup)
;; Do not start it by default.
;(workgroups-mode 1)

;;--------------------- linnum+ -------------------------
;; Smart line numbers
(require 'linum+)

;;---------------------- Helm ---------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/helm")
(add-to-list 'load-path "~/.emacs.d/plugins/async")
(require 'helm-config)
(require 'helm-files)
(require 'helm-match-plugin)
(require 'helm-misc)
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; Ignore some files or buffers when browsing.
(setq helm-ff-skip-boring-files t)
(setq helm-boring-file-regexp-list
      '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "~$"
	"\\.so$" "\\.a$" "\\.elc$" "\\.fas$" "\\.fasl$" "\\.pyc$" "\\.pyo$"))
(setq helm-boring-buffer-regexp-list
  '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*tramp" "\\*Minibuf" "\\*epc"))
(helm-mode 1)

;;----------------------- IDO ---------------------------
;; (require 'ido)
;; (ido-mode)
;; ;; Display ido results vertically, rather than horizontally.
;; (require 'ido-vertical-mode)
;; (ido-vertical-mode 1)
;; ;; Use ido completion in projectile.
;; (setq projectile-completion-system 'ido)

;;------------------ Maximize Window --------------------
(require 'maxframe)
(setq mf-max-width 1920)
(add-hook 'window-setup-hook 'maximize-frame t)

;;-------------------- Yasnippet ------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-reload-all)
(yas-global-mode 1)
; Display a popup for the available options.
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete/lib/popup")
(require 'popup)
; Add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))
(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-no-prompt))
;; (add-hook 'js-mode-hook
;;               '(lambda ()
;;                  (yas-minor-mode)))

;;--------------------- Auto Complete----------------------
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/dict")
(setq ac-comphist-file  "~/.emacs.d/plugins/auto-complete/ac-comphist.dat")
(ac-config-default)
; set the trigger key so that it can work together with yasnippet on tab key,
; if the word exists in yasnippet, pressing tab will cause yasnippet to
; activate, otherwise, auto-complete will
;(ac-set-trigger-key "TAB")
;(ac-set-trigger-key "<tab>")


;;-------------------- Smooth Scroll ----------------------
(require 'smooth-scrolling)

;;----------------------- Tabbar --------------------------

;; (cond (window-system
;;        (require 'tabbar)
;;        (tabbar-mode 1)
;;        (global-set-key [(control shift up)] 'tabbar-backward-group)
;;        (global-set-key [(control shift down)] 'tabbar-forward-group)
;;        (global-set-key [(control shift left)] 'tabbar-backward)
;;        (global-set-key [(control shift right)] 'tabbar-forward)
;; ))
