;;; module-js.el

(use-package js2-mode
  :mode "\\.js$"
  :interpreter "node"
  :init
  (add-hook! js2-mode '(tern-mode flycheck-mode))
  :config
  (def-repl! js2-mode nodejs-repl)
  (def-company-backend! js2-mode (tern))
  (def-docset! js2-mode "js,jquery,nodejs,angularjs,express")
  (def-electric! js2-mode :chars (?\} ?\) ?.) :words ("||" "&&"))
  (setq-default
   js2-skip-preprocessor-directives t
   js2-highlight-external-variables nil
   ;; Disable the error checking of js2-mode, leave that to flycheck
   js2-mode-show-parse-errors nil
   js2-mode-show-strict-warnings nil)
  (setq js-indent-level 2)

  (add-hook! lb6-project-mode
    (when (eq major-mode 'js2-mode)
      (setq js2-additional-externs '("LaunchBar" "File" "Action" "HTTP" "include" "Lib"))))

  ;; [pedantry intensifies]
  (add-hook! js2-mode (setq mode-name "JS2"
                            js-switch-indent-offset js-indent-level)))

(use-package tern
  :after js2-mode
  :commands (tern-mode))

(use-package company-tern
  :after tern)

(use-package js2-refactor
  :after js2-mode
  :config
  (mapc (lambda (x)
          (let ((command-name (car x))
                (title (cadr x))
                (region-p (caddr x))
                predicate)
            (setq predicate (cond ((eq region-p 'both) nil)
                                  (t (if region-p
                                         (lambda () (use-region-p))
                                       (lambda () (not (use-region-p)))))))
            (emr-declare-command
                (intern (format "js2r-%s" (symbol-name command-name)))
              :title title :modes 'js2-mode :predicate predicate)))
        '((extract-function           "extract function"           t)
          (extract-method             "extract method"             t)
          (introduce-parameter        "introduce parameter"        t)
          (localize-parameter         "localize parameter"         nil)
          (expand-object              "expand object"              nil)
          (contract-object            "contract object"            nil)
          (expand-function            "expand function"            nil)
          (contract-function          "contract function"          nil)
          (expand-array               "expand array"               nil)
          (contract-array             "contract array"             nil)
          (wrap-buffer-in-iife        "wrap buffer in ii function" nil)
          (inject-global-in-iife      "inject global in ii function" t)
          (add-to-globals-annotation  "add to globals annotation"  nil)
          (extract-var                "extract variable"           t)
          (inline-var                 "inline variable"            t)
          (rename-var                 "rename variable"            nil)
          (var-to-this                "var to this"                nil)
          (arguments-to-object        "arguments to object"        nil)
          (ternary-to-if              "ternary to if"              nil)
          (split-var-declaration      "split var declaration"      nil)
          (split-string               "split string"               nil)
          (unwrap                     "unwrap"                     t)
          (log-this                   "log this"                   'both)
          (debug-this                 "debug this"                 'both)
          (forward-slurp              "forward slurp"              nil)
          (forward-barf               "forward barf"               nil))))

(use-package nodejs-repl :commands (nodejs-repl))

(use-package typescript-mode
  :mode "\\.ts$"
  :init
  (add-hook! typescript-mode
    '(rainbow-delimiters-mode doom|ts-fontify)))

(use-package tide
  :after typescript-mode
  :config
  (setq tide-format-options
        '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t
          :placeOpenBraceOnNewLineForFunctions nil))

  (defun doom|tide-setup ()
    (tide-setup)
    (flycheck-mode +1)
    (eldoc-mode +1))
  (add-hook 'typescript-mode-hook 'doom|tide-setup)

  (add-hook! web-mode
    (when (f-ext? buffer-file-name "tsx")
      (doom|tide-setup)))

  (advice-add 'tide-project-root :override 'doom/project-root))

;;
(defvar npm-conf (make-hash-table :test 'equal))
(def-project-type! nodejs "node"
  :modes (web-mode js-mode coffee-mode css-mode sass-mode pug-mode)
  :files ("package.json")
  :when
  (lambda (&rest _)
    (let* ((project-path (doom/project-root))
           (hash (gethash project-path npm-conf))
           (package-file (f-expand "package.json" project-path))
           deps)
      (awhen (and (not hash) (f-exists? package-file)
                  (ignore-errors (json-read-file package-file)))
        (puthash project-path it npm-conf)))
    t))

(def-project-type! expressjs "express"
  :modes (nodejs-project-mode bower-project-mode)
  :when
  (lambda (&rest _)
    (awhen (gethash (doom/project-root) npm-conf)
      (assq 'express (cdr-safe (assq 'dependencies it))))))

;; TODO electron-compile support
(def-project-type! electron "electron"
  :modes (nodejs-project-mode)
  :files ("app/index.html" "app/main.js")
  :when
  (lambda (&rest _)
    (awhen (gethash (doom/project-root) npm-conf)
      (let ((deps (append (car-safe (assq 'dependencies it))
                          (car-safe (assq 'devDependencies it)))))
        (or (assq 'electron-prebuilt deps)
            (assq 'electron-packager deps)
            (string-prefix-p "electron" (or (assq 'start it) "") t))))))


(provide 'module-js)
;;; module-js.el ends here
