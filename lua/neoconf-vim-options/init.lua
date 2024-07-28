local nc = require 'nvim-conf'

-- vim_options = nc.per_filetype_value {
--   _ = {
--     textwidth = 78,
--   },
--   python = {
--     textwidth = 78,
--   },
-- }

local M = {}

function M.apply(filetype)
  local ctx = nc.Context.new()
  ctx.filetype = filetype
  local opts = require 'nvim-conf'.get(ctx).vim_options or {}
  for opt, value in pairs(opts) do
    vim.opt_local[opt] = value
  end
end

function M.on_filetype(event)
  M.apply(event.match)
end

function M.setup()
  local augroup_id =
    vim.api.nvim_create_augroup('nvim-conf-vim-options', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup_id,
    pattern = '*',
    callback = M.on_filetype,
  })
  M.apply(nil)
end

return M
