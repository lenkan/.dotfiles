local M = {}

function M.toggle_zoom()
  if vim.t.zoom_restore then
    vim.cmd(vim.t.zoom_restore)
    vim.t.zoom_restore = nil
  else
    vim.t.zoom_restore = vim.fn.winrestcmd()
    vim.cmd 'wincmd _ | wincmd |'
  end
end

return M
