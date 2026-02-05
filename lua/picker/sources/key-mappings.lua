---@class Picker.Sources.KeyMappings
local M = {}

---@return PickerItem[] items
function M.get()
  local items = {} ---@type PickerItem[]
  local maps = vim.api.nvim_get_keymap('n')
  vim.list_extend(maps, vim.api.nvim_buf_get_keymap(0, 'n'))

  for _, map in ipairs(maps) do
    local item = { ---@type PickerItem
      str = vim.fn.keytrans(
        vim.api.nvim_replace_termcodes(map.lhs, true, true, true)
      ),
      value = map,
    }
    item.str = ('%s%s%s'):format(
      item.str,
      (' '):rep(50 - #item.str),
      (map.desc or map.rhs or (map.callback and 'callback'))
    )
    table.insert(items, item)
  end
  return items
end

---@param entry PickerItem
function M.default_action(entry)
  vim.api.nvim_input(entry.value.lhs)
end

M.preview_win = true ---@type boolean
local b_previewer = require('picker.previewer.buffer')
local f_previewer = require('picker.previewer.file')

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  if item.value.callback then
    local info = debug.getinfo(item.value.callback, 'S')
    f_previewer.preview(info.source:sub(2), win, buf, info.linedefined)
    return
  end

  b_previewer.buflines = vim.split(vim.inspect(item.value), '[\r]?\n')
  b_previewer.filetype = 'lua'
  b_previewer.preview(1, win, buf, true)
end
return M
