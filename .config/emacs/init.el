(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)


(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(require 'org-drill)
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-capture-templates
      `(("a"
	 "Task"
	 entry
	 (file+headline "tasks" "Tasks")
	 "* TODO %?\n  %u\n  %a")
	("e"
	 "Drill"
	 entry
	 (file+headline "" "Emacs")
	 ,(concat "** Item %^{mode}:	:" (format "%s" org-drill-question-tag) ":\n:PROPERTIES:\n:DRILL_CARD_TYPE: twosided\n:DATE_ADDED: %u\n:END:\n\n*** Key Sequence\n%^{key_sequence}\n\n*** Description\n%^{description}")
	 :empty-lines 1
	 :immediate-finish t)
	("l" "Linux")
	("lb"
	 "Linux commands"
	 entry
	 (file+headline "" "Linux")
	 ,(concat "** %^{topic}:	:" (format "%s" org-drill-question-tag) ":\n:PROPERTIES:\n:DATE_ADDED: %u\n:END:\n\n%^{question}\n\n*** Answer\n%^{answer}")
	 :empty-lines 1
	 :immediate-finish t)
	("lf"
	 "Linux fod"
	 entry
	 (file+headline "" "Linux")
	 ,(concat "** %^{topic}:	:" (format "%s" org-drill-question-tag) ":\n:PROPERTIES:\n:DATE_ADDED: %u\n:END:\n\n*** flag\n%^{flag}\n\n*** option\n%^{option}\n\n*** description\n%?")
	 :empty-lines 1)
	("j"
	 "journal Entry"
	 entry
	 (file+datetree "journal.org")
	 "* %?"
	 :empty-lines 1)
	))

(setq telega-directory (expand-file-name "~/.local/share/telega")
    telega-database-dir (expand-file-name "~/.local/share/telega")
    telega-cache-dir (expand-file-name "~/.cache/telega/cache")
    telega-temp-dir (expand-file-name "~/.cache/telega/temp")
)
