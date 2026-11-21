# Cheat sheet (q to close)

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

## Git

git add -p          add hunk by hunk (y / n)
gd                  every changed file as a diff in nvim (git difftool -d)

## Search and replace

fastmod 'old' 'new'                               y / n / A (all the rest), then Enter
fastmod 'old' 'new' --glob '!package-lock.json'   skip files (more: '*.ts' '!*.test.ts')
fastmod 'old' 'new' -e ts,tsx                     only these extensions (not with --glob)
fastmod --accept-all 'old' 'new'                  no questions

rg -l0 'old' | xargs -0 sd -p 'old' 'new'         preview
rg -l0 'old' | xargs -0 sd 'old' 'new'            apply, rg -g / paths pick the files

Same regex as rg in both:
'console\.log\((.*)\)' 'logger.debug(${1})'   groups
'\bold\b'                                      whole word
-F                                             no regex, match the text as is

## Neovim picker (Space ff files, Space fg grep)

Tab               show / hide preview
Ctrl+F Ctrl+B     scroll preview forward / back a page
Ctrl+N Ctrl+P     next / previous result
Ctrl+V Ctrl+S     open in vertical / horizontal split
Ctrl+X Ctrl+A     mark one / all, then Alt+Enter sends them to quickfix (]q [q, :cdo s/a/b/)
Ctrl+O            grep only: limit to a glob (*.ts, !*.test.ts)
Ctrl+E            grep only: switch fixed text / regex / case-sensitive

lsp lua           both words, in that order with anything between
'text             exact, no gaps
^text  text$      at the start / at the end (.lua$)

:Pick resume                       reopen the last picker as you left it
:Pick oldfiles                     recent files
:Pick keymaps                      find a mapping you forgot
:Pick git_files scope='modified'   changed files only
:Pick git_hunks                    every change, with its diff
