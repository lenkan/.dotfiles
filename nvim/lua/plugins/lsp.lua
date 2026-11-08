vim.pack.add {
  -- Default config (cmd, filetypes, root markers) per server
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    version = vim.version.range '*',
  },
  -- Installs language servers, no sudo
  {
    src = 'https://github.com/mason-org/mason.nvim',
    version = vim.version.range '*',
  },
  -- Installs and enables the servers below
  {
    src = 'https://github.com/mason-org/mason-lspconfig.nvim',
    version = vim.version.range '*',
  },
  -- Completion menu
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range '1.*',
  },
}

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  jump = {
    on_jump = function(_, bufnr)
      if vim.diagnostic.config().virtual_lines then
        return
      end
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

local function next_error()
  vim.diagnostic.jump { count = vim.v.count1, severity = vim.diagnostic.severity.ERROR }
end

local function previous_error()
  vim.diagnostic.jump { count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR }
end

local function copy_problem_message()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  if #diagnostics == 0 then
    return vim.notify 'No problems on this line'
  end
  table.sort(diagnostics, function(a, b)
    return a.severity < b.severity
  end)
  local messages = vim.tbl_map(function(d)
    return d.message
  end, diagnostics)
  vim.fn.setreg(vim.v.register, table.concat(messages, '\n'))
end

local function toggle_virtual_lines()
  local on = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = on and { current_line = true }, virtual_text = not on }
end

local function references()
  vim.cmd 'Pick lsp scope="references"'
end

local function quick_fix()
  vim.lsp.buf.code_action { context = { only = { 'quickfix' } } }
end

vim.keymap.set('n', '<leader>pp', vim.diagnostic.open_float, { desc = 'Show problem' })
vim.keymap.set('n', '<leader>pl', '<Cmd>Pick diagnostic scope="current"<CR>', { desc = 'List problems in file' })
vim.keymap.set('n', '<leader>pL', '<Cmd>Pick diagnostic scope="all"<CR>', { desc = 'List all problems' })
vim.keymap.set('n', '<leader>py', copy_problem_message, { desc = 'Copy problem message' })
vim.keymap.set('n', '<leader>pv', toggle_virtual_lines, { desc = 'Toggle virtual lines' })

local highlight_group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Only for servers that support them: Copilot attaches to every buffer, the file tree too, and would
    -- replace its keys
    if client:supports_method('textDocument/definition', event.buf) then
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'LSP: Go to definition' })
    end

    if client:supports_method('textDocument/references', event.buf) then
      vim.keymap.set('n', 'grr', references, { buffer = event.buf, desc = 'LSP: References' })
    end

    if client:supports_method('textDocument/codeAction', event.buf) then
      vim.keymap.set('n', 'grq', quick_fix, { buffer = event.buf, desc = 'LSP: Quick fix' })
      vim.keymap.set('n', '<leader>pf', quick_fix, { buffer = event.buf, desc = 'LSP: Fix problem' })
    end

    if client:supports_method('textDocument/documentHighlight', event.buf) then
      vim.api.nvim_create_autocmd(
        { 'CursorHold', 'CursorHoldI' },
        { buffer = event.buf, group = highlight_group, callback = vim.lsp.buf.document_highlight }
      )
      vim.api.nvim_create_autocmd(
        { 'CursorMoved', 'CursorMovedI' },
        { buffer = event.buf, group = highlight_group, callback = vim.lsp.buf.clear_references }
      )
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()
    vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
  end,
})

-- Merged over nvim-lspconfig's defaults. The other servers use those as they are.
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      -- Know Neovim's Lua API (`vim.*`)
      runtime = { version = 'LuaJIT' },
      workspace = { library = { vim.env.VIMRUNTIME } },
      format = { enable = false }, -- stylua formats instead
    },
  },
})

require('mason').setup {}
-- Also enables every server installed in Mason, listed here or not
require('mason-lspconfig').setup {
  ensure_installed = {
    'bashls',
    'ts_ls',
    'biome',
    'jsonls',
    'cssls',
    'html',
    'basedpyright',
    'ruff',
    'rust_analyzer',
    'stylua',
    'lua_ls',
  },
}
require('blink.cmp').setup {
  -- <CR> accepts the menu item; <Tab> only jumps in snippets, otherwise falls through to copilot.vim
  keymap = {
    preset = 'enter',
    -- Stands in for <C-space>, which never arrives inside tmux since it is the tmux prefix
    ['<C-j>'] = { 'show', 'show_documentation', 'hide_documentation' },
  },
  -- The Lua matcher avoids downloading a prebuilt Rust binary
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
  sources = {
    -- Only fills in buffers attached to a connection (database.lua)
    per_filetype = { sql = { 'snippets', 'dadbod', 'buffer' } },
    providers = { dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' } },
  },
}
