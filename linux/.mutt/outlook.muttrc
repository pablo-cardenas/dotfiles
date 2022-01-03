# IMAP
set imap_user = "pablo-cardenas@outlook.com"
set imap_pass = "`pass show microsoft/pablo-cardenas@outlook.com | head -n 1`"

set folder = imaps://pablo-cardenas@outlook.com@outlook.office365.com
set spoolfile = +INBOX
set record = +Sent
set trash = +Deleted
set postponed = +Drafts


# SMPT
set smtp_url = smtps://pablo-cardenas@outlook.com@smtp-mail.outlook.com
set smtp_pass = "`pass show microsoft/pablo-cardenas@outlook.com | head -n 1`"

set from = pablo-cardenas@outlook.com
set realname = "Pablo Cárdenas"
set hostname = outlook.com

set ssl_force_tls = yes
unset ssl_starttls


# Hook
account-hook $folder "set imap_user='pablo-cardenas@outlook.com' imap_pass='`pass show microsoft/pablo-cardenas@outlook.com | head -n 1`'"
