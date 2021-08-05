(setq doom-font (font-spec :family "Source Code Pro" :size 12 :weight 'semi-light))
(setq org-directory "~/src/notes/org/")
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
(defun fixed-tree-sitter-langs-install-grammars (&optional skip-if-installed version os keep-bundle) ())
(advice-add 'tree-sitter-langs-install-grammars :override #'fixed-tree-sitter-langs-install-grammars)
(use-package! tree-sitter
  :config
  (cl-pushnew (expand-file-name "~/.tree-sitter") tree-sitter-load-path)
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
