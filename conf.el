;;--------------------- General Conf -----------------------

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t) ;Disable splash screen
(put 'erase-buffer 'disabled nil)
(global-visual-line-mode 1) ;Proper line wrapping
; Sentences are finished with dot and ONE space.
(setq sentence-end-double-space nil)


;;--------------------- Buffers ----------------------------

;Shift + arrow = move to another buffer
(windmove-default-keybindings)
; Better buffer view
(global-set-key (kbd "C-x C-b") 'ibuffer)
; Kill the current buffer without asking for confirmation
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;;------------------ Backups and Saves ---------------------

(setq
   backup-by-copying t      ; No symbolic links
   backup-directory-alist '(("." . "~/.emacs.backups/"))
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)

(defvar autosave-dir (expand-file-name "~/.emacs.saves/"))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))
(make-directory autosave-dir t)


;;----------------------- Yes-No ---------------------------

; Make the y or n suffice for a yes or no question
(fset 'yes-or-no-p 'y-or-n-p)

; Allow files to end with a blank line
(setq require-final-newline t)

;;------------------------ Mouse ----------------------------

; Enable the mouse in a regular terminal
(cond (window-system
       (mwheel-install)
	   (setq mouse-wheel-scroll-amount '(2 ((shift) . 1)))
	   (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
	   (setq mouse-wheel-follow-mosue 't) ;; scroll window under mouse
))
