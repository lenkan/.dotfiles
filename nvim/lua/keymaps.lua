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

-- Show nvim/cheatsheet.md in a popup
vim.keymap.set('n', '<leader>?', function()
  local buf = vim.fn.bufadd(vim.fn.stdpath 'config' .. '/cheatsheet.md')
  vim.fn.bufload(buf)
  vim.bo[buf].modifiable = false
  local width, height = math.min(90, vim.o.columns - 4), math.min(vim.api.nvim_buf_line_count(buf), vim.o.lines - 4)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = 'rounded',
  })
  vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf })
end, { desc = 'Cheat sheet' })

-- Leave the built-in terminal with Esc Esc instead of <C-\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
