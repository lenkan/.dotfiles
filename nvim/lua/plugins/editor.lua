vim.pack.add {
  'https://github.com/Mofiqul/vscode.nvim', -- VS Code's Dark+ colors (the syntax colors Dark Modern uses)
  'https://github.com/nvim-mini/mini.icons', -- File type icons for Telescope, nvim-tree and the statusline
  'https://github.com/NMAC427/guess-indent.nvim', -- Detects tabs vs spaces per file, like VS Code
  'https://github.com/lewis6991/gitsigns.nvim', -- Git change markers in the gutter, plus hunk actions
  'https://github.com/nvim-mini/mini.statusline', -- Simple statusline
  'https://github.com/christoomey/vim-tmux-navigator', -- Ctrl-h/j/k/l across nvim splits, and out into tmux panes
  'https://github.com/github/copilot.vim', -- Copilot ghost text: <Tab> accept, <M-]>/<M-[> next/previous, <C-]> dismiss
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' }, -- Installs parsers for syntax highlighting and indentation
}

vim.cmd.colorscheme 'vscode'

-- copilot.vim is off in commit messages by default
vim.g.copilot_filetypes = { gitcommit = true }

-- Icons need a Nerd Font in the terminal (install-nerd-font.sh)
require('mini.icons').setup()
-- Telescope and nvim-tree look for nvim-web-devicons; this serves them mini.icons instead
MiniIcons.mock_nvim_web_devicons()

require('guess-indent').setup {}

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

require('mini.statusline').setup {}

-- Parsers listed here install up front, others install the first time you open such a file.
-- Compiling them needs a C compiler and the tree-sitter CLI.
local parsers = {
  'bash',
  'css',
  'diff',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}
require('nvim-treesitter').install(parsers)

local function treesitter_try_attach(buf, language)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if not vim.treesitter.language.add(language) then return end
  vim.treesitter.start(buf, language)
  if vim.treesitter.query.get(language, 'indents') ~= nil then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start treesitter, installing the parser if needed',
  group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
  callback = function(args)
    local buf = args.buf
    local language = vim.treesitter.language.get_lang(args.match)
    if not language then return end

    local installed = vim.tbl_contains(require('nvim-treesitter').get_installed 'parsers', language)
    if not installed and vim.tbl_contains(available_parsers, language) then
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})
