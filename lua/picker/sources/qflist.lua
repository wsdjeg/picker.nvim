---@class Picker.Sources.QfList
local M = {}

local previewer = require('picker.previewer.file')

---@return PickerItem[] items
function M.get()
  return vim.tbl_map(
    ---@param t { bufnr: integer, file: string, lnum: string, text: string }
    function(t)
      t.file = vim.api.nvim_buf_get_name(t.bufnr)
      return {
        value = t,
        str = string.format('%s:%d:%s', t.file, t.lnum, t.text),
        highlight = {
          {
            0,
            string.len(t.file) + string.len(tostring(t.lnum)) + 2,
            'Comment',
          },
        },
      }
    end,
    vim.fn.getqflist()
  )
end

---@param entry PickerItem
function M.default_action(entry)
  vim.cmd.edit(entry.value.file)
  vim.cmd(tostring(entry.value.lnum))
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value.file, win, buf, item.value.lnum)
end
return M
