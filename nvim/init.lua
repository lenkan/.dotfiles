-- Trimmed-down kickstart.nvim. Plugins come from the built-in vim.pack, pinned in
-- nvim-pack-lock.json. Update them with :lua vim.pack.update()

vim.loader.enable()

-- Must be set before any plugin creates mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'options'
require 'keymaps'
require 'autocmds'

-- Must be registered before the vim.pack.add calls below, which trigger the install
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
require 'plugins.claude'
