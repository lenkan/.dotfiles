vim.pack.add {
  -- File tree sidebar
  {
    src = 'https://github.com/nvim-tree/nvim-tree.lua',
    version = vim.version.range '*',
  },
  -- Used by the tree's git keys. Also added in editor.lua and picker.lua; adding again does nothing, so keep the
  -- specs the same.
  { src = 'https://github.com/tpope/vim-fugitive' },
  {
    src = 'https://github.com/nvim-mini/mini.extra',
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

vim.keymap.set('n', '<leader>fe', function()
  api.tree.find_file { open = true, focus = true }
end, { desc = 'Reveal file in tree' })

local function node_path()
  local node = api.tree.get_node_under_cursor()
  if node then
    vim.fn.FugitiveDetect(node.absolute_path)
    return node.absolute_path
  end
end

local function git_on_node(command)
  local path = node_path()
  if path then
    vim.cmd(command .. ' -- ' .. vim.fn.fnameescape(path))
  end
end

local function git_add()
  git_on_node 'Git add'
end

local function git_restore()
  git_on_node 'Git restore --staged'
end

local function git_diff()
  git_on_node 'tab Git diff HEAD'
end

local function git_commit()
  if node_path() then
    vim.cmd 'tab Git commit -v'
  end
end

local function git_log()
  local path = node_path()
  if path then
    require('mini.extra').pickers.git_commits { path = path }
  end
end

local wide = false
local function toggle_wide_mode()
  wide = not wide
  api.tree.resize { absolute = wide and 80 or 40 }
end

vim.api.nvim_create_autocmd('User', {
  desc = 'Refresh the tree after staging, unstaging or committing',
  group = vim.api.nvim_create_augroup('user-tree-git', { clear = true }),
  pattern = 'FugitiveChanged',
  callback = function()
    api.tree.reload()
  end,
})

require('nvim-tree').setup {
  -- Dotfiles are shown and gitignored files hidden by default
  filters = { custom = { '^.git$' } },
  view = { width = 40 },
  on_attach = function(bufnr)
    api.map.on_attach.default(bufnr)

    vim.keymap.set('n', 'w', toggle_wide_mode, { buffer = bufnr, nowait = true, desc = 'nvim-tree: Toggle Wide Mode' })
    vim.keymap.set('n', 'ga', git_add, { buffer = bufnr, desc = 'nvim-tree: Git Stage' })
    vim.keymap.set('n', 'gu', git_restore, { buffer = bufnr, desc = 'nvim-tree: Git Unstage' })
    vim.keymap.set('n', 'gd', git_diff, { buffer = bufnr, desc = 'nvim-tree: Git Diff' })
    vim.keymap.set('n', 'gl', git_log, { buffer = bufnr, desc = 'nvim-tree: Git Log' })
    vim.keymap.set('n', 'gc', git_commit, { buffer = bufnr, nowait = true, desc = 'nvim-tree: Git Commit' })
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
