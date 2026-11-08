vim.pack.add {
  -- Lua helpers Telescope depends on. The last tag is from 2023.
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  -- Fuzzy finder for files, grep, buffers, LSP results
  {
    src = 'https://github.com/nvim-telescope/telescope.nvim',
    version = vim.version.range '*',
  },
}

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Symbols in file' })
vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Symbols in workspace' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
