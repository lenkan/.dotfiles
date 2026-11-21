local M = {}

local function run_on_path(args, path)
  local stat = vim.uv.fs_lstat(path)
  local cwd = stat and stat.type == 'directory' and path or vim.fs.dirname(path)
  local cmd = vim.list_extend(vim.list_extend({ 'git' }, args), { '--', path })
  return vim.system(cmd, { cwd = cwd, text = true }):wait()
end

-- Unstages the path if any of it is staged, otherwise stages it: the same rule as fzf-lua's ctrl-s
function M.toggle_stage_path(path)
  -- Exits 1 when something is staged
  local staged = run_on_path({ 'diff', '--cached', '--quiet' }, path).code == 1
  local result = run_on_path(staged and { 'restore', '--staged' } or { 'add' }, path)

  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
  end

  return result.code == 0
end

return M
