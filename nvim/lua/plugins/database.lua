vim.pack.add {
  'https://github.com/tpope/vim-dadbod', -- Runs queries through psql and friends
  'https://github.com/kristijanhusak/vim-dadbod-ui', -- Connection sidebar, saved queries and scratch buffers
  'https://github.com/kristijanhusak/vim-dadbod-completion', -- Table and column names in blink.cmp
}

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_execute_on_save = 0
vim.g.omni_sql_no_default_maps = 1
vim.g.db_ui_disable_mappings_sql = 1

local registry = require 'mason-registry'
if not registry.is_installed 'sql-formatter' then registry.refresh(function() registry.get_package('sql-formatter'):install() end) end

vim.api.nvim_create_autocmd('FileType', {
  desc = 'SQL formatting and query keymaps',
  group = vim.api.nvim_create_augroup('user-dadbod', { clear = true }),
  pattern = 'sql',
  callback = function(ev)
    -- Run on save by the format fallback in autocmds.lua
    vim.b[ev.buf].format_cmd = { 'sql-formatter', '--language', 'postgresql' }

    -- The query keymaps only work in buffers attached to a connection
    local map = function(mode, keys, rhs, desc) vim.keymap.set(mode, keys, rhs, { buffer = ev.buf, remap = true, desc = desc }) end
    -- A blank line separates statements, so the paragraph is the statement under the cursor
    map('n', '<leader>r', 'vip<Plug>(DBUI_ExecuteQuery)', 'Run query under cursor')
    map('x', '<leader>r', '<Plug>(DBUI_ExecuteQuery)', 'Run selection')
    map('n', '<leader>R', '<Plug>(DBUI_ExecuteQuery)', 'Run whole buffer')
  end,
})
