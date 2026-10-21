vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- 'autoread' only reloads a file when nvim checks it. FocusGained needs `focus-events on` in tmux.
local reload = vim.api.nvim_create_augroup('user-reload', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  desc = 'Reload files changed on disk',
  group = reload,
  callback = function(ev)
    -- :checktime errors in the command-line window
    if vim.fn.getcmdwintype() ~= '' then return end
    vim.cmd(ev.event == 'FocusGained' and 'checktime' or 'checktime ' .. ev.buf)
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  desc = 'Say when a file was reloaded',
  group = reload,
  callback = function(ev) vim.notify('Reloaded ' .. vim.fn.fnamemodify(ev.file, ':~:.'), vim.log.levels.INFO) end,
})

-- Where Biome is attached it is the only formatter and fixer, so ts_ls/jsonls/cssls/html stay out
local function clients(bufnr, method)
  local name = vim.lsp.get_clients({ bufnr = bufnr, name = 'biome' })[1] and 'biome' or nil
  return vim.lsp.get_clients { bufnr = bufnr, name = name, method = method }, name
end

-- For file types without an LSP formatter: vim.b.format_cmd is a stdin-to-stdout command (argv list).
-- Not 'formatprg' + `gggqG`: on an error that replaces the buffer with the error message.
local function format_with_cmd(bufnr)
  local cmd = vim.b[bufnr].format_cmd
  if not cmd or vim.fn.executable(cmd[1]) == 0 then return end
  local before = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = vim.system(cmd, { stdin = table.concat(before, '\n') .. '\n' }):wait(2000)
  if result.code ~= 0 then return vim.notify(cmd[1] .. ': ' .. (result.stderr or ''), vim.log.levels.WARN) end
  local lines = vim.split(result.stdout:gsub('\n$', ''), '\n')
  if vim.deep_equal(lines, before) then return end
  local view = vim.fn.winsaveview()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.fn.winrestview(view)
end

local function format(bufnr)
  local formatters, name = clients(bufnr, 'textDocument/formatting')
  -- Without a formatter, vim.lsp.buf.format warns on every save
  if #formatters == 0 then return format_with_cmd(bufnr) end
  vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 2000, name = name }
end

-- Applies source.organizeImports, source.fixAll, ... Not vim.lsp.buf.code_action: it is async,
-- so on save the edit would land after the write.
local function source_action(bufnr, kind)
  for _, client in ipairs((clients(bufnr, 'textDocument/codeAction'))) do
    -- The whole file as range: some Biome versions only offer the action if the range covers the imports
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
      range = { start = { line = 0, character = 0 }, ['end'] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 } },
      context = { only = { kind }, diagnostics = {} },
    }
    local response = client:request_sync('textDocument/codeAction', params, 2000, bufnr)
    for _, action in ipairs(response and response.result or {}) do
      -- Biome only fills in the edit on codeAction/resolve
      if not action.edit and client:supports_method 'codeAction/resolve' then
        local resolved = client:request_sync('codeAction/resolve', action, 2000, bufnr)
        action = resolved and resolved.result or action
      end
      if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding) end
    end
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Organize imports and format with LSP',
  group = vim.api.nvim_create_augroup('user-format-on-save', { clear = true }),
  callback = function(ev)
    source_action(ev.buf, 'source.organizeImports')
    format(ev.buf)
  end,
})

vim.api.nvim_create_user_command('Format', function() format(0) end, { desc = 'Format buffer' })
vim.keymap.set('n', '<leader>cf', '<Cmd>Format<CR>', { desc = 'Format buffer' })
vim.api.nvim_create_user_command('OrganizeImports', function() source_action(0, 'source.organizeImports') end, { desc = 'Organize imports' })
vim.api.nvim_create_user_command('FixAll', function() source_action(0, 'source.fixAll') end, { desc = 'Apply all auto-fixes' })
