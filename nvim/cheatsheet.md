# Cheat sheet  (q to close, edit nvim/cheatsheet.md to change)

## Find                                  ## Windows
Space ff    files                        Ctrl-w v / s   split right / below
Space fg    grep                         Ctrl-h/j/k/l   move between splits
Space Space open buffers                 Ctrl-w q       close split
Space fd    diagnostics                  Ctrl-w o       close all others
Space fc    commands (palette)           Ctrl-w =       even out sizes
Space fh    help                         Ctrl-w _ / |   maximise height / width
                                         \              file tree (g? for its keys)
## Code
gd          definition                   ## Buffers
K           hover docs                   Ctrl-o / Ctrl-i  jump back / forward
grr / gri   references / implementation  Ctrl-^          previous file
grn         rename                       :bd             close buffer
gra         code actions
grq         quick fix for this problem   ## Edit
gO / gW     symbols in file / workspace  gcc / gc       toggle comment (line / selection)
:Format     format (also Space cf)       :noa w         save without formatting
:FixAll     apply all auto-fixes         :%s/a/b/g      replace in file
:OrganizeImports                         u / Ctrl-r     undo / redo

## Problems                              ## Git
]d / [d     next / previous diagnostic   ]h / [h        next / previous hunk
                                         Space hp       preview hunk
                                         Space hs / hr  stage / reset hunk
## Completion                            Space hb       blame line
Ctrl-n/p    select   Ctrl-y accept       git difftool -d  diff all files (alias gd)
Tab         accept Copilot suggestion
Alt-] / [   next / previous Copilot      ## Claude (run /ide in claude)
Ctrl-]      dismiss Copilot              Space as   send selection / tree file
                                         :w / :q    accept / reject a diff
## Misc
:restart    restart nvim, keep session   :terminal   shell (Esc Esc to leave)
r in tree   rename file, fixes imports   :wa         save the files it changed
