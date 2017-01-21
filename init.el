
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic Emacs

(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

(global-visual-line-mode t)
(global-hl-line-mode 1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(linum-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts
(set-face-font 'default "-adobe-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mac setup
;; TODO : use this?
(when (string= system-name "keeds-mbp.local")
  (setenv "PATH" (concat (getenv "PATH") ":/Users/keeds/bin"))
  (setq exec-path (append exec-path '("/Users/keeds/bin")))
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setenv "PATH" (concat (getenv "PATH") ":/Users/keeds/.nvm/versions/node/v4.4.7/bin"))
  (setq exec-path (append exec-path '("/Users/keeds/.nvm/versions/node/v4.4.7/bin")))
  (set-face-attribute 'default nil :height 140))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NPM
;; TODO : use this?

;;(setenv "PATH" (concat (getenv "PATH") ":/home/akeedle/.nvm/versions/node/v4.4.7/bin"))
;;(setq exec-path (append exec-path '("/home/akeedle/.nvm/versions/node/v4.4.7/bin")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use-package

(require 'package)

;; (setq package-enable-at-startup nil)

(setq package-archives
      '(("ELPA" . "http://tromey.com/elpa/")
	("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "http://melpa.org/packages/")
	("melpa-stable" . "http://stable.melpa.org/packages/")))

(when (boundp 'package-pinned-packages)
  (setq package-pinned-packages
	'((cider        . "melpa-stable"))))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Packages

(use-package projectile
  :ensure t
  :init
  (bind-key "C-c p f" 'projectile-find-file)
  (bind-key "C-c p k" 'projectile-kill-buffers))

(use-package magit
  :ensure t
  :init
  (bind-key "C-c m g" 'magit-status)
  (bind-key "C-c m b" 'magit-blame)
  (bind-key "C-c m q" 'magit-blame-quit))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package company-statistics
  :ensure t
  :init
  (add-hook 'after-init-hook 'company-statistics-mode))

(use-package paredit
  :ensure t
  :config
  (autoload 'enable-paredit-mode "paredit" "" t))

(use-package undo-tree
  :ensure t
  :init
  (bind-key "M-_" 'undo-tree-visualize))

(use-package helm
  :ensure t
  :init
  (bind-key "C-x b" 'helm-buffers-list)
  (bind-key "C-x C-b" 'helm-buffers-list))

(use-package helm-ag
  :ensure t)

(use-package golden-ratio
  :ensure t
  :init
  (golden-ratio-mode 1))

(use-package which-key
  :ensure t
  :init
  (which-key-mode 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ido

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure config-changed-event

(use-package eldoc
  :ensure t)

(use-package rainbow-delimiters
  :ensure t)

(use-package highlight-parentheses
  :ensure t)

(defun my-cider-mode-hook ()
  (paredit-mode 1)
  (rainbow-delimiters-mode 1)
  (eldoc-mode 1))

(use-package cider
  :ensure t
  :config
  (add-hook 'cider-repl-mode-hook #'my-cider-mode-hook)
  (add-hook 'cider-mode-hook #'my-cider-mode-hook)
  (setq cider-cljs-lein-repl
	"(do (require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/start-figwheel!)
             (figwheel-sidecar.repl-api/cljs-repl))")
  ;; (setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api)(start-figwheel)(cljs-repl))")
  )

(defun my-clj-mode-hook ()
  (paredit-mode 1)
  (eldoc-mode 1)
  (rainbow-delimiters-mode 1)
  (highlight-parentheses-mode 1)
  ;; (cljr-add-keybindings-with-prefix "C-c C-m")
  (auto-highlight-symbol-mode 1)
  )

(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'my-clj-mode-hook)
  ;; (add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS / CoffeeScript

(use-package js2-mode
  :ensure t)

(use-package coffee-mode
  :ensure t)

(use-package less-css-mode
  :ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PureScript

(use-package psc-ide
  :ensure t)

(use-package flycheck
  :ensure t)

(use-package purescript-mode
  :ensure t
  :config
  (add-hook 'purescript-mode-hook
	    (lambda ()
	      (psc-ide-mode)
	      (company-mode)
	      (flycheck-mode)
	      (turn-on-purescript-indentation))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elm

(use-package elm-mode
  :ensure t
  :config (add-hook 'elm-mode-hook
		    (lambda ()
		      (linum-mode t))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other

(use-package auto-highlight-symbol
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unset stupid suspend keystokes
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom settings

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (elm-mode flycheck psc-ide auto-highlight-symbol less-css-mode use-package undo-tree rainbow-delimiters purescript-mode projectile paredit markdown-preview-mode markdown-mode+ magit highlight-parentheses helm-ag golden-ratio company-statistics cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

