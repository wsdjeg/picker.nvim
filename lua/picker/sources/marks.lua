local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	local marks = vim.fn.getmarklist()
	local items = {}

	for _, t in ipairs(marks) do
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
	return items
end

---@field item PickerItem
function M.default_action(item)
	vim.cmd("edit " .. item.value.file)
	vim.cmd(tostring(item.value.pos[2]))
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(item.value.file, win, buf, item.value.pos[2])
end

return M
