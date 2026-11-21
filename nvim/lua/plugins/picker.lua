-- Needs the fzf binary on PATH. Tracks the default branch: the repo's release tags are years old.
vim.pack.add {
  { src = 'https://github.com/ibhagwan/fzf-lua' },
}

local fzf = require 'fzf-lua'

fzf.setup {
  winopts = { border = 'rounded', preview = { border = 'rounded' } },
  -- fzf's default smart case turns case-sensitive on any capital, so "Rename" misses "rename()"
  fzf_opts = { ['--ignore-case'] = true },
  keymap = {
    builtin = {
      true,
      ['<C-f>'] = 'preview-half-page-down',
      ['<C-b>'] = 'preview-half-page-up',
      ['<C-o>'] = 'toggle-preview',
    },
    fzf = {
      true,
      ['ctrl-f'] = 'preview-half-page-down',
      ['ctrl-b'] = 'preview-half-page-up',
      ['ctrl-o'] = 'toggle-preview',
    },
  },
  -- One key toggles staging, in place of Left / Right (which then move the cursor in the query again). No discard.
  git = {
    status = {
      actions = {
        ['left'] = false,
        ['right'] = false,
        ['ctrl-x'] = false,
        ['ctrl-s'] = { fn = require('fzf-lua.actions').git_stage_unstage, reload = true },
      },
    },
  },
}

vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Help' })
vim.keymap.set('n', '<leader>fs', fzf.lsp_document_symbols, { desc = 'Symbols in file' })
vim.keymap.set('n', '<leader>fS', fzf.lsp_live_workspace_symbols, { desc = 'Symbols in workspace' })
vim.keymap.set('n', '<leader>fd', fzf.git_status, { desc = 'Changed files' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>f?', fzf.builtin, { desc = 'All pickers' })
vim.keymap.set('n', '<leader>?', fzf.keymaps, { desc = 'All keymaps' })
