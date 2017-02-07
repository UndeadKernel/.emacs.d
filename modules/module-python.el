;;; module-python.el

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :commands python-mode
  :init
  (setq-default
   python-environment-directory doom-cache-dir
   python-shell-interpreter "ipython"
   python-shell-interpreter-args "--deep-reload"
   python-shell-prompt-regexp "In \\[[0-9]+\\]: "
   python-shell-prompt-block-regexp "\\.\\.\\.\\.: "
   python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
   python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
   python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  (add-hook 'python-mode-hook 'flycheck-mode)

  :config
  (def-company-backend! python-mode (anaconda))
  (def-repl! python-mode doom/inf-python)
  (def-version-cmd! python-mode "python --version 2>&1 | cut -d' ' -f2")
  (define-key python-mode-map (kbd "DEL") nil)) ; interferes with smartparens

(use-package anaconda-mode
  :after python
  :init
  (add-hook! python-mode '(anaconda-mode anaconda-eldoc-mode eldoc-mode))
  (setq anaconda-mode-installation-directory (concat doom-cache-dir "/anaconda/")
        anaconda-mode-eldoc-as-single-line t)

  :config
  (advice-add 'anaconda-mode-doc-buffer :after 'doom*anaconda-mode-doc-buffer))

(use-package company-anaconda
  :after anaconda-mode
  :config
  (mapc (lambda (x)
          (let ((command-name (car x))
                (title (cadr x))
                (region-p (caddr x))
                predicate)
            (setq predicate (lambda () (and (anaconda-mode-running-p)
                                       (not (use-region-p))
                                       (not (sp-point-in-string-or-comment)))))
            (emr-declare-command (intern (format "anaconda-mode-%s" (symbol-name command-name)))
              :title title :modes 'python-mode :predicate predicate)))
        '((show-doc          "view documentation" t)
          (find-assignments  "find assignments"  t)
          (find-definitions  "find definitions"  t)
          (find-file         "find assignments"  t)
          (find-references   "show usages"  nil))))

(use-package pip-requirements
  :mode ("/requirements.txt$" . pip-requirements-mode)
  :config (def-company-backend! pip-requirements-mode (capf)))

(use-package nose
  :commands nose-mode
  :preface (defvar nose-mode-map (make-sparse-keymap))
  :init (associate! nose-mode :match "/test_.+\\.py$" :in (python-mode))
  :config
  (def-popup! "*nosetests*" :align below :size 0.4 :noselect t)
  (def-yas-mode! nose-mode))

(provide 'module-python)
;;; module-python.el ends here
