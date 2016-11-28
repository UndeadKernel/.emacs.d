;;; core-ivy.el
;; see defuns/defuns-ivy.el

(use-package ivy
  :init
  (setq projectile-completion-system 'ivy
        ivy-height 15
        ivy-do-completion-in-region nil
        ivy-wrap t)

  :config
  (after! magit
    (setq magit-completing-read-function 'ivy-completing-read))

  (ivy-mode +1)
  ;; Fix display glitches
  (advice-add 'ivy-done :after 'redraw-display)

  (require 'counsel)

  (add-hook! doom-popup-mode
    (when (eq major-mode 'ivy-occur-grep-mode)
      (ivy-wgrep-change-to-wgrep-mode)))

  (setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)"))

(use-package counsel-projectile :after projectile)

(use-package swiper :commands (swiper swiper-all))

(provide 'core-ivy)
;;; core-ivy.el ends here
