-- The global keymaps. The file tree's and SQL buffers' own keys are in config/tree.lua and config/database.lua.
-- describe() only relabels one of Neovim's own keys, whose descriptions are often a function name or :help tag.

local describe = require('lib.keymap').describe
local diagnostics = require 'config.diagnostics'
local fzf = require 'fzf-lua'
local git = require 'config.git'
local gitsigns = require 'gitsigns'
local lsp = require 'config.lsp'
local window = require 'lib.window'

-- [[ Windows ]]

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-w>/', '<C-w>v', { desc = 'Split window right' })
vim.keymap.set('n', '<C-w>-', '<C-w>s', { desc = 'Split window below' })
vim.keymap.set('n', '<C-w>z', window.toggle_zoom, { desc = 'Zoom window (toggle)' })

-- [[ Picker ]]

vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Help' })
vim.keymap.set('n', '<leader>fS', fzf.lsp_live_workspace_symbols, { desc = 'Symbols in workspace' })
vim.keymap.set('n', '<leader>fd', fzf.git_status, { desc = 'Changed files' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>f?', fzf.builtin, { desc = 'All pickers' })
vim.keymap.set('n', '<leader>?', fzf.keymaps, { desc = 'All keymaps' })

-- [[ LSP ]]

vim.keymap.set('n', 'gd', fzf.lsp_definitions, { desc = 'LSP: Go to definition' })
vim.keymap.set('n', 'grr', fzf.lsp_references, { desc = 'LSP: References' })
vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { desc = 'LSP: Symbols in file' })
describe('n', 'gra', 'LSP: Code action')
describe('x', 'gra', 'LSP: Code action')
describe('n', 'grn', 'LSP: Rename')
describe('n', 'gri', 'LSP: Go to implementation')
describe('n', 'grt', 'LSP: Go to type definition')
describe('n', 'grx', 'LSP: Run code lens')
describe('i', '<C-s>', 'LSP: Signature help')
describe('s', '<C-s>', 'LSP: Signature help')

-- [[ File tree ]]

vim.keymap.set('n', '\\', '<Cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file tree' })

-- [[ Problems ]]

vim.keymap.set('n', '<leader>pl', fzf.diagnostics_document, { desc = 'List problems in file' })
vim.keymap.set('n', '<leader>pL', fzf.diagnostics_workspace, { desc = 'List all problems' })
vim.keymap.set('n', '<leader>py', diagnostics.copy_problem_message, { desc = 'Copy problem message' })
vim.keymap.set('n', '<leader>pv', diagnostics.toggle_virtual_text, { desc = 'Toggle problems at end of line' })
describe('n', ']d', 'Next problem')
describe('n', '[d', 'Previous problem')
describe('n', ']D', 'Last problem')
describe('n', '[D', 'First problem')
describe('n', '<C-w>d', 'Show problem under cursor')
describe('n', '<C-w><C-d>', 'Show problem under cursor')

-- [[ Lists ]]

describe('n', ']q', 'Next quickfix item')
describe('n', '[q', 'Previous quickfix item')
describe('n', ']Q', 'Last quickfix item')
describe('n', '[Q', 'First quickfix item')
describe('n', ']<C-q>', 'Next quickfix file')
describe('n', '[<C-q>', 'Previous quickfix file')
describe('n', ']l', 'Next location list item')
describe('n', '[l', 'Previous location list item')
describe('n', ']L', 'Last location list item')
describe('n', '[L', 'First location list item')
describe('n', ']<C-l>', 'Next location list file')
describe('n', '[<C-l>', 'Previous location list file')
describe('n', ']b', 'Next buffer')
describe('n', '[b', 'Previous buffer')
describe('n', ']B', 'Last buffer')
describe('n', '[B', 'First buffer')
describe('n', ']a', 'Next argument list file')
describe('n', '[a', 'Previous argument list file')
describe('n', ']A', 'Last argument list file')
describe('n', '[A', 'First argument list file')
describe('n', ']t', 'Next tag match')
describe('n', '[t', 'Previous tag match')
describe('n', ']T', 'Last tag match')
describe('n', '[T', 'First tag match')
describe('n', ']<C-t>', 'Next tag match in preview window')
describe('n', '[<C-t>', 'Previous tag match in preview window')
describe('n', ']<Space>', 'Add empty line below')
describe('n', '[<Space>', 'Add empty line above')

-- [[ Editing ]]

vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set({ 'n', 'x', 'o' }, 'ö', '[', { remap = true, desc = 'Same as [' })
vim.keymap.set({ 'n', 'x', 'o' }, 'ä', ']', { remap = true, desc = 'Same as ]' })
vim.keymap.set({ 'n', 'x', 'o' }, 'Ö', '{', { desc = 'Previous paragraph' })
vim.keymap.set({ 'n', 'x', 'o' }, 'Ä', '}', { desc = 'Next paragraph' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
describe('n', 'Y', 'Yank to end of line')
describe('n', '&', 'Repeat last substitute, with its flags')
describe('x', '*', 'Search for selection forward')
describe('x', '#', 'Search for selection backward')
describe('x', '@', 'Run macro on each selected line')
describe('x', 'Q', 'Run last recorded macro on each selected line')
describe('s', '<Tab>', 'Next snippet field')
describe('s', '<S-Tab>', 'Previous snippet field')
describe('i', '<S-Tab>', 'Previous snippet field')
describe('i', '<C-u>', 'Delete to start of line (undoable)')
describe('i', '<C-w>', 'Delete word before cursor (undoable)')
describe('n', 'gx', 'Open file or URL under cursor')
describe('x', 'gx', 'Open file or URL under cursor')

-- [[ Insert mode ]]

vim.keymap.set('i', '<Tab>', lsp.accept_inline_completion, { expr = true, desc = 'Accept inline completion' })

-- [[ Git ]]

vim.keymap.set('n', ']c', git.next_hunk, { desc = 'Next git hunk' })
vim.keymap.set('n', '[c', git.previous_hunk, { desc = 'Previous git hunk' })
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage file' })
vim.keymap.set('n', '<leader>hU', gitsigns.reset_buffer_index, { desc = 'Unstage file' })
vim.keymap.set('n', '<leader>hb', git.blame_line, { desc = 'Blame line' })
vim.keymap.set('n', '<leader>hd', git.diff_head, { desc = 'Diff against HEAD' })
