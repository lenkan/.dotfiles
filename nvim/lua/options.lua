vim.o.number = true

-- The mode is already shown in the statusline
vim.o.showmode = false

-- Scheduled because detecting the clipboard provider slows down startup
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- shiftwidth=0 makes >> and auto-indent follow tabstop. guess-indent overrides both per file.
vim.o.tabstop = 4
vim.o.shiftwidth = 0

vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

-- Also how long the cursor must rest before CursorHold fires `checktime` (autocmds.lua)
vim.o.updatetime = 250

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true
vim.o.scrolloff = 10

vim.o.confirm = true
