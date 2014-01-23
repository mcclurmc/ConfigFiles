;; el-get is awesome!
;; https://github.com/dimitri/el-get

(defun recompile-configs ()
  (interactive)
  (byte-recompile-file "~/.emacs.el")
  (byte-recompile-file "~/.emacs.local.el"))

; eval emacs.local.el, and have that point to config/emacs/emacs.mac.el
; that should cd into ~
(load "~/.emacs.local")

(setq el-get-verbose t)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-user-package-directory "~/.emacs.d/el-get-init-files/")

;; (setq el-get-sources
;;       '(el-get
;; 	auto-complete
;; 	color-theme-solarized
;; 	tuareg-mode
;; 	google-c-style
;; 	haskell-mode
;; 	idris-mode))

(el-get 'sync
	'(color-theme-solarized
	  auto-complete
	  tuareg-mode
	  google-c-style
	  haskell-mode
	  idris-mode
	  markdown-mode
	  js2-mode
	  clojure-mode
	  dockerfile-mode
	  go-mode))


        ;; (:name typerex-mode
        ;;        :type git
        ;;        :url "git://github.com/OCamlPro/typerex.git"
        ;;        :description "Development Studio for OCaml"
        ;;        :build
        ;;        (("mkdir" "-p" "dist/bin")
        ;;         ("mkdir" "-p" "dist/elisp")
        ;;         "./configure --bindir `pwd`/dist/bin"
        ;;         ("make")
        ;;         ("make" "install-binaries")
        ;;         "EMACSDIR=./dist/elisp make -e install-emacs")
        ;;        ; :compile ("./dist/elisp/typerex.elc")
        ;;        :load-path ("./dist/elisp")
        ;;        :depends (auto-complete popup fuzzy)
        ;;        :prepare
        ;;        (progn
        ;;          (add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . typerex-mode))
        ;;          (add-to-list 'interpreter-mode-alist '("ocamlrun" . typerex-mode))
        ;;          (add-to-list 'interpreter-mode-alist '("ocaml" . typerex-mode))
        ;;          (autoload 'typerex-mode "typerex"
        ;;            "Major mode for editing OCaml code" t)
        ;;          (setq ocp-server-command
        ;;                (concat el-get-dir
        ;;                        "typerex-mode/dist/bin/ocp-wizard"))
        ;;          (setq-default indent-tabs-mode nil)))))

