(setq doom-font (font-spec :family "Source Code Pro" :size 12 :weight 'semi-light))
(setq org-directory "~/src/notes/org/")
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
