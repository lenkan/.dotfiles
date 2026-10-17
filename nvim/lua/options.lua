-- See `:help vim.o` and `:help option-list`

vim.o.number = true
vim.o.mouse = 'a'

-- The mode is already shown in the statusline
vim.o.showmode = false

-- Share the system clipboard (like vim.useSystemClipboard in VS Code).
-- Scheduled because detecting the clipboard provider can slow down startup.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Show tabs 4 columns wide (default 8). shiftwidth=0 makes >> and auto-indent follow it.
-- guess-indent still switches to spaces in files indented with spaces.
vim.o.tabstop = 4
vim.o.shiftwidth = 0

vim.o.breakindent = true
vim.o.undofile = true

-- Case-insensitive search unless the pattern has a capital letter or \C
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

-- Also how long the cursor must rest before CursorHold fires `checktime` (autocmds.lua)
vim.o.updatetime = 250

vim.o.splitright = true
vim.o.splitbelow = true

-- Show tabs, trailing spaces and non-breaking spaces
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- While typing :s, also list matches that are off screen in a split
vim.o.inccommand = 'split'

vim.o.cursorline = true
vim.o.scrolloff = 10

-- Ask to save instead of failing on :q with unsaved changes
vim.o.confirm = true
