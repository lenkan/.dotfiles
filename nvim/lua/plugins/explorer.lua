vim.pack.add {
  -- File tree sidebar
  {
    src = 'https://github.com/nvim-tree/nvim-tree.lua',
    version = vim.version.range '*',
  },
}

-- Per nvim-tree's docs; `nvim .` then opens the tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', '\\', '<Cmd>NvimTreeFindFileToggle<CR>', {
  desc = 'Toggle file tree (reveal current file)',
})

local api = require 'nvim-tree.api'

vim.keymap.set(
  'n',
  '<leader>fe',
  function() api.tree.find_file { open = true, focus = true } end,
  { desc = 'Reveal file in tree' }
)

-- Outside on_attach, which reruns when the tree gets a new buffer but the width persists
local wide = false

require('nvim-tree').setup {
  -- Dotfiles are shown and gitignored files hidden by default
  filters = { custom = { '^.git$' } },
  view = { width = 40 },
  on_attach = function(bufnr)
    api.map.on_attach.default(bufnr)

    vim.keymap.set('n', 'w', function()
      wide = not wide
      api.tree.resize { absolute = wide and 80 or 40 }
    end, { buffer = bufnr, nowait = true, desc = 'nvim-tree: Toggle Wide Mode' })

    vim.keymap.set('n', 'hs', function()
      local node = api.tree.get_node_under_cursor()
      local result = vim.system({ 'git', 'add', '--', node.absolute_path }):wait()
      if result.code ~= 0 then
        return vim.notify(result.stderr, vim.log.levels.ERROR)
      end
      api.tree.reload()
    end, { buffer = bufnr, desc = 'nvim-tree: Git Stage' })

    vim.keymap.set('n', 'hu', function()
      local node = api.tree.get_node_under_cursor()
      local result = vim.system({ 'git', 'restore', '--staged', '--', node.absolute_path }):wait()
      if result.code ~= 0 then
        return vim.notify(result.stderr, vim.log.levels.ERROR)
      end
      api.tree.reload()
    end, { buffer = bufnr, desc = 'nvim-tree: Git Unstage' })
  end,
}

-- nvim-tree doesn't tell language servers about renames, so ts_ls wouldn't update imports
api.events.subscribe(api.events.Event.WillRenameNode, function(data)
  local params = {
    files = { { oldUri = vim.uri_from_fname(data.old_name), newUri = vim.uri_from_fname(data.new_name) } },
  }
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client:supports_method 'workspace/willRenameFiles' then
      local response = client:request_sync('workspace/willRenameFiles', params, 2000)
      if response and response.result then
        vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
      end
    end
  end
end)
