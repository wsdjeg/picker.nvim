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
      str = string.format(
        '[%s] %s:%d:%d',
        t.mark,
        t.file,
        t.pos[2],
        t.pos[3]
      ),
      highlight = {
        { 0, string.len(t.mark) + 2, 'Tag' },
        {
          string.len(t.mark) + string.len(t.file) + 3,
          string.len(t.mark) + string.len(t.file) + string.len(
            tostring(t.pos[2])
          ) + string.len(tostring(t.pos[3])) + 5,
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
