---@class Picker.Sources.CmdHistory
local M = {}

---@return PickerItem[] items
function M.get()
  local items = {} ---@type PickerItem[]
  for i = vim.fn.histnr('cmd'), 1, -1 do
    table.insert(items, {
      str = vim.fn.histget('cmd', i),
      value = { cmd = vim.fn.histget('cmd', i), index = i },
    })
  end
  return items
end

---@return table<string, fun(entry: PickerItem)> actions
function M.actions()
  return { ---@type table<string, fun(entry: PickerItem)>
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
