local neoconf = require 'neoconf'

-- {
--   "vim-options": {
--     "_": {
--       "textwidth": 78,
--     },
--     "python": {
--       "textwidth": 78,
--     },
--   }
-- }

local M = {}

function M.apply(filetype)
  local g_opts = neoconf.get('vim-options._', {})
  local l_opts = {}
  if filetype and filetype ~= '' then
    l_opts = neoconf.get(string.format('vim-options.%s', filetype), {})
  end
  local opts = vim.tbl_deep_extend('force', g_opts, l_opts) or {}
  for opt, value in pairs(opts) do
    vim.opt_local[opt] = value
  end
end

function M.on_filetype(event)
  M.apply(event.match)
end

function M.setup()
  local augroup_id =
    vim.api.nvim_create_augroup('neoconf-vim-options', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup_id,
    pattern = '*',
    callback = M.on_filetype,
  })
  M.apply(nil)
end

return M
