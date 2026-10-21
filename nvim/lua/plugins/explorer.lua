vim.pack.add {
  'https://github.com/nvim-tree/nvim-tree.lua', -- File tree sidebar
}

-- Per nvim-tree's docs; `nvim .` then opens the tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', '\\', '<Cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file tree (reveal current file)' })
-- Unlike \, never closes the tree when it's already open
vim.keymap.set('n', '<leader>fe', function() require('nvim-tree.api').tree.find_file { open = true, focus = true } end, { desc = 'Reveal file in tree' })

require('nvim-tree').setup {
  -- Dotfiles are shown and gitignored files hidden by default
  filters = { custom = { '^.git$' } },
}

-- nvim-tree doesn't tell language servers about renames, so ts_ls wouldn't update imports
local api = require 'nvim-tree.api'
api.events.subscribe(api.events.Event.WillRenameNode, function(data)
  local params = { files = { { oldUri = vim.uri_from_fname(data.old_name), newUri = vim.uri_from_fname(data.new_name) } } }
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client:supports_method 'workspace/willRenameFiles' then
      local response = client:request_sync('workspace/willRenameFiles', params, 2000)
      if response and response.result then vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding) end
    end
  end
end)
