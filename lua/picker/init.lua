---@class Picker
local M = {}

local util = require('picker.util')

---@param argv string[]
---@param opt? table
function M.open(argv, opt)
  util.info('argv is: ' .. vim.inspect(argv))
  if vim.tbl_isempty(argv) then
    require('picker.windows').open(require('picker.sources'))
    return
  end
  local ok, source = pcall(require, 'picker.sources.' .. argv[1])
  if not ok then
    util.notify(
      string.format('Unable to find source "%s" for picker.nvim', argv[1])
    )
    return
  end

  if source.enabled and not (source.enabled and source.enabled()) then
    return
  end
  source.name = source.name or argv[1]
  require('picker.windows').open(source, opt)
end

---@param opt? PickerConfig
function M.setup(opt)
  require('picker.config').setup(opt or {})
end

return M
