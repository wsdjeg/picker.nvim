local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	return vim.tbl_map(function(t)
		t.filename = vim.api.nvim_buf_get_name(t.bufnr)
		return {
			value = t,
			str = string.format("%s:%d:%d", t.filename, t.lnum, t.col),
			highlight = {
				{
                    #t.filename,
					#t.filename + #tostring(t.lnum) + #tostring(t.col) + 2,
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
