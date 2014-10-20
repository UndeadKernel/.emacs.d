;; Taken from https://github.com/jimeh/.emacs.d and edited by me.

;; Disable splash page
(setq inhibit-startup-message t)

;; Set default font (from a set of fonts to choose).
(if gui-window-system
    ;;; Large
    (set-face-attribute 'default nil :family "Inconsolata" :height 110)
    ;; (set-face-attribute 'default nil :family "Monaco" :height 110)
    ;; (set-face-attribute 'default nil :family "Menlo" :height 110)

    ;;; Small
    ;; (set-face-attribute 'default nil :family "Monaco" :height 100)
    ;; (set-face-attribute 'default nil :family "Menlo" :height 100)
)

;; Load Theme
(add-to-list 'load-path "~/.emacs.d/themes")
(if gui-window-system (require 'twilight-anti-bright-theme)
  (require 'tomorrow-night-paradise-theme))

;; Enable menu-bar
(menu-bar-mode -1)

;; Disable toolbar
(tool-bar-mode -1)

;; Disable Scrollbar
(set-scroll-bar-mode 'nil)

;; Show matching parentheses
(show-paren-mode t)

;; Show column number globally
(column-number-mode t)

;; Highlight current line globally
(global-hl-line-mode t)

;; Customize line numbers - In gui mode the fringe is the spacer between line
;; numbers and code, while in console mode we add an extra space for it.
(if gui-window-system (setq linum+-dynamic-format " %%%dd")
  (setq linum+-dynamic-format " %%%dd "))

;; Linum+ resets linum-format to "smart" when it's loaded, hence we have to
;; use a eval-after-load hook to set it to "dynamic".
(eval-after-load "linum+" '(progn (setq linum-format 'dynamic)))

;; meaningful names for buffers with the same name
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; Cursor
(blink-cursor-mode t)
(setq initial-frame-alist
      (cons '(cursor-type . bar) (copy-alist initial-frame-alist)))
(setq default-frame-alist
      (cons '(cursor-type . bar) (copy-alist default-frame-alist)))

;; Some transparency
(setq transparency-level 99)
(set-frame-parameter nil 'alpha transparency-level)
(add-hook 'after-make-frame-functions
          (lambda (selected-frame)
            (set-frame-parameter selected-frame 'alpha transparency-level)))



;; Relative line numbers -- from: http://stackoverflow.com/a/6928112/42146
;; (defvar my-linum-format-string "%3d ")
;; ;; (add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)
;; (defun my-linum-get-format-string ()
;;   (let* ((width (1+ (length (number-to-string
;;                              (count-lines (point-min) (point-max))))))
;;          (format (concat "%" (number-to-string width) "d")))
;;     (setq my-linum-format-string format)))
;; (defvar my-linum-current-line-number 0)
;; (setq linum-format 'my-linum-relative-line-numbers)
;; (defun my-linum-relative-line-numbers (line-number)
;;   (let ((offset (abs(- line-number my-linum-current-line-number))))
;;     (propertize (format my-linum-format-string offset) 'face 'linum)))
;; (defadvice linum-update (around my-linum-update)
;;   (let ((my-linum-current-line-number (line-number-at-pos)))
;;     ad-do-it))
;; (ad-activate 'linum-update)
