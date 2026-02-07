---@class Picker.Sources.Colorscheme
local M = {}

local previewer = require('picker.previewer.colorscheme')

---@return PickerItem[] completions
function M.get()
  return vim.tbl_map(function(t) ---@param t string
    return { value = t, str = t }
  end, vim.fn.getcompletion('colorscheme ', 'cmdline'))
end

---@param selected PickerItem
function M.default_action(selected)
  vim.cmd.colorscheme(selected.value)
end

M.preview_win = false ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value, win, buf)
end

return M
