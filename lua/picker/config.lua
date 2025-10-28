local M = {}

local default = {
	filter = {
		ignorecase = false,
	},
	window = {
		width = 0.8,
		height = 0.8,
		col = 0.1,
		row = 0.1,
		current_icon = ">",
		current_icon_hl = "CursorLine",
		enable_preview = false,
		preview_timeout = 500,
	},
	highlight = {
		matched = "Tag",
	},
	prompt = {
		position = "bottom", --- bottom or top
		icon = ">",
		icon_hl = "Error",
		insert_timeout = 100,
		title = true,
	},
	mappings = {
		close = "<Esc>",
		next_item = "<Tab>",
		previous_item = "<S-Tab>",
		open_item = "<Enter>",
		toggle_preview = "<C-p>",
	},
}

function M.setup(opt)
	default = vim.tbl_deep_extend("force", default, opt)
end

function M.get()
	return default
end

return M
