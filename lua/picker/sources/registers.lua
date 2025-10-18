local M = {}

-- There are ten types of registers:		*registers* *{register}* *E354*
-- 1. The unnamed register ""
-- 2. 10 numbered registers "0 to "9
-- 3. The small delete register "-
-- 4. 26 named registers "a to "z or "A to "Z
-- 5. Three read-only registers ":, "., "%
-- 6. Alternate buffer register "#
-- 7. The expression register "=
-- 8. The selection registers "* and "+
-- 9. The black hole register "_
-- 10. Last search pattern register "/

local function map_filter(vars, map_f, filter_f)
	local rst = {}
	for _, v in ipairs(vars) do
		if filter_f(v) then
			table.insert(rst, map_f(v))
		end
	end
	return rst
end

function M.get()
	-- "
	local registers = { '"' }

	-- 0 - 9
	for i = 0, 9 do
		table.insert(registers, tostring(i))
	end

	-- a - z
	for i = 97, 122 do
		table.insert(registers, string.char(i))
	end

	-- A - Z
	for i = 65, 90 do
		table.insert(registers, string.char(i))
	end
	for _, i in ipairs({ ":", ".", "%", "#", "=", "*", "+", "_", "/" }) do
		table.insert(registers, i)
	end

	return map_filter(registers, function(reg)
		local context = vim.fn.getreg(reg, 1, true)
		return {
			value = { name = reg, context = vim.fn.getreg(reg) },
			str = string.format("[%s] %s", reg, context[1]),
			highlight = {
				{
					0,
					#reg + 2,
					"Tag",
				},
			},
		}
	end, function(t)
		return t.context ~= ""
	end)
end

function M.default_action(entry) end

return M
