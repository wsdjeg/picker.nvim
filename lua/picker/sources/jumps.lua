local M = {}

local previewer = require('picker.previewer.file')

function M.get()
  local jumps = vim.fn.getjumplist()[1]
  local items = {}

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

---@field item PickerItem
function M.default_action(item)
  vim.api.nvim_win_set_buf(0, item.value.bufnr)
  pcall(function()
    vim.api.nvim_win_set_cursor(0, { item.value.lnum, item.value.col })
  end)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
  previewer.preview(item.value.filename, win, buf, item.value.lnum)
end

return M
