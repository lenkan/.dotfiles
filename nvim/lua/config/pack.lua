local M = {}

local function on_pack_changed(ev)
  if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind ~= 'delete' then
    if not ev.data.active then
      vim.cmd.packadd 'nvim-treesitter'
    end
    vim.cmd 'TSUpdate'
  end
end

local function plugin_name(plugin)
  return plugin.spec.name
end

local function is_unused(plugin)
  return not plugin.active
end

local function sync_plugins()
  local unused = vim.iter(vim.pack.get()):filter(is_unused):map(plugin_name):totable()
  if #unused > 0 then
    vim.pack.del(unused)
  end
  vim.pack.update(nil, { target = 'lockfile' })
end

-- Before vim.pack.add, so the hook also sees the first install
function M.setup()
  vim.api.nvim_create_autocmd('PackChanged', { callback = on_pack_changed })

  vim.api.nvim_create_user_command('SyncPlugins', sync_plugins, {
    desc = 'Match plugins to the lockfile: delete removed ones, move the rest to the locked version',
  })
end

return M
