local M = {}

local list_winid = -1

local list_bufnr = -1

local promot_winid = -1

local promot_bufnr = -1

function M.open()
	local config = require("picker.config").get()
	-- 窗口位置
	-- 宽度： columns 的 80%
	local screen_width = math.floor(vim.o.columns * config.window.width)
	-- 起始位位置： lines * 10%, columns * 10%
	local start_col = math.floor(vim.o.columns * config.window.col)
	local start_row = math.floor(vim.o.lines * config.window.row)
	-- 整体高度：lines 的 80%
	local screen_height = math.floor(vim.o.lines * config.window.height)
	if not vim.api.nvim_buf_is_valid(list_bufnr) then
		list_bufnr = vim.api.nvim_create_buf(false, true)
	end
	if not vim.api.nvim_win_is_valid(list_winid) then
		list_winid = vim.api.nvim_open_win(list_bufnr, false, {

			relative = "editor",
			width = screen_width,
			height = screen_height - 5,
			col = start_col,
			row = start_row,
			focusable = false,
			border = "rounded",
			-- title = 'Result',
			-- title_pos = 'center',
			-- noautocmd = true,
		})
	end
	if not vim.api.nvim_buf_is_valid(promot_bufnr) then
		promot_bufnr = vim.api.nvim_create_buf(false, true)
	end
	if not vim.api.nvim_win_is_valid(promot_winid) then
		promot_winid = vim.api.nvim_open_win(promot_bufnr, false, {
			relative = "editor",
			width = screen_width,
			height = 1,
			col = start_col,
			row = start_row + screen_height - 3,
			focusable = true,
			border = "rounded",
			-- noautocmd = true,
		})
	end
end

return M
