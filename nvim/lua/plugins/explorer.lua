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
