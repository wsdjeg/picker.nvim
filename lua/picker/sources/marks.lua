local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	local marks = vim.fn.getmarklist()
	local items = {}

	for _, t in ipairs(marks) do
		if vim.fn.filereadable(vim.api.nvim_buf_get_name(t.pos[1])) == 1 then
			table.insert(items, {
				value = t,
				str = string.format("[%s] %s:%d:%d", t.mark, t.file, t.pos[2], t.pos[3]),
				highlight = {
					{
						0,
						#t.mark + 2,
						"Tag",
					},
					{
                        #t.mark + #t.file + 3,
						#t.mark + #t.file + #tostring(t.pos[2]) + #tostring(t.pos[3]) + 5,
						"Comment",
					},
				},
			})
		end
	end
	return items
end

---@field item PickerItem
function M.default_action(item)
    vim.cmd('edit ' .. vim.api.nvim_buf_get_name(item.value.pos[1]))
    vim.cmd(tostring(item.value.pos[2]))
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(vim.api.nvim_buf_get_name(item.value.pos[1]), win, buf, item.value.pos[2])
end

return M

