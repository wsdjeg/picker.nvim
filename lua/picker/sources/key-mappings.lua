local M = {}

M.get = function()
  local items = {}

  local maps = vim.api.nvim_get_keymap('n')
  vim.list_extend(maps, vim.api.nvim_buf_get_keymap(0, 'n'))

  for _, map in ipairs(maps) do
    local item = { value = map }
    item.str = vim.fn.keytrans(
      vim.api.nvim_replace_termcodes(map.lhs, true, true, true)
    )

    item.str = item.str
      .. string.rep(' ', 50 - #item.str)
      .. (map.desc or map.rhs or (map.callback and 'callback'))
    table.insert(items, item)
  end

  return items
end

M.default_action = function(entry)
  vim.api.nvim_input(entry.value.lhs)
end

M.preview_win = true
local b_previewer = require('picker.previewer.buffer')
local f_previewer = require('picker.previewer.file')

function M.preview(item, win, buf)
  if item.value.callback then
    local info = debug.getinfo(item.value.callback, 'S')
    f_previewer.preview(info.source:sub(2), win, buf, info.linedefined)
  else
    b_previewer.buflines = vim.split(vim.inspect(item.value), '[\r]?\n')
    b_previewer.filetype = 'lua'
    b_previewer.preview(1, win, buf, true)
  end
end
return M
