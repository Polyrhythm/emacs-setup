(add-to-list 'custom-theme-load-path "~/.emacs.d/lib/color-themes")
(load-theme 'noctilux t)

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(require 'eclim)
(global-eclim-mode)

(require 'eclimd)

(require 'gradle-mode)
(add-hook 'java-mode-hook '(lambda ()
                             (gradle-mode 1)
                             (electric-pair-mode 1)))

(require 'shen-mode)
(require 'inf-shen)

(add-hook 'js-mode-hook '(lambda () (electric-pair-mode 1)))

(add-to-list 'load-path "~/Development/emacs/ace-jump-mode")
(autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(setq ace-jump-mode-scope 'window)

(add-hook 'after-init-hook 'global-company-mode)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(define-key eclim-mode-map (kbd "C-c C-c") 'eclim-problems-compilation-buffer)

(require 'multiple-cursors)
(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-.") 'mc/mark-all-like-this)

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default
 flycheck-disabled-checkers
 (append flycheck-disabled-checkers '(javascript-jshint json-jsonlint)))
(flycheck-add-mode 'javascript-eslint 'web-mode)
(setq-default flycheck-temp-prefix ".flycheck")

(when (memq window-system '(mac-ns))
  (exec-path-from-shell-initialize))

(require 'stylus-mode)
(add-to-list 'auto-mode-alist '("\\.styl\\'" . stylus-mode))

(add-to-list 'load-path "~/Development/emacs/slime/")
(require 'slime)
(require 'slime-autoloads)
(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix)
(setq slime-lisp-implementations
      '((clisp ("/usr/local/bin/clisp" "-K full"))
	(sbcl ("/usr/local/bin/sbcl"))
	(clasp ("~/Development/cpp/clasp/build/clasp/MacOS/clasp_boehm_o"))))
(setf slime-default-lisp 'clasp)
(setq slime-contribs '(slime-fancy))
(slime-setup '(slime-fancy))

;; Haskell stuff

(eval-after-load "haskell-mode"
  '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))

(eval-after-load "haskell-cabal"
      '(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))
(setq haskell-compile-cabal-build-command "stack build")

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
   '(haskell-process-log t))

(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
(define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
(define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)

(define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)

(setq load-path (cons "~/tidal/" load-path))
(require 'tidal)
(setq tidal-interpreter "/usr/local/bin/ghci")
(define-key haskell-mode-map (kbd "C-c C-w") 'tidal-run-line)

;; End haskell stuff

(require 'nav)
(nav-disable-overeager-window-splitting)
(global-set-key (kbd "C-q") 'nav-toggle)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require 'evil)
(evil-mode 1)

(global-set-key (kbd "C-x t") 'fiplr-find-file)
(setq fiplr-ignored-globs
    '((directories
	;; Version control
	(".git"
	".svn"
	".hg"
	".bzr"
	;; NPM
	"node_modules"
	;; Bower
	"bower_components"
	;; Android
	"build"
	".gradle"
	;; Maven
	"target"
	;; Python
	"__pycache__"))
    (files
	;; Emacs
	(".#*"
	;; Vim
	"*~"
	;; Objects
	"*.so"
	"*.o"
	"*.obj"
	;; Media
	"*.jpg"
	"*.png"
	"*.gif"
	"*.pdf"
	;; Archives
	"*.gz"
	"*.zip"))))

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
	(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

(setq-default indent-tabs-mode nil)

;; Unity shit
(defun unity-compile-game ()
  (interactive)
  (let ((cmd (concat "python " (projectile-project-root) "make.py fast "
                     (projectile-project-root))))
    (compile cmd)))

(defun unity-recompile-game ()
  (interactive)
  (let ((cmd (concat "python " (projectile-project-root) "make.py slow "
                     (projectile-project-root))))
    (compile cmd)))

(flycheck-define-checker csharp-unity
  "My dumb Unreal C# syntax checker"
    :command ("python" (eval (concat (projectile-project-root) "make.py")) "fast" (eval (projectie-project-root)) source-original source)
    :error-patterns ((warning line-start (file-name) "(" line (zero-or-more not-newline) "): " (message) line-end)
                     (error line-start (file-name) "(" line (zero-or-more not-newline) "): " (message) line-end))
    :modes csharp-mode)

(defun my-csharp-mode-hook ()
  (electric-pair-mode 1))
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)
(setq csharp-want-imenu nil)
(local-set-key (kbd "{") 'csharp-insert-open-brace)
(add-hook 'csharp-mode-hook 'omnisharp-mode)

;; /Unity shit

(custom-set-faces
 ;; ...
 '(company-preview ((t (:background "black" :foreground "red"))))
 '(company-preview-common ((t (:foreground "red"))))
 '(company-preview-search ((t (:inherit company-preview))))
 '(company-scrollbar-bg ((t (:background "brightwhite"))))
 '(company-scrollbar-fg ((t (:background "red"))))
 '(company-template-field ((t (:background "magenta" :foreground "black"))))
 '(company-tooltip ((t (:background "brightwhite" :foreground "black"))))
 '(company-tooltip-annotation ((t (:background "brightwhite" :foreground "black"))))
 '(company-tooltip-annotation-selection ((t (:background "color-253"))))
 '(company-tooltip-common ((t (:background "brightwhite" :foreground "red"))))
 '(company-tooltip-common-selection ((t (:background "color-253" :foreground "red"))))
 '(company-tooltip-mouse ((t (:foreground "black"))))
 '(company-tooltip-search ((t (:background "brightwhite" :foreground "black"))))
 '(company-tooltip-selection ((t (:background "color-253" :foreground
                                              "black"))))
 ;; ...
 )

(custom-set-variables
 '(eclim-eclipse-dirs '("/Applications/Eclipse.app/Contents/Eclipse"))
 '(eclim-executable "/Applications/Eclipse.app/Contents/Eclipse/eclim")
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
    ((c-file-offsets
      (innamespace . 0)
      (substatement-open . 0)
      (c . c-lineup-dont-change)
      (inextern-lang . 0)
      (comment-intro . c-lineup-dont-change)
      (arglist-cont-nonempty . c-lineup-arglist)
      (block-close . 0)
      (statement-case-intro . ++)
      (brace-list-intro . ++)
      (cpp-define-intro . +))
     (c-auto-align-backslashes)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
