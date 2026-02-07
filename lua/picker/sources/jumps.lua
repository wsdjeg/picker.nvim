---@class Picker.Sources.Jumps
local M = {}

local previewer = require('picker.previewer.file')

---@return PickerItem[] items
function M.get()
  local items = {} ---@type PickerItem[]
  local jumps = vim.fn.getjumplist()[1]
  for _, t in ipairs(jumps) do
    t.filename = vim.api.nvim_buf_get_name(t.bufnr)
    if vim.fn.filereadable(t.filename) == 1 then
      table.insert(items, {
        value = t,
        str = string.format('%s:%d:%d', t.filename, t.lnum, t.col),
        highlight = {
          {
            #t.filename,
            #t.filename + #tostring(t.lnum) + #tostring(t.col) + 2,
            'Comment',
          },
        },
      })
    end
  end
  return items
end

---@param item PickerItem
function M.default_action(item)
  vim.api.nvim_win_set_buf(0, item.value.bufnr)
  pcall(vim.api.nvim_win_set_cursor0, { item.value.lnum, item.value.col })
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value.filename, win, buf, item.value.lnum)
end

return M
