local nvim_tree = require 'nvim-tree'
local api = require 'nvim-tree.api'
local git = require 'lib.git'

local M = {}

local function toggle_stage_node()
  local node = api.tree.get_node_under_cursor()
  if node and git.toggle_stage_path(node.absolute_path) then
    -- nvim-tree's own refresh after a git change misses a tree rooted below the repo's top folder
    api.tree.reload()
  end
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

local function on_will_rename(data)
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
end

local function on_attach(bufnr)
  api.map.on_attach.default(bufnr)

  vim.keymap.set('n', '<Esc>', api.tree.close, { buffer = bufnr, desc = 'nvim-tree: Close' })
  vim.keymap.set('n', '<C-s>', toggle_stage_node, { buffer = bufnr, desc = 'nvim-tree: Stage / unstage' })
  vim.keymap.set('n', 'ga', toggle_stage_node, { buffer = bufnr, desc = 'nvim-tree: Stage / unstage' })
end

function M.setup()
  nvim_tree.setup {
    filters = { custom = { '^.git$' } },

    view = {
      float = {
        enable = true,
        open_win_config = centered_float,
      },
    },

    actions = {
      open_file = {
        quit_on_open = true,
      },
    },

    on_attach = on_attach,
  }

  local tree_events = api.events
  tree_events.subscribe(tree_events.Event.WillRenameNode, on_will_rename)
end

return M
