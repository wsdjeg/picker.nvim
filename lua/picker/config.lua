local M = {}

local default = {
	window = {
		width = 0.8,
		height = 0.8,
		col = 0.1,
		row = 0.1,
        current_icon = '>',
        current_icon_hl = 'Normal'
	},
	highlight = {
		matched = "Search",
	},
	prompt = {
		position = "bottom", --- bottom or top
		icon = ">",
		icon_hl = "Error",
	},
	mappings = {
		close = "<Esc>",
		next_item = "<Tab>",
		previous_item = "<S-Tab>",
		open_item = "<Enter>",
	},
}

function M.setup(opt)
	default = vim.tbl_deep_extend("force", default, opt)
end

function M.get()
	return default
end

return M
