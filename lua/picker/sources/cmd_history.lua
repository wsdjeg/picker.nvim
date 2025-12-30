local M = {}
---@return table<PickerItem>
function M.get()
  local items = {}
  for i = vim.fn.histnr('cmd'), 1, -1 do
    table.insert(items, {
      str = vim.fn.histget('cmd', i),
      value = { cmd = vim.fn.histget('cmd', i), index = i },
    })
  end
  return items
end

function M.actions()
  return {
    ['<C-d>'] = function(entry)
      vim.fn.histdel('cmd', entry.value.index)
    end,
  }
end

---@param selected PickerItem
function M.default_action(selected)
  vim.cmd(tostring(selected.value.cmd))
end

return M
