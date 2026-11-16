vim.pack.add {
  -- Floating column file explorer. Edit the listing like text, then = applies the changes.
  {
    src = 'https://github.com/nvim-mini/mini.files',
    version = vim.version.range '*',
  },
}

local files = require 'mini.files'

-- Renames, moves, creates and deletes are sent to language servers by default, so ts_ls updates imports.
files.setup {
  -- Enter opens the file and closes the explorer (default L). l still opens it and keeps the explorer open.
  mappings = { go_in_plus = '<CR>' },
  windows = {
    -- Shows the file under the cursor, for skimming nearby files without opening them
    preview = true,
    width_focus = 30,
    width_preview = 80,
  },
}

local function toggle_explorer()
  if files.close() ~= nil then
    return
  end
  -- Start at the current file. Fall back to the working directory for unnamed and non-file buffers (like fugitive's).
  local path = vim.api.nvim_buf_get_name(0)
  files.open(vim.uv.fs_stat(path) and path or nil)
end

vim.keymap.set('n', '\\', toggle_explorer, { desc = 'Toggle file explorer (at current file)' })
