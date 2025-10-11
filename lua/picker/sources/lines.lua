local M = {}
local opts = {}
local previewer = require("picker.previewer.buffer")

---@return table<PickerItem>
function M.get()
	local bufnr = opts.current_buf
    previewer.buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    previewer.filetype = ft

	---@type table<PickerItem>
	local items = {}

	for linenr, v in ipairs(previewer.buflines) do
		table.insert(items, {
			value = {line = linenr, text = v},
			str = v,
		})
	end

	return items
end

---@param selected PickerItem
function M.default_action(selected)
	vim.cmd(tostring(selected.value.line))
end

function M.set(opt)
	opts.current_buf = opt.buf
end

M.preview_win = true

function M.preview(item, win, buf)
	previewer.preview(item.value.line, win, buf)
end

return M

