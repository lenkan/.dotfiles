# Bash cheat sheet (q to close)

Open: prefix h in tmux, or `cheat`.

## Bash

/text  n N        search history, next / previous match
_                 insert last argument of the previous command
#                 comment out and save to history, without running
*                 expand the glob under the cursor (rm *.log, Esc *)
p P               paste what you deleted (not the clipboard)

## Editing commands

Ctrl+X Ctrl+E     edit the command line in nvim, :cq to cancel

## History

hr                load other panes' history (for Ctrl+R)
fc                edit the last command in nvim and rerun it
fc curl           ... the last command starting with curl
fc -l             recent commands, numbered
!!  !$            previous command, its last argument
 cmd              leading space: not saved to history
