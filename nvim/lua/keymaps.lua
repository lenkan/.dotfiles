vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

vim.keymap.set('n', '<leader>/', '<C-w>v', { desc = 'Split right' })
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Split below' })

local function is_editor_win(win) return vim.api.nvim_win_get_config(win).relative == '' and vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'NvimTree' end

vim.keymap.set('n', '<leader>x', function()
  local editors = vim.tbl_filter(is_editor_win, vim.api.nvim_tabpage_list_wins(0))
  if #editors <= 1 and vim.fn.tabpagenr '$' == 1 and is_editor_win(0) then return vim.notify 'Last window' end
  vim.cmd.close()
end, { desc = 'Close window' })

vim.keymap.set('n', '<leader>z', function()
  local orig = vim.t.zoom
  if orig then
    local buf, view = vim.api.nvim_get_current_buf(), vim.fn.winsaveview()
    vim.cmd.tabclose()
    if vim.api.nvim_win_is_valid(orig) then
      vim.api.nvim_set_current_win(orig)
      vim.api.nvim_win_set_buf(orig, buf)
      vim.fn.winrestview(view)
    end
  elseif is_editor_win(0) then
    local win = vim.api.nvim_get_current_win()
    vim.cmd 'tab split'
    vim.t.zoom = win
  end
end, { desc = 'Zoom window' })

vim.keymap.set({ 'n', 'x', 'o' }, 'ö', '[', { remap = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'ä', ']', { remap = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'Ö', '{')
vim.keymap.set({ 'n', 'x', 'o' }, 'Ä', '}')
vim.keymap.set({ 'n', 'x', 'o' }, '¤', '$')

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
