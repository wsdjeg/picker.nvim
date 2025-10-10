local M = {}

local fzy = require("picker.matchers.fzy")

---@param input string 输入值
---@param items table<PickerItem> 候选列表
function M.filter(input, items)
	local result = {}

	if #input == 0 then
		for i, item in ipairs(items) do
			table.insert(result, { i, {}, 0, item })
		end
	else
		for i, item in ipairs(items) do
			if fzy.has_match(input, item.str) then
				local p, s = fzy.positions(input, item.str)
				table.insert(result, { i, p, s, item })
			end
		end

		--- sort by scope?

		table.sort(result, function(a, b)
			return a[3] > b[3]
		end)
	end

	return result
end

return M
