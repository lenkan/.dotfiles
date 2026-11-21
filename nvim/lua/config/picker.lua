local fzf = require 'fzf-lua'
local actions = require 'fzf-lua.actions'

local M = {}

function M.setup()
  fzf.setup {
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
    -- The details column shows what a key runs, which for Lua keys is only "function: 0x…"
    keymaps = { show_details = false },
    -- One key toggles staging. The default Left / Right still work.
    git = {
      status = {
        actions = {
          ['ctrl-s'] = { fn = actions.git_stage_unstage, reload = true },
        },
      },
    },
  }
end

return M
