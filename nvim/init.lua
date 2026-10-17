-- Based on kickstart.nvim (https://github.com/nvim-lua/kickstart.nvim), trimmed down
-- and split into a few files. Plugins are managed by Neovim's built-in `vim.pack`
-- (see `:help vim.pack`). Versions are pinned in nvim-pack-lock.json.
--
--   Update plugins:   :lua vim.pack.update()
--   Check health:     :checkhealth

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Must be set before any plugin creates mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'options'
require 'keymaps'
require 'autocmds'

-- Run build steps after a plugin is installed or updated. Must be registered
-- before the `vim.pack.add` calls below, which trigger the install.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind ~= 'delete' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

require 'plugins.editor'
require 'plugins.telescope'
require 'plugins.explorer'
require 'plugins.lsp'
