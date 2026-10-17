vim.pack.add {
  { src = 'https://github.com/coder/claudecode.nvim', version = vim.version.range '*' }, -- Lets Claude Code (in another tmux pane) see your selection and show its edits as diffs here
}

-- Claude runs outside nvim: start `claude` in another pane from the same folder and run /ide to connect.
-- Its edits open as diffs here: :w accepts, :q rejects.
require('claudecode').setup { terminal = { provider = 'none' } }

-- Send the selection, or the file under the cursor in nvim-tree, to Claude as context
vim.keymap.set('v', '<leader>as', '<Cmd>ClaudeCodeSend<CR>', { desc = 'Send selection to Claude' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function(ev) vim.keymap.set('n', '<leader>as', '<Cmd>ClaudeCodeTreeAdd<CR>', { buffer = ev.buf, desc = 'Add file to Claude' }) end,
})
