vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig', -- Default config (cmd, filetypes, root markers) per server
  'https://github.com/mason-org/mason.nvim', -- Installs language servers, no sudo
  'https://github.com/mason-org/mason-lspconfig.nvim', -- Installs and enables the servers below
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' }, -- Completion menu
}

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  jump = {
    on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false } end,
  },
}

local highlight_group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end
    local builtin = require 'telescope.builtin'

    -- The list-style `:help lsp-defaults` keys, rebound to Telescope pickers
    map('gd', builtin.lsp_definitions, 'Go to definition')
    map('grr', builtin.lsp_references, 'References')
    map('gri', builtin.lsp_implementations, 'Go to implementation')
    map('grt', builtin.lsp_type_definitions, 'Go to type definition')
    map('gO', builtin.lsp_document_symbols, 'Document symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
    -- Like gra without ts_ls's refactors
    map('grq', function() vim.lsp.buf.code_action { context = { only = { 'quickfix' } } } end, 'Quick fix')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = highlight_group, callback = vim.lsp.buf.document_highlight })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = highlight_group, callback = vim.lsp.buf.clear_references })
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
