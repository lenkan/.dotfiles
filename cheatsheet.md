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

F1                list this picker's keys
Ctrl+O            hide / show the preview
Ctrl+F Ctrl+B     scroll preview forward / back half a page
Ctrl+N Ctrl+P     next / previous result
Ctrl+V Ctrl+S     open in vertical / horizontal split (Ctrl+T tab)
Tab  Alt+A        mark one / all, Enter sends them to quickfix (]q [q, :cdo s/a/b/ | update)
Alt+H  Alt+I      files only: show hidden / gitignored
text -- *.ts      grep only: limit to a glob (!*.test.ts excludes)
Ctrl+G            grep only: switch to fuzzy filtering the results

Query syntax is the same as fzf in bash, below.

## fzf in bash

Ctrl+R            search history
Ctrl+T            insert a file path
Alt+C             cd into a subdirectory
vim **<Tab>       fuzzy-complete files (cd dirs, kill processes, ssh hosts)
cmd | fzf --preview 'git show --color {1}'   preview any list (here: git log --oneline)

lsp lua           both words, any order
'text             exact, not fuzzy
^text  text$      at the start / at the end (.lua$)
!text             exclude
a | b             either
