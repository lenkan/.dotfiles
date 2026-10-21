vim.pack.add {
  'https://github.com/tpope/vim-dadbod', -- Runs queries through psql and friends
  'https://github.com/kristijanhusak/vim-dadbod-ui', -- Connection sidebar, saved queries and scratch buffers
  'https://github.com/kristijanhusak/vim-dadbod-completion', -- Table and column names in blink.cmp
}

-- Connections added with `A` in the sidebar go to ~/.local/share/db_ui/connections.json, outside the repo
vim.g.db_ui_use_nerd_fonts = 1
-- Saving a scratch buffer would otherwise run every query in it
vim.g.db_ui_execute_on_save = 0
-- The built-in sql ftplugin maps <C-c> + key in insert mode, which makes <C-c> lag
vim.g.omni_sql_no_default_maps = 1

vim.keymap.set('n', '<leader>db', '<Cmd>DBUIToggle<CR>', { desc = 'Toggle database sidebar' })
vim.keymap.set('n', '<leader>df', '<Cmd>DBUIFindBuffer<CR>', { desc = 'Attach buffer to a connection' })

-- Not an LSP server, so mason-lspconfig doesn't install it. is_installed is a disk check; refresh hits the network.
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
    map('n', '<leader>dr', 'vip<Plug>(DBUI_ExecuteQuery)', 'Run query under cursor')
    map('x', '<leader>dr', '<Plug>(DBUI_ExecuteQuery)', 'Run selection')
    map('n', '<leader>dR', '<Plug>(DBUI_ExecuteQuery)', 'Run whole buffer')
  end,
})
