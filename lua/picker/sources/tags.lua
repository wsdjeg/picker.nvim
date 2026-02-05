---@class Picker.Sources.Tags
local M = {}

local previewer = require('picker.previewer.file')

---@return PickerItem[] items
function M.get()
  local items = {} ---@type PickerItem[]
  for _, t in ipairs(vim.fn.taglist('.*')) do
    if vim.fn.filereadable(t.filename) == 1 then
      local display_str = ('%s%s%s'):format(
        t.name,
        (' '):rep(38 - vim.fn.strdisplaywidth(t.name)),
        vim.fn.fnamemodify(t.filename, ':.')
      )
      table.insert(items, {
        value = t,
        str = display_str,
        highlight = {
          {
            math.max(38, t.name:len()),
            display_str:len(),
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
  vim.cmd.edit(item.value.filename)

  if not vim.startswith(item.value.cmd, '/') then
    pcall(vim.fn.execute, item.value.cmd)
    return
  end

  local reg_search = vim.fn.getreg('/')
  pcall(vim.fn.execute, item.value.cmd)
  vim.fn.histdel('search', -1) -- remove last search history if priview_cmd starts with /
  vim.fn.setreg('/', reg_search)
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value.filename, win, buf, { cmd = item.value.cmd })
end
return M
