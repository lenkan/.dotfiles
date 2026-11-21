require('config.pack').setup()

vim.pack.add {
  { src = 'https://github.com/Mofiqul/vscode.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/NMAC427/guess-indent.nvim' },
  {
    src = 'https://github.com/lewis6991/gitsigns.nvim',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/nvim-mini/mini.statusline',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/folke/which-key.nvim',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  {
    src = 'https://github.com/nvim-tree/nvim-tree.lua',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/mason-org/mason.nvim',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/mason-org/mason-lspconfig.nvim',
    version = vim.version.range '*',
  },
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range '1.*',
  },
  {
    src = 'https://github.com/stevearc/conform.nvim',
    version = vim.version.range '*',
  },
  -- No current release tags, so these follow the default branch
  { src = 'https://github.com/tpope/vim-dadbod' },
  { src = 'https://github.com/kristijanhusak/vim-dadbod-ui' },
  { src = 'https://github.com/kristijanhusak/vim-dadbod-completion' },
}
