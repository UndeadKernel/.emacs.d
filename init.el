;;; init.el
;;
;; Author:  Henrik Lissner <henrik@lissner.net> (Original Author)
;;          Carlos Garcia <carlos@binarycharly.com> (Humble Modder)
;;
;;   =================     ===============     ===============   ========  ========
;;   \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
;;   ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
;;   || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
;;   ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
;;   || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
;;   ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
;;   || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
;;   ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
;;   ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
;;   ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
;;   ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
;;   ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
;;   ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
;;   ||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
;;   ||.=='    _-'                                                     `' |  /==.||
;;   =='    _-'                                                            \/   `==
;;   \   _-'                                                                `-_   /
;;    `''                                                                      ``'
;;
;; These demons are not part of GNU Emacs.
;;
;;; License: MIT

(load (concat user-emacs-directory "core/core"))

(doom
      core-ui            ; draw me like one of your French editors
      core-popup         ; taming sudden and inevitable windows
      core-os            ; os-specific config
      core-modeline      ; a self-contained mode-line config for masochists
      core-editor        ; filling the editor-shaped hole in the emacs OS
      core-docs          ; getting to the documentation
      core-company       ; auto-completion, for the lazy typist
      core-yasnippet     ; snippets, for the lazier typist
      core-autoinsert    ; file templates, for the laziest typist
      core-flycheck      ; get tazed for every semicolon you forget
      core-project       ; for project navigation aficionados
      core-vcs           ; remember remember, that commit in November
      core-ivy           ; a search engine for life and love
      core-workgroups    ; cure Emacs alzheimers + tab emulation
      core-eval          ; run code, run + REPL support
      core-scratch       ; a perdier scratch buffer

      ;; ;;; Dev environments
      module-elisp       ; drowning in parentheses
      module-python      ; beautiful is better than ugly
      module-latex
      ;; module-asm         ; Assembly
      ;; module-cc          ; C/C++/Obj-C madness
      ;; module-crystal     ; ruby at the speed of c
      ;; module-csharp      ; unity, .NET, and mono shenanigans
      ;; module-css         ; #big-bang::before { content: ""; }
      ;; module-data        ; config/data formats
      ;; module-eshell      ; so I can have a sane shell, even in Windows
      ;; module-go          ; the hipster dialect
      ;; module-haskell     ; a language that's lazier than I am
      ;; module-java        ; the poster child for carpal tunnel syndrome
      ;; module-js          ; all(hope(abandon(ye(who(enter(here))))))
      ;; module-julia       ; A better, faster MATLAB
      ;; module-latex       ; for writing papers in Emacs
      ;; module-lua         ; one-based indices? one-based indices
      ;; module-octave      ; math isn't a choice. It's a way of life
      ;; module-php         ; making php less painful to work with
      ;; module-processing  ; for prototyping
      ;; module-rest        ; Emacs as a service
      ;; module-ruby        ; 1.step do {|i| p "Ruby is #{i&1==0?'love':'life'}"}
      ;; module-rust        ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
      ;; module-scala       ; Java, but good
      ;; module-sh          ; she sells Z-shells by the C XOR
      ;; module-swift       ; I wanted emoji variables. I got them
      ;; module-text        ; writing docs for people to ignore
      ;; module-web         ; The end is always near </html>

      ;; ;;; Org
      ;; module-org         ; for organized fearless leader
      ;; module-org-notes   ; org-mode as a (modern?) note-taking platform
      ;; module-org-crm     ; org-mode for business management

      ;; ;;; Custom modules
      ;; custom-db          ; emacs as a db browser/client
      ;; custom-debug       ; nigh-universal debugging
      ;; custom-demo        ; allow me to demonstrate...
      ;; custom-screeps     ; The programmer MMO
      ;; custom-tags        ; if you liked it you should've generated a tag for it
      ;; custom-tmux        ; close the rift between GUI & terminal
      ;; custom-write       ; Emacs as a word processor

      ;; ;;; Personal
      ;; my-commands
      my-bindings
      )
