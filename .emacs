(x-focus-frame nil)
(setq load-path (cons "~/.emacs.d" load-path))

(setq load-path (cons "~/github/js3-mode" load-path))

(autoload 'js3-mode "js3" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))

(setq inhibit-splash-screen t)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default t)
 '(backup-by-copying-when-linked t)
 '(backup-by-copying-when-mismatch t)
 '(column-number-mode t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(enable-multibyte-characters t t)
 '(initial-major-mode (quote fundamental-mode))
 '(initial-scratch-message "")
 ;; '(js3-curly-indent-offset 2)
 ;; '(js3-expr-indent-offset 2)
 ;; '(js3-lazy-commas t)
 ;; '(js3-lazy-semicolons t)
 ;; '(js3-lazy-dots t)
 ;; '(js3-lazy-operators t)
 ;; '(js3-paren-indent-offset 2)
 ;; '(js3-square-indent-offset 2)
 ;; '(js3-consistent-level-indent-inner-bracket t)
 ;; '(js3-mode-dev-mode-p t)
 '(js3-strict-missing-semi-warning t)
 '(js3-auto-indent-p t)
 '(js3-enter-indents-newline t)
 '(js3-indent-on-enter-key t)
 '(scroll-step 1)
 '(transient-mark-mode nil))

;; ;; custom config for @deedubs
;; (custom-set-variables
;;  '(js3-auto-indent-p t)
;;  '(js3-enter-indents-newline t)
;;  ;;'(js3-indent-on-enter-key t)
;;  '(js3-indent-tabs-mode t)
;;  '(js3-mirror-mode t)
;;  '(js3-indent-dots t)
;;  '(js3-indent-commas t)
;;  '(js3-lazy-commas t)
;;  '(js3-lazy-dots t)
;;  '(js3-mode-dev-mode-p t) ;;added by Thom
;;  '(js3-expr-indent-offset 0)
;;  '(js3-paren-indent-offset 0)
;;  '(js3-square-indent-offset 0)
;;  '(js3-curly-indent-offset 0))

(defun init-macro-counter-default ()
  "Set the initial counter to 1 and reset every time it's called.
To set to a different value call `kmacro-set-counter' interactively
i.e M-x kmacro-set-counter."
  (interactive)
  (kmacro-set-counter 1))

(global-set-key (kbd "<f4>") 'kmacro-set-format)
(global-set-key (kbd "<f5>") 'kmacro-insert-counter)
(global-set-key (kbd "<f6>") 'kmacro-set-counter)
(global-set-key (kbd "M-<f6>") 'init-macro-counter-default)

;; Taken from the comment section in inf-ruby.el
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq line-move-visual nil)

(global-set-key [(control x)(left)]  'other-window)
(global-set-key [(control x)(right)] 'other-window)

(define-generic-mode 'ebnf-mode
 () ;; comment char: inapplicable because # must be at start of line
 nil ;; keywords
 '(
   ("\(\\*.*\\*\)" . 'font-lock-comment-face)
   ("^[^[:blank:]]+" . 'font-lock-function-name-face)
   )
 '("\\.rd\\'") ;; filename suffixes
 nil ;; extra function hooks
 "Major mode for EBNF highlighting.")
(modify-frame-parameters
 (selected-frame)
 '((font . "-*-monaco-*-*-*-*-10-*-*-*-*-*-*")))

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (modify-frame-parameters
             frame
             '((font . "-*-monaco-*-*-*-*-10-*-*-*-*-*-*")))))

(autoload 'js3-mode "js3" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))

(autoload 'json-mode "json-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(show-paren-mode t)

(custom-set-variables
 '(initial-major-mode 'fundamental-mode)
 '(initial-scratch-message "")
)

(defun whitespace-hook ()
  "before-safe-hook for delete-trailing-whitespace: include modes here that should not have this applied"
  (if (or
       (string= major-mode "markdown-mode"))
      nil
    (delete-trailing-whitespace)))

(setq before-save-hook #'whitespace-hook)

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(defun org-sort-multi (&rest sort-types)
  "Sort successively by a list of criteria, in descending order of importance. For example, sort first by TODO status, then by priority, then by date, then alphabetically, case-sensitive. Each criterion is either a character or a cons pair (BOOL . CHAR), where BOOL is whether or not to sort case-sensitively, and CHAR is one of the characters defined in ``org-sort-entries-or-items''.
So, the example above could be accomplished with:
 (org-sort-multi ?o ?p ?t (t . ?a))"
  (mapc #'(lambda (sort-type)
	    (org-sort-entries-or-items
	     (car-safe sort-type)
	     (or (cdr-safe sort-type) sort-type)))
	(reverse sort-types)))

(defun org-sort-good ()
  "sort org-mode the way I like"
  (interactive)
  (org-sort-multi ?o ?p ?a))

(defun org-sort-good-hk (state)
  "Hook for sorting"
  (when (and (not (equal state 'overview)) (not (equal state 'folded)))
    (org-sort-good)))

(add-hook 'org-cycle-hook 'org-sort-good-hk)
