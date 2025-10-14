local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then
			return false
		end
		return true
	end, vim.api.nvim_list_bufs())

	return vim.tbl_map(function(t)
		return {
			value = t,
			str = vim.api.nvim_buf_get_name(t),
		}
	end, bufnrs)
end

function M.default_action(s)
	vim.cmd("edit " .. s.str)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(item.str, win, buf)
end

return M
