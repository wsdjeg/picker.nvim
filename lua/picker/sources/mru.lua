local M = {}

local previewer = require("picker.previewer.file")

M.preview_win = true

function M.preview(item, win, buf)
	previewer.preview(item, win, buf)
end

function M.get()
	return vim.tbl_map(function(t)
		return { value = t, str = t }
	end, require("mru").get())
end

function M.default_action(s)
	vim.cmd("edit " .. s)
end

return M
