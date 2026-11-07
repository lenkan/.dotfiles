# Cheat sheet (q to close)

## Find
Space ff          files
Space fg          grep
Space Space       open buffers
Space fc          commands
Space fh          help
Space fs / fS     symbols in file / workspace

## Swedish keys
ö / ä             [ / ]  (öd / äd, öh / äh, ...)
Ö / Ä             { / }  paragraph up / down
¤                 $  end of line

## Windows
Space / or -      split right / below
Ctrl-h/j/k/l      move between splits
Space x           close split
Space z           zoom split (again to restore)
Ctrl-w o          close all others
Ctrl-w =          even out sizes
Space e or \      file tree (g? for its keys)
Space fe          reveal current file in tree
w in tree         toggle wide mode (40 / 80)

## Buffers
Ctrl-o / Ctrl-i   jump back / forward
Ctrl-^            previous file
:bd               close buffer

## Code
gd                definition
K                 hover docs
grr / gri         references / implementation
grn               rename
gra               code actions
grq               quick fix for this problem
gO / gW           symbols in file / workspace
:Format           format (also Space cf)
:FixAll           apply all auto-fixes
:OrganizeImports  sort imports

## Edit
gcc / gc          toggle comment (line / selection)
:noa w            save without formatting
:%s/a/b/g         replace in file
u / Ctrl-r        undo / redo

## Problems
äd / öd           next / previous problem
äe / öe           next / previous error
Space pp          show problem popup
Space pf          fix problem
Space pl / pL     list in file / everywhere
Space py          copy message
Space pv          toggle full messages under line

## Completion
Ctrl-n / Ctrl-p   select
Ctrl-y            accept
Tab               accept Copilot suggestion
Alt-] / Alt-[     next / previous Copilot
Ctrl-]            dismiss Copilot

## Git
äh / öh           next / previous hunk
Space hp          preview hunk
Space hs / hr     stage / reset hunk
Space hb          blame line
git difftool -d   diff all files (alias gd)

## Claude
:ClaudeCodeStart  then /ide in claude
Space as          send selection / tree file
:w / :q           accept / reject a diff

## Database
:DBUIToggle       sidebar (A add conn, ? help)
:DBUIFindBuffer   attach this .sql to a conn
Space r           run query under cursor / selection
Space R           run whole buffer
:w                format (doesn't run)

## Misc
:restart          restart nvim, keep session
:terminal         shell (Esc Esc to leave)
r in tree         rename file, fixes imports
:wa               save the files it changed
