---@class Picker.Sources.Marks
local M = {}

local previewer = require('picker.previewer.file')

---@return PickerItem[] items
function M.get()
  local marks = vim.fn.getmarklist()
  local items = {} ---@type PickerItem[]

  for _, t in ipairs(marks) do
    table.insert(items, {
      value = t,
      str = ('[%s] %s:%d:%d'):format(t.mark, t.file, t.pos[2], t.pos[3]),
      highlight = {
        { 0, t.mark:len() + 2, 'Tag' },
        {
          t.mark:len() + t.file:len() + 3,
          t.mark:len() + t.file:len() + tostring(t.pos[2]):len() + tostring(
            t.pos[3]
          ):len() + 5,
          'Comment',
        },
      },
    })
  end
  return items
end

---@param item PickerItem
function M.default_action(item)
  vim.cmd.edit(item.value.file)
  vim.cmd(tostring(item.value.pos[2]))
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value.file, win, buf, item.value.pos[2])
end
return M
