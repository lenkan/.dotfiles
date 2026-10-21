vim.pack.add {
  'https://github.com/Mofiqul/vscode.nvim', -- VS Code's Dark+ colors
  'https://github.com/nvim-mini/mini.icons', -- File type icons
  'https://github.com/NMAC427/guess-indent.nvim', -- Detects tabs vs spaces per file
  'https://github.com/lewis6991/gitsigns.nvim', -- Git change markers in the gutter, plus hunk actions
  { src = 'https://github.com/akinsho/git-conflict.nvim', version = vim.version.range '*' }, -- Inline merge conflicts: co/ct/cb/c0 to resolve, ]x/[x to jump
  'https://github.com/nvim-mini/mini.statusline', -- Statusline
  'https://github.com/christoomey/vim-tmux-navigator', -- Ctrl-h/j/k/l across nvim splits
  'https://github.com/github/copilot.vim', -- Copilot inline suggestions
  { src = 'https://github.com/folke/which-key.nvim', version = vim.version.range '*' }, -- Shows the keys that can follow a prefix
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' }, -- Parsers for syntax highlighting and indentation
}

vim.cmd.colorscheme 'vscode'

-- copilot.vim is off in commit messages by default
vim.g.copilot_filetypes = { gitcommit = true }

require('mini.icons').setup()
-- Telescope and nvim-tree look for nvim-web-devicons; this serves them mini.icons instead
MiniIcons.mock_nvim_web_devicons()

require('guess-indent').setup {}

require('which-key').setup {
  -- which-key never auto-pops on single letters besides g/z; c lists git-conflict's keys,
  -- and only triggers in buffers that have c... mappings
  triggers = {
    { '<auto>', mode = 'nxso' },
    { 'c', mode = 'n' },
  },
  spec = {
    { '<leader>a', group = 'Claude' },
    { '<leader>c', group = 'Code' },
    { '<leader>f', group = 'Find' },
    { '<leader>h', group = 'Git hunk' },
    { 'c', group = 'Git conflict' },
  },
}

local gitsigns = require 'gitsigns'
gitsigns.setup {
  on_attach = function(bufnr)
    local map = function(mode, keys, func, desc) vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc }) end

    map('n', ']h', function() gitsigns.nav_hunk 'next' end, 'Next git hunk')
    map('n', '[h', function() gitsigns.nav_hunk 'prev' end, 'Previous git hunk')

    map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset selected lines')
    map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
    map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, 'Blame line')
    map('n', '<leader>hd', gitsigns.diffthis, 'Diff against index')
  end,
}

require('git-conflict').setup()

-- git-conflict adds its buffer keymaps asynchronously, after which-key has already scanned the buffer
vim.api.nvim_create_autocmd('User', {
  desc = 'Rescan git-conflict keymaps for which-key',
  group = vim.api.nvim_create_augroup('user-git-conflict', { clear = true }),
  pattern = { 'GitConflictDetected', 'GitConflictResolved' },
  callback = function(args) require('which-key.buf').clear { buf = args.buf } end,
})

require('mini.statusline').setup {}

local function treesitter_start(buf, language)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(language) then return end
  vim.treesitter.start(buf, language)
  if vim.treesitter.query.get(language, 'indents') ~= nil then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

-- Parsers install the first time you open a file type (Neovim bundles lua, markdown, vim, vimdoc)
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start treesitter, installing the parser if needed',
  group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
  callback = function(args)
    local language = vim.treesitter.language.get_lang(args.match)
    if not language then return end
    if vim.treesitter.language.add(language) then return treesitter_start(args.buf, language) end
    if vim.tbl_contains(require('nvim-treesitter').get_available(), language) then
      require('nvim-treesitter').install(language):await(function() treesitter_start(args.buf, language) end)
    end
  end,
})
