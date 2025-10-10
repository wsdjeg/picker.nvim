local M = {}

local fzy = require("picker.matchers.fzy")

---@param input string 输入值
---@param items table<PickerItem> 候选列表
function M.filter(input, items)
	local result = {}

	for i, item in ipairs(items) do
		if #input == 0 then
			table.insert(result, { i, {}, 0 })
		elseif fzy.has_match(input, item.str) then
			local p, s = fzy.positions(input, item.str)
			table.insert(result, { i, p, s })
		end
	end

	return result
end

return M
