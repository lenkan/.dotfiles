local nvim_treesitter = require 'nvim-treesitter'

local M = {}

local function start(buf, language)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(language) then
    return
  end
  vim.treesitter.start(buf, language)
  if vim.treesitter.query.get(language, 'indents') ~= nil then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

-- Parsers install the first time you open a file type (Neovim bundles lua, markdown, vim, vimdoc)
local function on_filetype(args)
  local language = vim.treesitter.language.get_lang(args.match)
  if not language then
    return
  end
  if vim.treesitter.language.add(language) then
    return start(args.buf, language)
  end
  if vim.tbl_contains(nvim_treesitter.get_available(), language) then
    nvim_treesitter.install(language):await(function()
      start(args.buf, language)
    end)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter, installing the parser if needed',
    group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
    callback = on_filetype,
  })
end

return M
