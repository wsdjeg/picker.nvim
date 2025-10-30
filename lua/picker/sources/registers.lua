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

local previewer = require("picker.previewer.buffer")

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

	local entrys = {}

	for _, reg in ipairs(registers) do
		local context = vim.fn.getreg(reg)
		if context ~= "" then
			-- if the context is `\n\+`
			local lines = vim.split(context, "\n")

			local text = #lines > 1 and lines[1] .. "\\n" or lines[1]

			table.insert(entrys, {

				value = { name = reg, context = context },
				str = string.format("[%s] %s", reg, text),
				highlight = {
					{
						0,
						#reg + 2,
						"Tag",
					},
				},
			})
		end
	end
	return entrys
end

function M.default_action(entry)
	vim.api.nvim_paste(entry.value.context, false, -1)
end

M.preview_win = true

function M.preview(item, win, buf)
	previewer.buflines = vim.split(item.value.context, "[\r]?\n")
	vim.api.nvim_set_option_value("number", true, { win = win })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, previewer.buflines)
	previewer.filetype = nil
	previewer.preview(1, win, buf)
end
return M
