;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic Emacs

(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(global-visual-line-mode -1)
(global-hl-line-mode 1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(linum-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts

(when (member "-adobe-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1" (font-family-list))
  (set-face-font 'default "-adobe-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
  (set-face-attribute 'default nil :height 110))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mac setup

(when (or (string= system-name "zakbook-pro.local")
	  (string= system-name "SYS0803.local"))
  (setenv "PATH" (concat (getenv "PATH") ":/Users/zaknitsch/bin"))
  (setq exec-path (append exec-path '("/Users/zaknitsch/bin")))
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (set-face-attribute 'default nil :height 120))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NPM
;; TODO : use this?

;;(setenv "PATH" (concat (getenv "PATH") ":/home/akeedle/.nvm/versions/node/v4.4.7/bin"))
;;(setq exec-path (append exec-path '("/home/akeedle/.nvm/versions/node/v4.4.7/bin")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use-package

(require 'package)

(setq package-enable-at-startup nil)

(setq package-archives
      '(("ELPA"         . "http://tromey.com/elpa/")
        ("gnu"          . "http://elpa.gnu.org/packages/")
        ("melpa"        . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")))

(when (boundp 'package-pinned-packages)
  (setq package-pinned-packages
	'((cider . "melpa-stable"))))

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

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

(use-package magit
  :ensure t
  :bind
  (("C-x g"   . magit-status)
   ("C-x M-g" . magit-dispatch-popup)))

(use-package magit-gerrit
  :ensure t
  :init
  (setq-default magit-gerrit-ssh-creds "znitsch@partners.macadamian.com")
  (setq-default magit-gerrit-remote "origin")
  :bind
  (("C-x M-r" . magit-gerrit-popup)))

(use-package ag
  :ensure t)

(use-package helm
  :ensure t   
  :init
  (require 'helm-config)
  (helm-mode 1)
  (helm-autoresize-mode 1)
  ;; TODO - figure out why this is void
  ;;(helm-push-mark-mode 1)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (setq helm-scroll-amount 4
	 helm-ff-smart-completion t
	 helm-ff-skip-boring-files t)
  :bind (("C-x C-f" . helm-find-files)
	       ("C-x b"   . helm-buffers-list)
	       ("C-x C-b" . helm-buffers-list)
	       ("M-x"     . helm-M-x)
	       ("M-y"     . helm-show-kill-ring)))

(use-package helm-projectile
  :ensure t)

(use-package helm-swoop
  :ensure t
  :bind (("M-i" . helm-swoop)))

(use-package helm-ag
  :ensure t)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(use-package ace-window
  :ensure t
  :init   (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind   (("C-x o" . ace-window)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Lispy Modes

(use-package paredit
  :ensure t
  :config
  (autoload 'enable-paredit-mode "paredit" "" t))

(use-package rainbow-delimiters
  :ensure t)

(use-package highlight-parentheses
  :ensure t)

(defun lispy-modes ()
  (paredit-mode 1)
  (rainbow-delimiters-mode 1)
  (highlight-parentheses-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure 

(use-package eldoc
  :ensure t)

(defun my-cider-mode-hook ()
  (eldoc-mode 1))

(use-package cider
  :ensure t
  :config
  (add-hook 'cider-repl-mode-hook #'my-cider-mode-hook)
  (add-hook 'cider-mode-hook #'my-cider-mode-hook)
  (setq cider-cljs-lein-repl
	"(do (require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/start-figwheel!)
             (figwheel-sidecar.repl-api/cljs-repl))"))

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook
	    (lambda ()
	      (lispy-modes)
	      (eldoc-mode 1)
	      ;; TODO - see if you want to keep this \/
	      (cljr-add-keybindings-with-prefix "C-c C-m"))))


(use-package clj-refactor
  :ensure t
  :init
  (add-hook 'clojure-mode-hook
	    (lambda ()
	      (clj-refactor-mode 1)
	      (cljr-add-keybindings-with-prefix "C-c M-r"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PYTHON

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  ;; disable to preserve projectile kbd
  (define-key elpy-mode-map (kbd "C-c C-p") nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WEB

(use-package js2-mode
  :ensure t
  :init 
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  ;; Better imenu
  (add-hook 'js2-mode-hook #'js2-imenu-extras-mode))


(use-package js2-refactor
  :ensure t
  :init
  (rainbow-delimiters-mode 1)
  (highlight-parentheses-mode 1)
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c C-r")
  (define-key js2-mode-map (kbd "C-k") #'js2r-kill)
  ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
  ;; unbind it.
  (define-key js-mode-map (kbd "M-.") nil))

(use-package xref-js2
  :ensure t
  :init
  (add-hook 'js2-mode-hook
	    (lambda () (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))


(use-package less-css-mode
  :ensure t)

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("/some/react/path/.*\\.js[x]?\\'" . web-mode))
  (setq web-mode-content-types-alist
        '(("json" . "/some/path/.*\\.api\\'")
          ("xml"  . "/other/path/.*\\.api\\'")
          ("jsx"  . "/some/react/path/.*\\.js[x]?\\'")))
  (setq web-mode-engines-alist
        '(("php"    . "\\.phtml\\'")
          ("blade"  . "\\.blade\\.")))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  :init
  (setq-default indent-tabs-mode nil)
	(setq-default tab-width 2)
	(setq indent-line-function 'insert-tab))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TypeScript

(use-package tide
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . tide-mode))
  :init
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency
  (company-mode +1)

  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)
  ;; formats the buffer before saving
  (add-hook 'before-save-hook 'tide-format-before-save)
  
  (add-hook 'typescript-mode-hook #'setup-tide-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; E-Lisp

(defun my-elisp-mode-hook ()
  (lispy-modes))

(add-hook 'emacs-lisp-mode-hook #'my-elisp-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unset stupid suspend keybindings
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Plugins

;; Robot Framework Mode
(load-file ".emacs.d/plugins/robot-mode.el")
(add-to-list 'auto-mode-alist '("\\.robot\\'" . robot-mode))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Keybindings

(global-set-key (kbd "C-x C-r") 'sudo-edit)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (elpy tide bracketed-paste racket-mode geiser aggressive-indent ac-cider cljr-helm ace-window try zenburn-theme zenburn helm-swoop elm-mode flycheck psc-ide auto-highlight-symbol less-css-mode use-package undo-tree rainbow-delimiters purescript-mode projectile paredit markdown-preview-mode markdown-mode+ magit highlight-parentheses helm-ag golden-ratio company-statistics cider)))
 '(python-shell-interpreter "python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
