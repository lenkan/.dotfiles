local M = {}

-- Relabels one of Neovim's own keys. mapset() re-creates the key from what maparg() reports, so it keeps running
-- Neovim's code, count handling included.
function M.describe(mode, lhs, desc)
  local keymap = vim.fn.maparg(lhs, mode, false, true)
  if vim.tbl_isempty(keymap) then
    vim.notify(('No %s-mode key %s to describe'):format(mode, lhs), vim.log.levels.WARN)
    return
  end
  keymap.desc = desc
  vim.fn.mapset(keymap)
end

return M
