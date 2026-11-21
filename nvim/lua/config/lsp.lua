local mason_lspconfig = require 'mason-lspconfig'

local M = {}

function M.accept_inline_completion()
  if not vim.lsp.inline_completion.get() then
    return '<Tab>'
  end
end

function M.setup()
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

  mason_lspconfig.setup {
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
      'gopls',
      'stylua',
      'lua_ls',
      'copilot',
    },
  }

  vim.lsp.inline_completion.enable()
end

return M
