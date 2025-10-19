local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	return vim.tbl_map(function(t)
		local filename = vim.api.nvim_buf_get_name(t.bufnr)
		local context = vim.api.nvim_buf_get_lines(t.bufnr, t.lnum - 1, t.lnum, false)[1] or ''
		t.filename = t.filename or filename
		if #filename == 0 then
			filename = "No Name"
		end
		return {
			value = t,
			str = string.format("%s:%d:%d:%s", filename, t.lnum, t.col, context),
			highlight = {
				{
					0,
					#filename + #tostring(t.lnum) + #tostring(t.col) + 3,
					"Comment",
				},
			},
		}
	end, vim.fn.getjumplist()[1])
end

---@field item PickerItem
function M.default_action(item)
	vim.api.nvim_win_set_buf(0, item.value.bufnr)
	vim.api.nvim_win_set_cursor(0, { item.value.lnum, item.value.col })
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(item.value.filename, win, buf, item.value.lnum)
end

return M
