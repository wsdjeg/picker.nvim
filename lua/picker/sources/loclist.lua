---@class Picker.Sources.Loclist
local M = {}

local previewer = require('picker.previewer.file')

---@return PickerItem[] items
function M.get()
  return vim.tbl_map(
    ---@param t { bufnr: integer, file: string, lnum: integer, shortname: string, text: string }
    function(t)
      t.file = vim.api.nvim_buf_get_name(t.bufnr)
      t.shortname = vim.fn.fnamemodify(t.file, ':.')
      return { ---@type PickerItem
        value = t,
        str = string.format('%s:%d:%s', t.shortname, t.lnum, t.text),
        highlight = {
          {
            0,
            #t.shortname + #tostring(t.lnum) + 2,
            'Comment',
          },
        },
      }
    end,
    vim.fn.getloclist(vim.api.nvim_get_current_win())
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
