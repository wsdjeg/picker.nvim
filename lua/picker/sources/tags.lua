local M = {}

local previewer = require('picker.previewer.file')

function M.get()
  local tags = vim.fn.taglist('.*')
  local items = {}

  for _, t in ipairs(tags) do
    if vim.fn.filereadable(t.filename) == 1 then
      local display_str = t.name
        .. string.rep(' ', 38 - vim.fn.strdisplaywidth(t.name))
        .. vim.fn.fnamemodify(t.filename, ':.')
      table.insert(items, {
        value = t,
        str = display_str,
        highlight = {
          {
            math.max(38, #t.name),
            #display_str,
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
    vim.cmd.edit(item.value.filename)
    if vim.startswith(item.value.cmd, '/') then
      local reg_search = vim.fn.getreg('/')
      pcall(vim.fn.execute, item.value.cmd)
      vim.fn.histdel('search', -1) -- remove last search history if priview_cmd starts with /
      vim.fn.setreg('/', reg_search)
    else
      pcall(vim.fn.execute, item.value.cmd)
    end
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
  previewer.preview(item.value.filename, win, buf, { cmd = item.value.cmd })
end

return M
