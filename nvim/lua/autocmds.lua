-- See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Pick up edits made outside nvim. 'autoread' (on by default) only reloads when nvim
-- checks the file, so check on these events. FocusGained needs `focus-events on` in tmux.
local reload = vim.api.nvim_create_augroup('user-reload', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  desc = 'Reload files changed on disk',
  group = reload,
  callback = function()
    -- :checktime errors in the command-line window
    if vim.fn.getcmdwintype() == '' then vim.cmd 'checktime' end
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  desc = 'Say when a file was reloaded',
  group = reload,
  callback = function(ev) vim.notify('Reloaded ' .. vim.fn.fnamemodify(ev.file, ':~:.'), vim.log.levels.INFO) end,
})

-- Format with the LSP on save. Where Biome is attached it is the only formatter and fixer,
-- so ts_ls/jsonls/cssls/html don't also act on the same file.
local function biome(bufnr) return vim.lsp.get_clients({ bufnr = bufnr, name = 'biome' })[1] end

local function format(bufnr)
  local name = biome(bufnr) and 'biome'
  -- Without a formatter, vim.lsp.buf.format warns on every save
  if #vim.lsp.get_clients { bufnr = bufnr, name = name, method = 'textDocument/formatting' } == 0 then return end
  vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 2000, name = name }
end

-- Like VS Code's source.organizeImports.biome on save. vim.lsp.buf.code_action is async,
-- so request the action synchronously to apply it before the file is written.
local function organize_imports(bufnr)
  local client = biome(bufnr)
  if not client then return end
  -- The whole file as range: some Biome versions only offer the action if the range covers the imports
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = { start = { line = 0, character = 0 }, ['end'] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 } },
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
  }
  local response = client:request_sync('textDocument/codeAction', params, 2000, bufnr)
  for _, action in ipairs(response and response.result or {}) do
    -- Biome only fills in the edit on codeAction/resolve
    if not action.edit then
      local resolved = client:request_sync('codeAction/resolve', action, 2000, bufnr)
      action = resolved and resolved.result or action
    end
    if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding) end
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Organize imports and format with LSP',
  group = vim.api.nvim_create_augroup('user-format-on-save', { clear = true }),
  callback = function(ev)
    organize_imports(ev.buf)
    format(ev.buf)
  end,
})

-- Commands show up in the `Space fc` palette; map a key to one with <Cmd>Name<CR>
vim.api.nvim_create_user_command('Format', function() format(0) end, { desc = 'Format buffer' })
vim.keymap.set('n', '<leader>cf', '<Cmd>Format<CR>', { desc = 'Format buffer' })
vim.api.nvim_create_user_command('OrganizeImports', function() organize_imports(0) end, { desc = 'Organize imports (Biome)' })
vim.api.nvim_create_user_command('FixAll', function()
  local name = biome(0) and 'biome'
  vim.lsp.buf.code_action {
    context = { only = { 'source.fixAll' } },
    filter = function(_, client_id) return not name or vim.lsp.get_client_by_id(client_id).name == name end,
    apply = true,
  }
end, { desc = 'Apply all auto-fixes (Biome, ruff, ...)' })
