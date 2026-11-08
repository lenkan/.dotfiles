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

local builtin = require 'telescope.builtin'

local function jump_to_error(count) vim.diagnostic.jump { count = count, severity = vim.diagnostic.severity.ERROR } end
vim.keymap.set('n', ']e', function() jump_to_error(vim.v.count1) end, { desc = 'Next error' })
vim.keymap.set('n', '[e', function() jump_to_error(-vim.v.count1) end, { desc = 'Previous error' })

vim.keymap.set('n', '<leader>pp', vim.diagnostic.open_float, { desc = 'Show problem' })
vim.keymap.set('n', '<leader>pl', function() builtin.diagnostics { bufnr = 0 } end, { desc = 'List problems in file' })
vim.keymap.set('n', '<leader>pL', builtin.diagnostics, { desc = 'List all problems' })
vim.keymap.set('n', '<leader>py', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  if #diagnostics == 0 then
    return vim.notify 'No problems on this line'
  end
  table.sort(diagnostics, function(a, b) return a.severity < b.severity end)
  vim.fn.setreg(vim.v.register, table.concat(vim.tbl_map(function(d) return d.message end, diagnostics), '\n'))
end, { desc = 'Copy problem message' })
vim.keymap.set('n', '<leader>pv', function()
  local on = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = on and { current_line = true }, virtual_text = not on }
end, { desc = 'Toggle virtual lines' })

local highlight_group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    -- The list-style `:help lsp-defaults` keys, rebound to Telescope pickers
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = event.buf, desc = 'LSP: Go to definition' })
    vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = event.buf, desc = 'LSP: References' })
    vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = event.buf, desc = 'LSP: Go to implementation' })
    vim.keymap.set(
      'n',
      'grt',
      builtin.lsp_type_definitions,
      { buffer = event.buf, desc = 'LSP: Go to type definition' }
    )
    vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = event.buf, desc = 'LSP: Document symbols' })
    vim.keymap.set(
      'n',
      'gW',
      builtin.lsp_dynamic_workspace_symbols,
      { buffer = event.buf, desc = 'LSP: Workspace symbols' }
    )
    -- Like gra without ts_ls's refactors
    local quick_fix = function() vim.lsp.buf.code_action { context = { only = { 'quickfix' } } } end
    vim.keymap.set('n', 'grq', quick_fix, { buffer = event.buf, desc = 'LSP: Quick fix' })
    vim.keymap.set('n', '<leader>pf', quick_fix, { buffer = event.buf, desc = 'LSP: Fix problem' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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

-- Merged over nvim-lspconfig's defaults
---@type table<string, vim.lsp.Config>
local servers = {
  bashls = {}, -- Uses shellcheck and shfmt from PATH
  ts_ls = {},
  biome = {}, -- Only attaches in projects with biome.json(c)
  jsonls = {},
  cssls = {},
  html = {},
  basedpyright = {},
  ruff = {},
  rust_analyzer = {},
  stylua = {}, -- Runs `stylua --lsp`, using .stylua.toml

  lua_ls = {
    settings = {
      Lua = {
        -- Know Neovim's Lua API (`vim.*`)
        runtime = { version = 'LuaJIT' },
        workspace = { library = { vim.env.VIMRUNTIME } },
        format = { enable = false }, -- stylua formats instead
      },
    },
  },
}

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
end

require('mason').setup {}
-- Also enables every server installed in Mason, listed here or not
require('mason-lspconfig').setup { ensure_installed = vim.tbl_keys(servers) }
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
