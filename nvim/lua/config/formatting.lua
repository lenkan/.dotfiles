local conform = require 'conform'
local registry = require 'mason-registry'

local M = {}

-- mason-lspconfig only installs language servers, so it covers biome but not sql-formatter
local function install_sql_formatter()
  if not registry.is_installed 'sql-formatter' then
    registry.refresh(function()
      registry.get_package('sql-formatter'):install()
    end)
  end
end

local function format_buffer()
  conform.format()
end

function M.setup()
  install_sql_formatter()

  local biome = { 'biome-organize-imports', 'biome' }

  conform.setup {
    formatters_by_ft = {
      javascript = biome,
      javascriptreact = biome,
      typescript = biome,
      typescriptreact = biome,
      json = biome,
      jsonc = biome,
      css = biome,
      sql = { 'sql_formatter' },
    },
    formatters = {
      biome = { require_cwd = true },
      ['biome-organize-imports'] = { require_cwd = true },
      sql_formatter = { prepend_args = { '--language', 'postgresql' } },
    },
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = { timeout_ms = 2000 },
  }

  vim.api.nvim_create_user_command('Format', format_buffer, { desc = 'Format buffer' })
end

return M
