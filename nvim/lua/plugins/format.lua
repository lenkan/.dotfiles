vim.pack.add {
  {
    src = 'https://github.com/stevearc/conform.nvim',
    version = vim.version.range '*',
  },
}

-- mason-lspconfig only installs language servers, so it covers biome (lsp.lua) but not sql-formatter
local registry = require 'mason-registry'
if not registry.is_installed 'sql-formatter' then
  registry.refresh(function()
    registry.get_package('sql-formatter'):install()
  end)
end

local biome = { 'biome-organize-imports', 'biome' }

require('conform').setup {
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

vim.api.nvim_create_user_command('Format', function()
  require('conform').format()
end, {
  desc = 'Format buffer',
})
