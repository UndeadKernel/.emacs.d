;;; defuns-git.el

;;;###autoload
(defun doom/git-root ()
  (awhen (car-safe (browse-at-remote/remote-ref buffer-file-name))
    (cdr (browse-at-remote/get-url-from-remote it))))

;;;###autoload
(defun doom/git-issues ()
  "Open the github issues page for current repo."
  (interactive)
  (awhen (doom/git-root)
    (browse-url (concat it "/issues"))))

;;;###autoload
(defun doom/git-magit ()
  (interactive)
  (call-interactively 'magit-status))

;; TODO: check this function, does it work?
;;;###autoload
(defun doom/git-browse ()
  "Open the website for the current (or specified) version controlled FILE. If
BANG, then use hub to do it."
  (interactive)
  (let (url)
    (condition-case err
        (setq url (browse-at-remote/get-url))
      (error
       (setq url (shell-command-to-string "hub browse -u --"))
       (setq url (if url
                     (concat (s-trim url) "/" (f-relative (buffer-file-name) (doom/project-root))
                             (when (use-region-p) (format "#L%s-L%s"
                                                          (line-number-at-pos (region-beginning))
                                                          (line-number-at-pos (region-end)))))))))))

(provide 'defuns-git)
;;; defuns-git.el ends here
