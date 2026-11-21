local M = {}

local function open_float_on_jump(_, bufnr)
  vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
end

local function most_severe_first(a, b)
  return a.severity < b.severity
end

local function message(diagnostic)
  return diagnostic.message
end

function M.copy_problem_message()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  if #diagnostics == 0 then
    return vim.notify 'No problems on this line'
  end

  table.sort(diagnostics, most_severe_first)
  local messages = vim.tbl_map(message, diagnostics)

  vim.fn.setreg(vim.v.register, table.concat(messages, '\n'))
end

function M.toggle_virtual_text()
  vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end

function M.setup()
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    jump = { on_jump = open_float_on_jump },
  }
end

return M
