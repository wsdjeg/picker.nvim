local M = {}
---@return table<PickerItem>
function M.get()
  local items = {}
  for i = vim.fn.histnr('search'), 1, -1 do
    table.insert(items, {
      str = vim.fn.histget('search', i),
      value = { cmd = vim.fn.histget('search', i), index = i },
    })
  end
  return items
end

function M.actions()
  return {
    ['<C-d>'] = function(entry)
      vim.fn.histdel('search', entry.value.index)
    end,
  }
end

---@param selected PickerItem
function M.default_action(selected)
  vim.fn.setreg('/', selected.str)
  vim.api.nvim_input('n')
end

return M

