vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Turns off netrw, so nvim-tree alone opens folders
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Options ]]

vim.o.number = true
vim.o.showmode = false
vim.o.clipboard = 'unnamedplus'
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

require 'plugins'

require('mason').setup {}

require 'keymaps'

local tree = require 'config.tree'
local completion = require 'config.completion'
local database = require 'config.database'
local diagnostics = require 'config.diagnostics'
local formatting = require 'config.formatting'
local git = require 'config.git'
local lsp = require 'config.lsp'
local picker = require 'config.picker'
local treesitter = require 'config.treesitter'
local guess_indent = require 'guess-indent'
local which_key = require 'which-key'
local statusline = require 'mini.statusline'

vim.api.nvim_create_user_command('CloseOtherBuffers', '%bd | e# | bd# | normal! `"', {
  desc = 'Close all other buffers',
})

vim.cmd.colorscheme 'vscode'

guess_indent.setup {}

which_key.setup {
  spec = {
    { '<leader>f', group = 'Find' },
    { '<leader>h', group = 'Git' },
    { '<leader>p', group = 'Problems' },
  },
}

statusline.setup {}
git.setup()
treesitter.setup()
picker.setup()
tree.setup()
diagnostics.setup()
lsp.setup()
formatting.setup()
completion.setup()
database.setup()

-- Machine-specific overrides. Must stay last to win.
local local_config = vim.fn.expand '~/.nvim.local.lua'
if vim.uv.fs_stat(local_config) then
  dofile(local_config)
end
