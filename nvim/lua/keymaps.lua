-- See `:help vim.keymap.set()`. LSP keymaps live in plugins/lsp.lua, Telescope's in
-- plugins/telescope.lua.

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- `[d` / `]d` jump between diagnostics (built in) and open the float on arrival
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  jump = {
    on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false } end,
  },
}

-- VS Code's next/previous problem, alongside ]d / [d (Alt-" is what Shift-Alt-' sends)
vim.keymap.set('n', "<M-'>", function() vim.diagnostic.jump { count = 1 } end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<M-">', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Previous diagnostic' })

-- Leave the built-in terminal with Esc Esc instead of <C-\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
