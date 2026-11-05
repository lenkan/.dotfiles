vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

vim.keymap.set('n', '<leader>?', function()
  local buf = vim.fn.bufadd(vim.fn.stdpath 'config' .. '/cheatsheet.md')
  vim.fn.bufload(buf)
  vim.bo[buf].modifiable = false
  local width, height = math.min(60, vim.o.columns - 4), math.min(vim.api.nvim_buf_line_count(buf), vim.o.lines - 4)
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

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
