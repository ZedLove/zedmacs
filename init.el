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

(defun my-open-init-file ()
  "Convenience for editing this file."
  (interactive)
  (find-file user-init-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get around failing package signatures
;; COMMENT OUT BY DEFAULT

;; (setq package-check-signature nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts

(when (member "-adobe-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1" (font-family-list))
  (set-face-font 'default "-adobe-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
  (set-face-attribute 'default nil :height 110))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mac setup

(when (string= system-name "zakbook-pro.local")
  (setenv "PATH" (concat (getenv "PATH") ":/Users/zaknitsch/bin"))
  (setq exec-path (append exec-path '("/Users/zaknitsch/bin")))
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  ;; hide java icon in OSX dock (TODO: doesn't work?)
  (setenv "LEIN_JVM_OPTS" "-Dapple.awt.UIElement=true")
  (set-face-attribute 'default nil :height 120))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use-package

(require 'package)

(setq package-enable-at-startup nil)

(setq package-archives
      '(("ELPA"         . "https://tromey.com/elpa/")
        ("gnu"          . "https://elpa.gnu.org/packages/")
        ("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))

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
  (setq-default magit-gerrit-ssh-creds "")
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
  :ensure t
  :init (global-highlight-parentheses-mode 1))

(defun lispy-modes ()
  ;; TODO - this doesn't work as expected
  (paredit-mode 1)
  (rainbow-delimiters-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SML/NJ

(use-package sml-mode
  :ensure t
  :init 
  (add-to-list 'auto-mode-alist '("\\.sml\\'" . sml-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure 

(use-package eldoc
  :ensure t)

(defun my-cider-mode-hook ()
  (eldoc-mode 1)
  ;; TODO - fix lispy-modes
  ;; (lispy-modes)
  (paredit-mode 1)
  (rainbow-delimiters-mode 1)
  (highlight-parentheses-mode 1))

(use-package cider
  :ensure t
  :config
  (add-hook 'cider-repl-mode-hook #'my-cider-mode-hook)
  (add-hook 'cider-mode-hook #'my-cider-mode-hook))

(defun powmato-client ()
  (interactive)
  (set-variable 'cider-lein-parameters "with-profiles +client,+client-dev repl :headless")
  (cider-jack-in-cljs '(:jack-in-cmd 'lein))
  (set-variable 'cider-lein-parameters "repl :headless"))

(defun powmato-server ()
  (interactive)
  (set-variable 'cider-lein-parameters "with-profiles +server,+server-dev repl :headless")
  (cider-jack-in '(:jack-in-cmd 'lein))
  (set-variable 'cider-lein-parameters "repl :headless"))

(defun jackmato ()
  (interactive)
  (set-variable 'cider-lein-parameters "with-profiles +server,+server-dev repl :headless")
  (cider-jack-in '(:jack-in-cmd 'lein))
  (set-variable 'cider-lein-parameters "with-profiles +client,+client-dev repl :headless")
  (cider-jack-in-cljs '(:jack-in-cmd 'lein))
  (set-variable 'cider-lein-parameters "repl :headless"))

(defun start-cider-repl-with-profiles ()
  (interactive)
  (letrec ((profiles (read-string "Enter profile names (including +): "))
           (lein-params (concat "with-profiles " profiles " repl :headless")))
    (message "lein-params set to: %s" lein-params)
    (set-variable 'cider-lein-parameters lein-params)
    (cider-jack-in '(:jack-in-cmd 'lein))))

;; (defun start-cider-repl-with-profile (profile)
;;   (interactive "sEnter profile name: ")
;;   (letrec ((lein-params (concat "with-profile +" profile " repl :headless")))
;;     (message "lein-params set to: %s" lein-params)
;;     (set-variable 'cider-lein-parameters lein-params)
;;     (cider-jack-in 'lein)))

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook
	    (lambda ()
	      ;; TODO - fix lispy modes
	      ;;(lispy-modes)
	      (paredit-mode 1)
	      (rainbow-delimiters-mode 1)
	      (highlight-parentheses-mode 1)
	      (eldoc-mode 1)
	      ;; TODO - see if you want to keep this \/
	      ;;(cljr-add-keybindings-with-prefix "C-c C-m")
        )))


;; (use-package clj-refactor
;;   :ensure f ;; incompatible past Cider 0.18.0
;;   :init
;;   (add-hook 'clojure-mode-hook
;;             (lambda ()
;;               (clj-refactor-mode 1)
;;               (cljr-add-keybindings-with-prefix "C-c M-r"))))

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
  :mode "\\.js\\'"
  :config
  (customize-set-variable 'js2-include-node-externs t))

;; TODO - run prettier on save
(use-package prettier-js
  :ensure t
  :hook (web-mode vue-mode)
  :init
  (setq prettier-js-args
        '("--trailing-comma"        "none"
          "--bracket-spacing"       "true"
          "--single-quote"          "true"
          "--no-semi"               "true"
          "--jsx-single-quote"      "true"
          "--jsx-bracket-same-line" "true"
          "--print-width"           "100")))

(use-package rjsx-mode
  :defer t)

(use-package web-mode
  :ensure t
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  :init
  (setq-default indent-tabs-mode nil)
	(setq-default tab-width 2)
	(setq indent-line-function 'insert-tab)
  :mode ("\\.html?\\'"
         "\\.phtml\\'"
         "\\.php\\'"
         "\\.inc\\'"
         "\\.tpl\\'"
         "\\.jsp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.js\\'"
         "\\.ts\\'"
         "\\.jsx\\'"
         "\\.tsx\\'")
  :config
  ;; configure jsx-tide checker to run after your default jsx checker
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'typescript-tslint 'web-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Vue

(use-package vue-mode
  :ensure t
  :config
  (setq mmm-submode-decoration-level 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tide

  
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    ;; (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1))

  
(use-package tide                       ; https://github.com/ananthakumaran/tide
  :init
  (add-hook 'rjsx-mode-hook #'setup-tide-mode)
  :requires flycheck
  :config
  (add-to-list 'company-backends 'company-tide)
  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)

  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
  
  :hook ((web-mode . tide-setup)
         (vue-mode . tide-setup)
         (web-mode . tide-hl-identifier-mode)
         ;; (before-save . tide-format-before-save)
         ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; E-Lisp

(defun my-elisp-mode-hook ()
  ;; TODO - fix lispy modes
  ;;(lispy-modes)
  (paredit-mode 1)
  (rainbow-delimiters-mode 1)
  (highlight-parentheses-mode 1))

(add-hook 'emacs-lisp-mode-hook #'my-elisp-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unset stupid suspend keybindings
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Plugins

;; Robot Framework Mode
(load-file "~/.emacs.d/plugins/robot-mode.el")
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
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js-indent-level 4)
 '(js2-highlight-level 3)
 '(js2-strict-missing-semi-warning nil)
 '(js2r-prefer-let-over-var 1)
 '(package-selected-packages
   (quote
    (typescript-mode vue-mode sml-mode protobuf-mode go-mode go clojure-mode cider elpy tide bracketed-paste racket-mode geiser aggressive-indent ac-cider ace-window try zenburn-theme zenburn helm-swoop elm-mode flycheck psc-ide auto-highlight-symbol less-css-mode use-package undo-tree rainbow-delimiters purescript-mode projectile paredit markdown-preview-mode markdown-mode+ magit highlight-parentheses helm-ag golden-ratio company-statistics)))
 '(python-shell-interpreter "python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
