-- No current release tags, so these follow the default branch
vim.pack.add {
  { src = 'https://github.com/tpope/vim-dadbod' },
  { src = 'https://github.com/kristijanhusak/vim-dadbod-ui' },
  { src = 'https://github.com/kristijanhusak/vim-dadbod-completion' },
}

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_execute_on_save = 0
vim.g.omni_sql_no_default_maps = 1
vim.g.db_ui_disable_mappings_sql = 1

vim.api.nvim_create_autocmd('FileType', {
  desc = 'SQL query keymaps',
  group = vim.api.nvim_create_augroup('user-dadbod', { clear = true }),
  pattern = 'sql',
  callback = function(ev)
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
  end,
})
