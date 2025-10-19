local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	return vim.tbl_map(function(t)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(t.bufnr), ":.")
		return {
			value = t,
			str = string.format("%s:%d:%d", filename, t.lnum, t.col),
		}
	end, vim.fn.getjumplist()[1])
end

---@field item PickerItem
function M.default_action(item)
	vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), item.value.bufnr)
	vim.api.nvim_win_set_cursor(0, { item.value.lnum, item.value.col })
end

return M
