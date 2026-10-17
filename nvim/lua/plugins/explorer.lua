vim.pack.add {
  'https://github.com/nvim-tree/nvim-tree.lua', -- File tree sidebar, like VS Code's Explorer
}

-- nvim-tree's docs advise turning off netrw; `nvim .` opens the tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', '\\', '<Cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file tree (reveal current file)' })

-- Inside the tree: a add (end with / for a folder), d delete, r rename, C-] make folder the root,
-- - go up a folder, g? all keys
require('nvim-tree').setup {
  -- Like VS Code: show dotfiles, hide .git; gitignored files stay hidden
  filters = { custom = { '^.git$' } },
}

-- Renaming or moving a file in the tree asks the language servers (ts_ls) to update imports first
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
