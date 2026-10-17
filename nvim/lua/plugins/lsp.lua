vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig', -- Default configs (cmd, filetypes, root markers) for each server
  'https://github.com/mason-org/mason.nvim', -- Installs language servers into nvim's data dir, no sudo
  'https://github.com/mason-org/mason-lspconfig.nvim', -- Installs and enables the servers listed below
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' }, -- Completion menu
}

local highlight_group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end
    local builtin = require 'telescope.builtin'

    -- Neovim's defaults (`:help lsp-defaults`): K hover, grn rename, gra code action,
    -- grr references, gri implementation, grt type definition, gO document symbols.
    -- The list-style ones are rebound to Telescope pickers on the same keys.
    map('gd', builtin.lsp_definitions, 'Go to definition')
    map('grr', builtin.lsp_references, 'References')
    map('gri', builtin.lsp_implementations, 'Go to implementation')
    map('grt', builtin.lsp_type_definitions, 'Go to type definition')
    map('gO', builtin.lsp_document_symbols, 'Document symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
    -- Like gra, but only fixes for the problem under the cursor (no ts_ls refactors)
    map('grq', function() vim.lsp.buf.code_action { context = { only = { 'quickfix' } } } end, 'Quick fix')

    -- Highlight other uses of the symbol under the cursor
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

-- Servers to install and enable. Settings here are merged over nvim-lspconfig's defaults.
-- See `:help lsp-config`.
---@type table<string, vim.lsp.Config>
local servers = {
  bashls = {}, -- Uses shellcheck and shfmt from PATH
  ts_ls = {
    -- Biome formats JS/TS, as in VS Code
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false -- used by gq
    end,
  },
  biome = {}, -- Only attaches in projects with biome.json(c)
  jsonls = {},
  cssls = {},
  html = {},
  basedpyright = {},
  ruff = {}, -- Python lint and format
  rust_analyzer = {},
  stylua = {}, -- Formats Lua (this config) via `stylua --lsp`, using .stylua.toml

  lua_ls = {
    -- Teach lua_ls about the Neovim runtime when editing this config
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
        workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
      })
    end,
    settings = {
      Lua = { format = { enable = false } }, -- stylua formats instead
    },
  },
}

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
end

require('mason').setup {}
-- Installs any missing server, then enables every Mason-installed server (`:help vim.lsp.enable()`)
require('mason-lspconfig').setup { ensure_installed = vim.tbl_keys(servers) }

-- Default keys: <C-n>/<C-p> select, <C-y> accept, <C-e> close, <C-k> signature help.
-- <C-space> (open the menu by hand) never arrives inside tmux, since it is the tmux prefix.
require('blink.cmp').setup {
  -- The Lua matcher avoids downloading a prebuilt Rust binary
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
