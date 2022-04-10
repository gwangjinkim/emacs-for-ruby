; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; list the packages you want
(setq package-list '(better-defaults
                     solarized-theme
                     helm
                     helm-projectile
                     helm-ag
                     ruby-electric
		     rvm
                     seeing-is-believing
                     chruby
                     inf-ruby
                     ruby-test-mode))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'better-defaults)

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'ruby-mode)

(load-theme 'solarized-dark t)

;; Show line numbers
(global-linum-mode)

;; Typography
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 150
                    :weight 'normal
                    :width 'normal)

(require 'helm)
(require 'helm-projectile)
(require 'helm-ag)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "s-f") #'helm-projectile-ag)
(global-set-key (kbd "s-t") #'helm-projectile-find-file-dwim)

;; Autoclose paired syntax elements like parens, quotes, etc
(require 'ruby-electric)
(add-hook 'ruby-mode-hook 'ruby-electric-mode)


(add-to-list 'auto-mode-alist
             '("\\.\\(?:cap\\|gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\(?:Brewfile\\|Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

(rvm-use-default)

;; ;; load theme rbenv
;; (global-rbenv-mode)
;; (rbenv-use-global)

(chruby "2.2.2")

;; $ gem install seeing_is_believing --version 3.0.0.beta.7
(setq seeing-is-believing-prefix "C-.")
(add-hook 'ruby-mode-hook 'seeing-is-believing)
(require 'seeing-is-believing)
;; run seeing is believing for entire file   `C-. s`
;; clear seeing is believing output          `C-. c`
;; tag a line "targeted" for SiB evaluation  `C-. t`
;; run only "tagged" lines trailing "# =>"   `C-. x`
;; evaluates each line


(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
;; launch inf-ruby process                   `C-c C-s`
;; switc to pane                             `C-x o`
;; push marked code to irb                   `C-c C-r`
;; push marked code to irb and focus to it   `C-c M-r`
;; see other bindings inf-ruby gives us      `M-x` (helm-M-x)
;; when Rails or Sinatra run commands in web probject env inf-ruby  inf-ruby-console-rails
;;                                                                  inf-ruby-console-racksh


(require 'ruby-test-mode)
(add-hook 'ruby-mode-hook 'ruby-test-mode)
;; run tests from current file into second buffer `C-c C-,`
;; ruby-test-mode tries to evaluate tests in current buffer - files ending `_test.rb` `_spec.rb`
;; if no test, tries re-run last test
;; or test in another visible window


(add-hook 'compilation-finish-functions
          (lambda (buf strg)
            (switch-to-buffer-other-window "*compilation*")
            (read-only-mode)
            (goto-char (point-max))
            (local-set-key (kbd "q")
                           (lambda () (interactive) (quit-restore-window)))))
;; runs test and jumps to bottom of test buffer


;; to make rails work on emacs -> rinari
;; version control integration -> magit

;; https://worace.works/2016/06/07/getting-started-with-emacs-for-ruby/
