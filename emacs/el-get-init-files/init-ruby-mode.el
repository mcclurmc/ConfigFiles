(require 'rinari)

(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))

(add-hook 'ruby-mode 'rinari-mode)

