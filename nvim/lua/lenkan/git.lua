local M = {}

-- Runs git on a file or directory, from inside its repository.
---@param opts { args: string[], path: string }
---@return string?
function M.run(opts)
  local cmd = vim.list_extend({ 'git' }, opts.args)
  vim.list_extend(cmd, { '--', opts.path })
  local cwd = vim.fn.isdirectory(opts.path) == 1 and opts.path or vim.fs.dirname(opts.path)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end
  return result.stdout
end

---@param path string
---@return boolean
function M.stage(path)
  return M.run { args = { 'add' }, path = path } ~= nil
end

---@param path string
---@return boolean
function M.unstage(path)
  return M.run { args = { 'restore', '--staged' }, path = path } ~= nil
end

-- Shows lines in a read-only buffer in a new tab. q closes it.
---@param opts { lines: string[], filetype?: string }
local function open_scratch(opts)
  vim.cmd.tabnew()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, opts.lines)
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.filetype = opts.filetype or ''
  vim.bo.modifiable = false
  vim.keymap.set('n', 'q', '<Cmd>tabclose<CR>', { buffer = true, desc = 'Close scratch' })
end

-- Shows the changes against HEAD, staged and unstaged, in a new tab
---@param path string
function M.show_diff(path)
  local diff = M.run { args = { 'diff', 'HEAD' }, path = path }
  if not diff then
    return
  end
  if diff == '' then
    return vim.notify 'No changes against HEAD (untracked files show once staged)'
  end
  open_scratch { lines = vim.split(diff, '\n', { trimempty = true }), filetype = 'diff' }
end

return M
