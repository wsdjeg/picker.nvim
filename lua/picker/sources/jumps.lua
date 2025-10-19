local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	return vim.tbl_map(function(t)
		t.filename = vim.api.nvim_buf_get_name(t.bufnr)
        --- if the buf is not loaded the context is nil
		t.context = vim.api.nvim_buf_get_lines(t.bufnr, t.lnum - 1, t.lnum, false)[1] or ''
		return {
			value = t,
			str = string.format("%s:%d:%d:%s", t.filename, t.lnum, t.col, t.context),
			highlight = {
				{
					0,
					#t.filename + #tostring(t.lnum) + #tostring(t.col) + 3,
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
