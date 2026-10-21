# Cheat sheet (q to close)

## Find
Space ff          files
Space fg          grep
Space Space       open buffers
Space fd          diagnostics
Space fc          commands
Space fh          help

## Windows
Ctrl-w v / s      split right / below
Ctrl-h/j/k/l      move between splits
Ctrl-w q          close split
Ctrl-w o          close all others
Ctrl-w =          even out sizes
Ctrl-w _ / |      maximise height / width
\                 file tree (g? for its keys)
Space fe          reveal current file in tree

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
]d / [d           next / previous diagnostic

## Completion
Ctrl-n / Ctrl-p   select
Ctrl-y            accept
Tab               accept Copilot suggestion
Alt-] / Alt-[     next / previous Copilot
Ctrl-]            dismiss Copilot

## Git
]h / [h           next / previous hunk
Space hp          preview hunk
Space hs / hr     stage / reset hunk
Space hb          blame line
git difftool -d   diff all files (alias gd)

## Claude
:ClaudeCodeStart  then /ide in claude
Space as          send selection / tree file
:w / :q           accept / reject a diff

## Database
Space db          sidebar (A add conn, ? help)
Space df          attach this .sql to a conn
Space dr          run query under cursor / selection
Space dR          run whole buffer
:w                format (doesn't run)

## Misc
:restart          restart nvim, keep session
:terminal         shell (Esc Esc to leave)
r in tree         rename file, fixes imports
:wa               save the files it changed
