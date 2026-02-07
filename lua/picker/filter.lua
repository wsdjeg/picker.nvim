---@class Picker.Filter
local M = {}

---@param input string
---@param source PickerSource
---@param ignorecase boolean
function M.filter(input, source, ignorecase)
  local config = require('picker.config').get()
  local ok, matcher =
    pcall(require, 'picker.matchers.' .. config.filter.matcher)
  if not ok then
    matcher = require('picker.matchers.fzy')
  end
  if input == '' then
    local i = 1
    source.filter_items = vim.tbl_map(function(t)
      i = i + 1
      return { i, {}, 0, t }
    end, source.state.items)
  else
    if
      source.state.previous_input
      and string.len(source.state.previous_input) > 0
      and matcher.has_match(source.state.previous_input, input, ignorecase)
    then
      local rst = {}
      for i, v in ipairs(source.filter_items) do
        if matcher.has_match(input, v[4].str, ignorecase) then
          local p, s = matcher.positions(input, v[4].str, ignorecase)
          table.insert(rst, { i, p, s, v[4] })
        end
      end
      if source.state.filter_count < #source.state.items then
        for i = source.state.filter_count, #source.state.items do
          if
            matcher.has_match(input, source.state.items[i].str, ignorecase)
          then
            local p, s =
              matcher.positions(input, source.state.items[i].str, ignorecase)
            table.insert(rst, { i, p, s, source.state.items[i] })
          end
        end
      end
      source.filter_items = rst
    else
      local rst = {}
      for i = 1, #source.state.items do
        if
          matcher.has_match(input, source.state.items[i].str, ignorecase)
        then
          local p, s =
            matcher.positions(input, source.state.items[i].str, ignorecase)
          table.insert(rst, { i, p, s, source.state.items[i] })
        end
      end
      source.filter_items = rst
    end
    table.sort(source.filter_items, function(a, b)
      return a[3] > b[3]
    end)
  end
  source.state.previous_input = input
  source.state.filter_count = #source.state.items
end
return M
