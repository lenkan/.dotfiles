vim.pack.add {
  { src = 'https://github.com/Mofiqul/vscode.nvim' },
  {
    src = 'https://github.com/nvim-mini/mini.icons',
    version = vim.version.range '*',
  },
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
    src = 'https://github.com/github/copilot.vim',
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
}

vim.cmd.colorscheme 'vscode'

-- copilot.vim is off in commit messages by default
vim.g.copilot_filetypes = { gitcommit = true }

require('mini.icons').setup()
-- nvim-tree looks for nvim-web-devicons; this serves it mini.icons instead
MiniIcons.mock_nvim_web_devicons()

require('guess-indent').setup {}

require('which-key').setup {
  spec = {
    { '<leader>f', group = 'Find' },
    { '<leader>h', group = 'Git' },
    { '<leader>p', group = 'Problems' },
  },
}

local gitsigns = require 'gitsigns'
gitsigns.setup {
  on_attach = function(bufnr)
    vim.keymap.set('n', ']h', function()
      gitsigns.nav_hunk 'next'
    end, { buffer = bufnr, desc = 'Next git hunk' })
    vim.keymap.set('n', '[h', function()
      gitsigns.nav_hunk 'prev'
    end, { buffer = bufnr, desc = 'Previous git hunk' })

    vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
    vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
    vim.keymap.set('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { buffer = bufnr, desc = 'Reset selected lines' })
    vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
    vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { buffer = bufnr, desc = 'Stage file' })
    vim.keymap.set('n', '<leader>hU', gitsigns.reset_buffer_index, { buffer = bufnr, desc = 'Unstage file' })
    vim.keymap.set('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, { buffer = bufnr, desc = 'Blame line' })
    vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { buffer = bufnr, desc = 'Diff against index' })
  end,
}

require('mini.statusline').setup {}

local function treesitter_start(buf, language)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(language) then
    return
  end
  vim.treesitter.start(buf, language)
  if vim.treesitter.query.get(language, 'indents') ~= nil then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

-- Parsers install the first time you open a file type (Neovim bundles lua, markdown, vim, vimdoc)
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start treesitter, installing the parser if needed',
  group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
  callback = function(args)
    local language = vim.treesitter.language.get_lang(args.match)
    if not language then
      return
    end
    if vim.treesitter.language.add(language) then
      return treesitter_start(args.buf, language)
    end
    if vim.tbl_contains(require('nvim-treesitter').get_available(), language) then
      require('nvim-treesitter').install(language):await(function()
        treesitter_start(args.buf, language)
      end)
    end
  end,
})
