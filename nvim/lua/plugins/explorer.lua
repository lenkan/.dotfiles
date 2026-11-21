vim.pack.add {
  -- File tree
  {
    src = 'https://github.com/nvim-tree/nvim-tree.lua',
    version = vim.version.range '*',
  },
}

-- Per nvim-tree's docs; `nvim .` then opens the tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local api = require 'nvim-tree.api'

local function reveal_in_tree()
  api.tree.find_file { open = true, focus = true }
end

vim.keymap.set('n', '\\', '<Cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file tree (reveal current file)' })
vim.keymap.set('n', '<leader>fe', reveal_in_tree, { desc = 'Reveal file in tree' })

local function git_on_node(args)
  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end
  local path = node.absolute_path
  -- A directory runs git in itself: its parent may be outside the repo
  local cwd = node.type == 'directory' and path or vim.fs.dirname(path)
  local cmd = vim.list_extend(vim.list_extend({ 'git' }, args), { '--', path })
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    return vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
  end
  -- nvim-tree's own refresh after a git change misses a tree rooted below the repo's top folder
  api.tree.reload()
end

local function git_add()
  git_on_node { 'add' }
end

local function git_restore()
  git_on_node { 'restore', '--staged' }
end

local function centered_float()
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.8)
  return {
    relative = 'editor',
    border = 'rounded',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  }
end

require('nvim-tree').setup {
  -- Dotfiles are shown and gitignored files hidden by default
  filters = { custom = { '^.git$' } },
  -- A popup instead of a sidebar split, so it stays out of the way of tmux panes. It closes when it loses focus.
  view = { float = { enable = true, open_win_config = centered_float } },
  actions = { open_file = { quit_on_open = true } },
  on_attach = function(bufnr)
    api.map.on_attach.default(bufnr)

    vim.keymap.set('n', 'ga', git_add, { buffer = bufnr, desc = 'nvim-tree: Git Stage' })
    vim.keymap.set('n', 'gu', git_restore, { buffer = bufnr, desc = 'nvim-tree: Git Unstage' })
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
