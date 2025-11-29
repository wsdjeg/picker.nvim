local M = {}

local previewer = require("picker.previewer.colorscheme")

function M.get()
	return vim.tbl_map(function(t)
		return { value = t, str = t }
	end, vim.fn.getcompletion("colorscheme ", "cmdline"))
end

function M.default_action(selected)
	vim.cmd("colorscheme " .. selected.value)
end

M.preview_win = false

function M.preview(item, win, buf)
	previewer.preview(item.value, win, buf)
end

return M
