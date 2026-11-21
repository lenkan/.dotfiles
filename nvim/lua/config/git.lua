local gitsigns = require 'gitsigns'

local M = {}

function M.next_hunk()
  if vim.wo.diff then
    vim.cmd.normal { ']c', bang = true }
  else
    gitsigns.nav_hunk 'next'
  end
end

function M.previous_hunk()
  if vim.wo.diff then
    vim.cmd.normal { '[c', bang = true }
  else
    gitsigns.nav_hunk 'prev'
  end
end

function M.blame_line()
  gitsigns.blame_line { full = true }
end

function M.diff_head()
  gitsigns.diffthis 'HEAD'
end

function M.setup()
  gitsigns.setup {
    signs = { add = { text = '+' } },
    signs_staged = { add = { text = '+' } },
  }
end

return M
