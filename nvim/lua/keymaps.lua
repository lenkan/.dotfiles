local function show_all_keymaps()
  require('which-key').show()
end

-- Maximizes the current window; again restores the previous sizes
local function toggle_zoom()
  if vim.t.zoom_restore then
    vim.cmd(vim.t.zoom_restore)
    vim.t.zoom_restore = nil
  else
    vim.t.zoom_restore = vim.fn.winrestcmd()
    vim.cmd 'wincmd _ | wincmd |'
  end
end

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })
vim.keymap.set('n', '<leader>/', '<C-w>v', { desc = 'Split right' })
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Split below' })
vim.keymap.set('n', '<leader>z', toggle_zoom, { desc = 'Zoom window (toggle)' })
vim.keymap.set('n', '<leader>q', '<C-w>c', { desc = 'Close split' })
vim.keymap.set({ 'n', 'x', 'o' }, 'ö', '[', { remap = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'ä', ']', { remap = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'Ö', '{')
vim.keymap.set({ 'n', 'x', 'o' }, 'Ä', '}')
vim.keymap.set({ 'n', 'x', 'o' }, '¤', '$')
vim.keymap.set('n', '<leader>?', show_all_keymaps, { desc = 'All keymaps' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Like :only, but for buffers. Unsaved buffers and terminals are left alone.
vim.api.nvim_create_user_command('BufOnly', function()
  local current, deleted = vim.api.nvim_get_current_buf(), 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bo = vim.bo[buf]
    if buf ~= current and bo.buflisted and bo.buftype ~= 'terminal' and not bo.modified then
      if pcall(vim.api.nvim_buf_delete, buf, {}) then
        deleted = deleted + 1
      end
    end
  end
  vim.notify(('Deleted %d buffer(s)'):format(deleted))
end, { desc = 'Delete all buffers except the current one' })
