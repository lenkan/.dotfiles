vim.pack.add {
  {
    src = 'https://github.com/nvim-mini/mini.pick',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/nvim-mini/mini.extra',
    version = vim.version.range '*',
  },
}

require('mini.pick').setup()
require('mini.extra').setup()

vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent', { link = 'PmenuSel' })
vim.keymap.set('n', '<leader>ff', '<Cmd>Pick files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', '<Cmd>Pick buffers<CR>', { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', '<Cmd>Pick help<CR>', { desc = 'Help' })
vim.keymap.set('n', '<leader>fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', { desc = 'Symbols in file' })
vim.keymap.set('n', '<leader>fS', '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>', { desc = 'Symbols in workspace' })
vim.keymap.set('n', '<leader>fc', '<Cmd>Pick commands<CR>', { desc = 'Commands' })
