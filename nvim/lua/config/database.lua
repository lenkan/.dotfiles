local blink = require 'blink.cmp'

local M = {}

local function set_query_keymaps(ev)
  vim.keymap.set('n', '<leader>r', 'vip<Plug>(DBUI_ExecuteQuery)', {
    buffer = ev.buf,
    remap = true,
    desc = 'Run query under cursor',
  })

  vim.keymap.set('n', '<leader>R', '<Plug>(DBUI_ExecuteQuery)', {
    buffer = ev.buf,
    remap = true,
    desc = 'Run whole buffer',
  })

  vim.keymap.set('x', '<leader>r', '<Plug>(DBUI_ExecuteQuery)', {
    buffer = ev.buf,
    remap = true,
    desc = 'Run selection',
  })
end

function M.setup()
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_execute_on_save = 0
  vim.g.omni_sql_no_default_maps = 1
  vim.g.db_ui_disable_mappings_sql = 1

  -- Table and column names, in buffers attached to a database connection
  blink.add_source_provider('dadbod', { name = 'Dadbod', module = 'vim_dadbod_completion.blink' })
  blink.add_filetype_source('sql', 'dadbod')

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'SQL query keymaps',
    group = vim.api.nvim_create_augroup('user-dadbod', { clear = true }),
    pattern = 'sql',
    callback = set_query_keymaps,
  })
end

return M
