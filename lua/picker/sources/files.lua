local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	return vim.tbl_map(function(t)
		return {
			value = t,
			str = t,
		}
	end, vim.split(vim.system({ "rg", "--files" }, { text = true }):wait().stdout, "\n", { trimempty = true }))
end

function M.default_action(s)
	vim.cmd("edit " .. s)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(item.value, win, buf)
end

return M
