vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim', -- Lua helpers Telescope depends on
  'https://github.com/nvim-telescope/telescope.nvim', -- Fuzzy finder for files, grep, buffers, LSP results
}

-- Inside a picker, <C-/> (insert) or ? (normal) lists its keys
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands (like the command palette)' })
