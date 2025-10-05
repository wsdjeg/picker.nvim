local M = {}

local default = {
	window = {
		width = 0.8,
		height = 0.8,
		col = 0.1,
		row = 0.1,
	},
	highlight = {
		matched = "Search",
	},
	prompt = {
		position = "bottom", --- bottom or top
	},
}

function M.setup(opt)
	default = vim.tbl_deep_extend("force", default, opt)
end

function M.get()
	return default
end

return M
