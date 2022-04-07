# IMAP
set imap_user = "pablocb2303@gmail.com"

set folder = "imaps://${imap_user}@imap.gmail.com/"
set trash = "+[Gmail]/Corbeille"
set postponed = "+[Gmail]/Brouillons"


# SMPT
set hostname = "gmail.com"


source "~/.mutt/conf.d/google.muttrc"
