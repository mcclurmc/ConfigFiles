(defun align-ocaml-pattern (p1 p2)
  (interactive "r")
  (align-regexp p1 p2 "->"))
  
;; https://github.com/def-lkb/merlin
(push (concat (substring (shell-command-to-string "opam config var share") 0 -1)
	      "/emacs/site-lisp")
      load-path)
(setq merlin-command
      (concat (substring (shell-command-to-string "opam config var bin") 0 -1)
	      "/ocamlmerlin"))

(autoload 'merlin-mode "merlin" "Merlin mode" t)
(setq merlin-use-auto-complete-mode t)

;(add-hook 'caml-mode-hook 'merlin-mode)

(add-hook 'tuareg-mode-hook 
	  (lambda ()
            ;; (local-set-key "\C-c;" 'ocamlspot-query)
	    ;; (local-set-key "\C-c:" 'ocamlspot-query-interface)
            ;; (local-set-key "\C-c'" 'ocamlspot-query-uses)
            ;; (local-set-key "\C-c\C-t" 'ocamlspot-type)
            ;; (local-set-key "\C-c\C-i" 'ocamlspot-xtype)
            ;; (local-set-key "\C-c\C-y" 'ocamlspot-type-and-copy)
            ;; (local-set-key "\C-cx" 'ocamlspot-expand)
            ;; (local-set-key "\C-c\C-u" 'ocamlspot-use)
            ;; (local-set-key "\C-ct" 'caml-types-show-type)
            ;; (local-set-key "\C-cp" 'ocamlspot-pop-jump-stack)
	    (tuareg-type-indent 2)
	    (setq 'tab-width 2)
	    (merlin-mode)
	    (set-programming-options)))

(add-hook 'tuareg-mode-hook 'merlin-mode)
