;;; defuns-docs.el

;; TODO: Make a shortcut for this
;;;###autoload (autoload 'doom:docs-lookup "defuns-docs" nil t)
;; (evil-define-command doom:docs-lookup (&optional bang input)
;;   "Look up INPUT (otherwise the current selection) in Dash or Zeal."
;;   (interactive "<!><a>")
;;   (let ((query input))
;;     (when (evil-visual-state-p)
;;       (setq query (concat (buffer-substring-no-properties (region-beginning) (region-end))
;;                           " " query)))
;;     (when (or (not query) (zerop (length query)))
;;       (setq query (thing-at-point 'symbol)))
;;     (doom-docs-lookup query bang)))

(provide 'defuns-docs)
;;; defuns-docs.el ends here
