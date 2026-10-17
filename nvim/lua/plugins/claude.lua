vim.pack.add {
  { src = 'https://github.com/coder/claudecode.nvim', version = vim.version.range '*' }, -- Lets Claude Code in another pane see the selection and show its edits as diffs
}

-- No terminal in nvim: run :ClaudeCodeStart, then `claude` in another pane and /ide to connect.
-- Not started by default, so commit messages and difftool don't show up in /ide.
require('claudecode').setup { auto_start = false, terminal = { provider = 'none' } }

vim.keymap.set('v', '<leader>as', '<Cmd>ClaudeCodeSend<CR>', { desc = 'Send selection to Claude' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function(ev) vim.keymap.set('n', '<leader>as', '<Cmd>ClaudeCodeTreeAdd<CR>', { buffer = ev.buf, desc = 'Add file to Claude' }) end,
})
