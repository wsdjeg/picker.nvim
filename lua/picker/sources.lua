local M = {}

function M.get()
	return vim.tbl_map(function(t)
		t = vim.fn.fnamemodify(t, ":t:r")
		return {
			value = t,
			str = t,
		}
	end, vim.api.nvim_get_runtime_file("lua/picker/sources/*.lua", true))
end

---@param selected PickerItem
function M.default_action(selected)
	vim.cmd("Picker " .. selected.value)
    -- @fixme why the default mode is normal mode.
end

M.preview_win = false

return M
