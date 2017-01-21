
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic Emacs

(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

(global-visual-line-mode -1)
(global-hl-line-mode 1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(linum-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts
(set-face-font 'default "-adobe-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
(set-face-attribute 'default nil :height 135)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mac setup
;; TODO : use this?
;; (when (string= system-name "keeds-mbp.local")
;;   (setenv "PATH" (concat (getenv "PATH") ":/Users/keeds/bin"))
;;   (setq exec-path (append exec-path '("/Users/keeds/bin")))
;;   (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
;;   (setq exec-path (append exec-path '("/usr/local/bin")))
;;   (set-face-attribute 'default nil :height 140))


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

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))
  
(use-package zenburn-theme
  :ensure t
  :init
  (load-theme 'zenburn t))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package paredit
  :ensure t
  :config
  (autoload 'enable-paredit-mode "paredit" "" t))

(use-package helm
  :ensure t   
  :init
  (require 'helm-config)
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (helm-push-mark-mode 1)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (setq helm-scroll-amount 4
	helm-ff-smart-completion t
	helm-ff-skip-boring-files t)
  :bind (("C-x C-f" . helm-find-files)
	 ("C-x k" . helm-buffers-list)
	 ("C-x b" . helm-buffers-list)
	 ("C-x C-b" . helm-buffers-list)
	 ("M-x" . helm-M-x)
	 ("M-y" . helm-show-kill-ring)))

(use-package helm-ag
  :ensure t)

(use-package helm-swoop
  :ensure t
  :init
  (bind-key "M-i" 'helm-swoop))

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(use-package ace-window
  :ensure t
  :init   (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind   (("C-x o" . ace-window))
  )

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
;; JS

(use-package js2-mode
  :ensure t)

(use-package less-css-mode
  :ensure t)

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
;; Custom Fns
(defun sudo-edit (&optional arg)
  "Stolen from Andrew Keedle.
   Edit currently visited file as root.
   With a prefix ARG prompt for a file to visit.
   Will also prompt for a file to visit if current
   buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-x C-r") 'sudo-edit)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ace-window try zenburn-theme zenburn helm-swoop elm-mode flycheck psc-ide auto-highlight-symbol less-css-mode use-package undo-tree rainbow-delimiters purescript-mode projectile paredit markdown-preview-mode markdown-mode+ magit highlight-parentheses helm-ag golden-ratio company-statistics cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
