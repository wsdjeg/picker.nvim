local M = {}

local previewer = require("picker.previewer.buffer")

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

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.buflines = vim.api.nvim_buf_get_lines(item.value.bufnr, 0, -1, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, previewer.buflines)
	previewer.filetype = vim.api.nvim_get_option_value("filetype", { buf = item.value.bufnr })
	previewer.preview(item.value.lnum, win, buf)
end

return M
