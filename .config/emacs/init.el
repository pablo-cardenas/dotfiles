(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(prefer-coding-system 'utf-8-unix)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(add-to-list 'package-selected-packages 'dash)
(add-to-list 'package-selected-packages 'lsp-mode)
(add-to-list 'package-selected-packages 'magit-section)
(add-to-list 'package-selected-packages 'telega)
(package-initialize)
; (package-refresh-contents)
; (package-install-selected-packages 'no-confirm)

(add-to-list 'load-path "~/dox/dev/lean4-mode")
(require 'lean4-mode)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-capture-templates
      `(("a"
	 "Task"
	 entry
	 (file+headline "tasks" "Tasks")
	 "* TODO %?\n  %u\n  %a")
	("j"
	 "journal Entry"
	 entry
	 (file+olp+datetree "journal.org")
	 "* %?"
	 :empty-lines 1)
	))

(setenv "HOME" "c:/Users/pablo.cardenas/")

(setq telega-directory (expand-file-name "~/.local/share/telega")
    telega-database-dir (expand-file-name "~/.local/share/telega")
    telega-cache-dir (expand-file-name "~/.cache/telega/cache")
    telega-temp-dir (expand-file-name "~/.cache/telega/temp")
)
(add-hook 'telega-load-hook 'telega-notifications-mode)