;; emacs server (because emacs daemon isn't working for some reason)
;; (server-start)

;; setup opam exec-path
(add-to-list
 'exec-path
 (replace-regexp-in-string
  "\n$" ""
  (shell-command-to-string "opam config var bin")))

(add-to-list 'exec-path "/usr/local/bin")

(defvar opam-lib
      (let* ((p (shell-command-to-string "opam config var lib"))
	     (l (- (length p) 1)))
	(substring p 0 l)))

(defvar opam-bin
      (let* ((p (shell-command-to-string "opam config var bin"))
	     (l (- (length p) 1)))
	(substring p 0 l)))

(defvar opam-share
      (let* ((p (shell-command-to-string "opam config var share"))
	     (l (- (length p) 1)))
	(substring p 0 l)))

(defvar opam-emacs (concat opam-share "/emacs/site-lisp"))

(add-to-list 'load-path opam-emacs)

(setq exec-path (cons opam-bin exec-path))

;(setq tuareg-interactive-program "opam config exec ocaml")

;; OCamlSpotter
(let* ((f (concat opam-emacs "/ocamlspot.el")))
  (if (file-exists-p f)
      (progn
	(require 'ocamlspot)
	(autoload 'utop "utop" "Toplevel for OCaml" t)
	;; (autoload 'utop-setup-ocaml-buffer "opam config exec utop" "Toplevel for OCaml" t)
	;; (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
	;; (add-hook 'typerex-mode-hook 'utop-setup-ocaml-buffer)
	)))

(let* ((f (concat opam-emacs "/utop.el")))
  (if (file-exists-p f)
      (progn
	(autoload 'utop "utop" "Toplevel for OCaml" t)
	)))

; Set OPAM environment variables
(defun opam-setup ()
  "Call 'opam config env' to set up PATH"
  (interactive)
  (dolist (var (car (read-from-string
		     (shell-command-to-string "opam config env --sexp"))))
    (setenv (car var) (cadr var))))

;; (opam-setup)

;; Settings

(add-to-list 'auto-mode-alist '("\\.spec.in" . 'shell-script-mode))

(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

(setq inhibit-splash-screen 't)
(setq make-backup-files 'nil)
(setq transient-mark-mode 't)
(setq column-number-mode 't)
(setq display-time-day-and-date 't)

(ido-mode)
(subword-mode)
;(color-theme-solarized-dark)
(display-time)
(show-paren-mode)

;; New key combinations:
(global-set-key (kbd "RET")           'newline-and-indent)
(global-set-key (kbd "M-<backspace>") 'delete-trailing-whitespace)
;(global-set-key "\M-\d" 'delete-trailing-whitespace) ; for some terminals
(global-set-key (kbd "S-<backspace>") 'delete-backward-char)
;; (global-set-key (kbd "C-S-v")         'scroll-down)
(global-set-key [f12]                 'menu-bar-mode)
(global-set-key (kbd "C-j")           'open-line)

;; (defun scroll-up-1 ()
;;   (interactive)
;;   (scroll-up 1))

;; (defun scroll-down-1 ()
;;   (interactive)
;;   (scroll-down 1))

(defun scroll-up-half ()
  (interactive)
  (scroll-up (/ (window-height) 2)))

(defun scroll-down-half ()
  (interactive)
  (scroll-down (/ (window-height) 2)))

(global-set-key (kbd "C-,") 'scroll-down-line)
(global-set-key (kbd "C-.") 'scroll-up-line)

(global-set-key (kbd "C-<") 'scroll-down-half)
(global-set-key (kbd "C->") 'scroll-up-half)

(defun other-window-rev ()
  (interactive)
  (other-window -1))

(global-set-key (kbd "C-x C-o") 'other-window-rev)

;; Helper functions for mode hooks
(defun set-programming-options ()
  (interactive)
  (hs-minor-mode)
  (subword-mode)
  (set-variable 'show-trailing-whitespace 't)
  (set-variable 'tab-width 2)
  (font-lock-add-keywords
   nil
   '(("\\<\\(FIXME\\|TODO\\|BUG\\|XXX\\)" 1 font-lock-warning-face t)))
  (local-set-key (kbd "RET") 'newline-and-indent))

(require 'uniquify) ;; http://www.emacswiki.org/emacs/uniquify
(setq uniquify-buffer-name-style `post-forward)
(setq uniquify-min-dir-content 2)


;; http://www.emacswiki.org/emacs/TransposeWindows
(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows) 1)) (message "You can't rotate a single window!"))
        (t
         (let ((i 1)
               (numWindows (count-windows)))
           (while  (< i numWindows)
             (let* (
                    (w1 (elt (window-list) i))
                    (w2 (elt (window-list) (+ (% i numWindows) 1)))

                    (b1 (window-buffer w1))
                    (b2 (window-buffer w2))

                    (s1 (window-start w1))
                    (s2 (window-start w2))
                    )
               (set-window-buffer w1  b2)
               (set-window-buffer w2 b1)
               (set-window-start w1 s2)
               (set-window-start w2 s1)
               (setq i (1+ i))))))))

(global-set-key (kbd "C-x ]") 'rotate-windows)

(defun reindent-fix-whitespace ()
  (interactive)
  (indent-region (point-min) (point-max))
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace))

(global-set-key (kbd "C-M-|") 'reindent-fix-whitespace)
(put 'scroll-left 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(safe-local-variable-values (quote ((eval local-set-key (kbd "C-c C-c") (quote compile)) (eval set-local-key (kbd "C-c C-c") (quote compile))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
