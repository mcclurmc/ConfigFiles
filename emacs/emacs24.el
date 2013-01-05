;; el-get is awesome!
;; https://github.com/dimitri/el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-user-package-directory "~/.emacs.d/el-get-init-files/")

(setq el-get-sources
      '(el-get
        (:name typerex-mode
               :type git
               :url "git://github.com/OCamlPro/typerex.git"
               :description "Development Studio for OCaml"
               :build
               (("mkdir" "-p" "dist/bin")
                ("mkdir" "-p" "dist/elisp")
                "./configure --bindir `pwd`/dist/bin"
                ("make")
                ("make" "install-binaries")
                "EMACSDIR=./dist/elisp make -e install-emacs")
               ; :compile ("./dist/elisp/typerex.elc")
               :load-path ("./dist/elisp")
               :depends (auto-complete popup fuzzy)
               :prepare
               (progn
                 (add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . typerex-mode))
                 (add-to-list 'interpreter-mode-alist '("ocamlrun" . typerex-mode))
                 (add-to-list 'interpreter-mode-alist '("ocaml" . typerex-mode))
                 (autoload 'typerex-mode "typerex"
                   "Major mode for editing OCaml code" t)
                 (setq ocp-server-command
                       (concat el-get-dir
                               "typerex-mode/dist/bin/ocp-wizard"))
                 (setq-default indent-tabs-mode nil)))))

(el-get 'sync)

;; emacs server (because emacs daemon isn't working for some reason)

(server-start)

;; Settings

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
(color-theme-solarized-dark)
(display-time)
(show-paren-mode)

;; New key combinations:
(global-set-key (kbd "RET")           'newline-and-indent)
(global-set-key (kbd "M-<backspace>") 'delete-trailing-whitespace)
(global-set-key (kbd "S-<backspace>") 'delete-backward-char)
(global-set-key (kbd "C-S-v")         'scroll-down)
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
  (set-variable 'show-trailing-whitespace 't)
  (set-variable 'tab-width 2)
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