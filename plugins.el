;;---------------------- PATH ---------------------------
; Main plugins path
(add-to-list 'load-path "~/.emacs.d/plugins")


;;---------------------- Popwin --------------------------
; Automatically manage popup windows that sometimes remain after using them
(require 'popwin)
;(setq display-buffer-function 'popwin:display-buffer)
(setq popwin:close-popup-window-timer-interval 0.1)
; Buffers to convert to popups
;; (push '("^\\*helm.*\\*$" :height 0.5 :regexp t :position bottom) popwin:special-display-config)
;; (push '("helm" :height 0.5 :regexp t :position bottom) popwin:special-display-config)
(push '("*Swoop*" :height 0.5 :position bottom) popwin:special-display-config)
(push '("*Warnings*" :height 0.5) popwin:special-display-config)
(push '("*Procces List*" :height 0.5) popwin:special-display-config)
(push '("*Messages*" :height 0.5) popwin:special-display-config)
(push '("*Backtrace*" :height 0.5) popwin:special-display-config)
(push '("*Compile-Log*" :height 0.5 :noselect t) popwin:special-display-config)
(push '("*Remember*" :height 0.5) popwin:special-display-config)
(push '("*All*" :height 0.5) popwin:special-display-config)
(push '("*Ibuffer*" :height 0.5) popwin:special-display-config)
(push '(flycheck-error-list-mode :height 0.5 :regexp t :position bottom) popwin:special-display-config)
(push '(direx:direx-mode :position left :width 40 :dedicated t) popwin:special-display-config)
(popwin-mode 1)

;;------------------- Buffer-Move ------------------------
; Swap the place of the displayed buffers
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")  'buf-move-up)
(global-set-key (kbd "<C-S-down>")  'buf-move-down)
(global-set-key (kbd "<C-S-left>")  'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;;------------------------- EIN --------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/ein/lisp")
(require 'ein-loaddefs)
(require 'ein)
(defun my-ein-load ()
  (interactive)
  (ein:notebooklist-open 8888)
  )
(global-set-key (kbd "C-c e") 'my-ein-load)

;;------------------------ Magit -------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/magit/lisp")
(autoload 'magit-status "magit" nil t)

(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
	       "~/.emacs.d/site-lisp/magit/Documentation/"))

; Highlight words that changed inside a diff.
(setq  magit-diff-refine-hunk t)

(global-set-key (kbd "C-x g") 'magit-status)

;;------------------- Switch Window ----------------------
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)

;;--------------------- linnum+ -------------------------
;; Smart line numbers
(require 'linum+)

;;---------------------- Helm ---------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/helm")
(add-to-list 'load-path "~/.emacs.d/plugins/async")
(require 'helm-config)
(require 'helm-files)
;(require 'helm-match-plugin)
(require 'helm-misc)
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-buffers-fuzzy-matching           nil
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; Ignore some files or buffers when browsing.
(setq helm-ff-skip-boring-files t)
(setq helm-boring-file-regexp-list
      '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "~$"
	"\\.so$" "\\.a$" "\\.elc$" "\\.fas$" "\\.fasl$" "\\.pyc$" "\\.pyo$"))
(setq helm-boring-buffer-regexp-list
  '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*tramp" "\\*Minibuf" "\\*epc"))
(helm-mode 1)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)

;;--------------------- Helm-gtags -----------------------
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;-------------------- persp-mode ------------------------
(require 'persp-mode)
(global-set-key (kbd "<pause>")     'persp-mode)
(global-set-key (kbd "s-z")         'persp-switch)
; Location where perspectives are stored.
(setq persp-save-dir "/home/boy/.emacs.d/.persp/")
; Load the auto saved perpectives as soon as persp-mode is activated.
(setq persp-auto-resume-time 0.1)

;;------------------ Maximize Window --------------------
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;;-------------------- Yasnippet ------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
;(yas-reload-all)
(yas-global-mode 1)
; Display a popup for the available options.
;; (add-to-list 'load-path "~/.emacs.d/plugins/auto-complete/lib/popup")
;; (require 'popup)
;; ; Add some shotcuts in popup menu mode
;; (define-key popup-menu-keymap (kbd "M-n") 'popup-next)
;; (define-key popup-menu-keymap (kbd "TAB") 'popup-next)
;; (define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
;; (define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
;; (define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

;; (defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
;;   (when (featurep 'popup)
;;     (popup-menu*
;;      (mapcar
;;       (lambda (choice)
;;         (popup-make-item
;;          (or (and display-fn (funcall display-fn choice))
;;              choice)
;;          :value choice))
;;       choices)
;;      :prompt prompt
;;      ;; start isearch mode immediately
;;      :isearch t
;;      )))
;; (setq yas-prompt-functions '(yas-popup-isearch-prompt yas-no-prompt))

;;---------------------- Company Mode----------------------
(add-to-list 'load-path "~/.emacs.d/plugins/company-mode")
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
; Auto complete keyb
(global-set-key (kbd "<C-tab>") 'company-complete)
; Start autocomplete immediately
(setq company-idle-delay 0)
; Show numbers in the alternatives
(setq company-show-numbers t)
; change the default color to better view in the dark background
(deftheme jellybeans
    "Created 2013-11-05.")

(custom-theme-set-faces
  'jellybeans
   '(cursor ((t (:background "#b0d0f0"))))

    '(default ((t (:inherit nil :background "#151515" :foreground "#e8e8d3"))))

     ;; company
     '(company-tooltip ((t (:background "#606060")))))

; This is a comm

;;--------------------- Auto Complete----------------------
;; (add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/dict")
;; (setq ac-comphist-file  "~/.emacs.d/plugins/auto-complete/ac-comphist.dat")
;; (ac-config-default)
; set the trigger key so that it can work together with yasnippet on tab key,
; if the word exists in yasnippet, pressing tab will cause yasnippet to
; activate, otherwise, auto-complete will
;(ac-set-trigger-key "TAB")
;(ac-set-trigger-key "<tab>")


;;-------------------- Smooth Scroll ----------------------
(require 'smooth-scrolling)
