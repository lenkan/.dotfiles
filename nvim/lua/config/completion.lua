local blink = require 'blink.cmp'

local M = {}

function M.setup()
  blink.setup {
    keymap = {
      -- Enter accepts. Tab jumps through snippet fields, otherwise falls through to the inline completion.
      preset = 'enter',
      -- Instead of Ctrl-Space, which never arrives inside tmux since it is the tmux prefix
      ['<C-j>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },
    completion = {
      menu = { border = 'rounded' },
      documentation = { auto_show = true, window = { border = 'rounded' } },
    },
    -- The Lua matcher avoids downloading a prebuilt Rust binary
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true, window = { border = 'rounded' } },
  }
end

return M
