---@class Picker.Sources.SearchHistory
local M = {}

---@return PickerItem[] items
function M.get()
  local items = {} ---@type PickerItem[]
  for i = vim.fn.histnr('search'), 1, -1 do
    table.insert(items, {
      str = vim.fn.histget('search', i),
      value = { cmd = vim.fn.histget('search', i), index = i },
    })
  end
  return items
end

---@return table<string, fun(entry: PickerItem)>
function M.actions()
  return { ---@type table<string, fun(entry: PickerItem)>
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
