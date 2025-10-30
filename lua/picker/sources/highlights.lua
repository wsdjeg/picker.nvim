local M = {}

local previewer = require("picker.previewer.buffer")

function M.get()
	local hls = vim.api.nvim_get_hl(0, {})

	local items = {}

	for k, v in pairs(hls) do
		table.insert(items, {
			value = v,
			str = k,
			highlight = {
				{ 0, #k, k },
			},
		})
	end

	return items
end

function M.default_action(entry)
	vim.fn.setreg('"', entry.str)
end

M.preview_win = true

local function format(hl)
	for _, v in ipairs({ "fg", "bg", "sp" }) do
		if type(hl[v]) == "number" then
			hl[v] = string.format("#%06X", hl[v])
		end
	end
	return hl
end

---@field item PickerItem
function M.preview(item, win, buf)
	local def = string.format("%s = %s", item.str, vim.inspect(format(item.value)))

	local link_group = item.value.link

	while link_group do
		local link_group_def = vim.api.nvim_get_hl(0, { name = link_group })

		def = def .. "\n\n" .. string.format("%s = %s", link_group, vim.inspect(format(link_group_def)))
		link_group = link_group_def.link
		if not link_group then
			break
		end
	end

	previewer.buflines = vim.split(def, "\n")
	previewer.filetype = "lua"

	previewer.preview(1, win, buf, true)
end

return M
