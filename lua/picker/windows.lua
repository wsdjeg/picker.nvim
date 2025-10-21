local M = {}

--- what the fuck?
--- 没办法禁用 cmp，只能 require 后 setup？？
local ok, cmp = pcall(require, "cmp")
if not ok then
	vim.cmd("doautocmd InsertEnter")
	ok, cmp = pcall(require, "cmp")
end

local filter = require("picker.filter")

local filter_rst

local list_winid = -1

local list_bufnr = -1

local promot_winid = -1

local promot_bufnr = -1

local preview_bufnr = -1

local preview_winid = -1

local extns = vim.api.nvim_create_namespace("picker.nvim")

local config

local prompt_count_id

local current_icon_extmark

local winhighlight = "NormalFloat:Normal,FloatBorder:WinSeparator,Search:None,CurSearch:None"

local function update_result_count()
	local count = vim.api.nvim_buf_line_count(list_bufnr)
	local line = vim.api.nvim_win_get_cursor(list_winid)[1]
	prompt_count_id = vim.api.nvim_buf_set_extmark(promot_bufnr, extns, 0, 0, {
		id = prompt_count_id,
		virt_text = { { string.format("%d/%d", line, count), "Comment" } },
		virt_text_pos = "right_align",
	})
	current_icon_extmark = vim.api.nvim_buf_set_extmark(list_bufnr, extns, line - 1, 0, {
		id = current_icon_extmark,
		sign_text = config.window.current_icon,
		sign_hl_group = config.window.current_icon_hl,
	})
end

local function highlight_list_windows()
	local info = vim.fn.getwininfo(list_winid)[1]
	local from = info.topline
	local to = info.botline
	if #filter_rst > 0 then
		local ns = vim.api.nvim_create_namespace("picker-matched-chars")
		for x = from, to do
			for y = 1, #filter_rst[x][2] do
				local col = filter_rst[x][2][y]
				vim.api.nvim_buf_set_extmark(list_bufnr, ns, x - 1, col - 1, {
					end_col = col,
					hl_group = config.highlight.matched,
				})
			end
			if filter_rst[x][4].highlight then
				for y = 1, #filter_rst[x][4].highlight do
					local col_a, col_b, hl = unpack(filter_rst[x][4].highlight[y])
					vim.api.nvim_buf_set_extmark(list_bufnr, ns, x - 1, col_a, {
						end_col = col_b,
						hl_group = hl,
					})
				end
			end
		end
	end
end

--- @class PickerItem
--- @field str string
--- @field value? any

--- @class PickerSource
--- @field get function
--- @field default_action function
--- @field preview_win boolean
--- @field preview function
--- @field set function
--- @field actions? table

--- @param source PickerSource
--- @param opt?
function M.open(source, opt)
	opt = opt or {}
	config = require("picker.config").get()
	if source.set then
		source.set(opt)
	end
	-- 窗口位置
	-- 宽度： columns 的 80%
	local screen_width = math.floor(vim.o.columns * config.window.width)
	-- 起始位位置： lines * 10%, columns * 10%
	local start_col = math.floor(vim.o.columns * config.window.col)
	local start_row = math.floor(vim.o.lines * config.window.row)
	-- 整体高度：lines 的 80%
	local screen_height = math.floor(vim.o.lines * config.window.height)
	if not vim.api.nvim_buf_is_valid(list_bufnr) then
		list_bufnr = vim.api.nvim_create_buf(false, false)
	end
	if not vim.api.nvim_buf_is_valid(promot_bufnr) then
		promot_bufnr = vim.api.nvim_create_buf(false, false)
	end
	if config.prompt.position == "bottom" then
		-- 启用预览，并且source需要预览窗口，则初始化预览窗口
		if config.window.enable_preview and source.preview_win then
			if not vim.api.nvim_buf_is_valid(preview_bufnr) then
				preview_bufnr = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = preview_bufnr })
			end
			-- 初始化时，清空 preview 窗口内容
			vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, {})
			if not vim.api.nvim_win_is_valid(preview_winid) then
				preview_winid = vim.api.nvim_open_win(preview_bufnr, false, {
					relative = "editor",
					width = screen_width,
					height = math.floor((screen_height - 5) / 2),
					col = start_col,
					row = start_row,
					focusable = false,
					border = "rounded",
				})
				vim.api.nvim_set_option_value(
					"winhighlight",
					winhighlight,
					{ win = preview_winid }
				)
				vim.api.nvim_set_option_value("number", false, { win = preview_winid })
				vim.api.nvim_set_option_value("relativenumber", false, { win = preview_winid })
				vim.api.nvim_set_option_value("cursorline", false, { win = preview_winid })
				vim.api.nvim_set_option_value("signcolumn", "yes", { win = preview_winid })
			end
			if not vim.api.nvim_win_is_valid(list_winid) then
				list_winid = vim.api.nvim_open_win(list_bufnr, false, {
					relative = "editor",
					width = screen_width,
					height = screen_height - 5 - math.floor((screen_height - 5) / 2) - 2,
					col = start_col,
					row = start_row + math.floor((screen_height - 5) / 2) + 2,
					focusable = false,
					border = "rounded",
					-- title = 'Result',
					-- title_pos = 'center',
					-- noautocmd = true,
				})
			end
		else
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
		end
		if not vim.api.nvim_win_is_valid(promot_winid) then
			promot_winid = vim.api.nvim_open_win(promot_bufnr, true, {
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
	else
		if config.window.enable_preview and source.preview_win then
			if not vim.api.nvim_buf_is_valid(preview_bufnr) then
				preview_bufnr = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = preview_bufnr })
			end
			-- 初始化时，清空 preview 窗口内容
			vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, {})
			if not vim.api.nvim_win_is_valid(preview_winid) then
				preview_winid = vim.api.nvim_open_win(preview_bufnr, false, {
					relative = "editor",
					width = screen_width,
					height = math.floor((screen_height - 5) / 2),
					col = start_col,
					row = start_row + math.floor((screen_height - 5) / 2) + 4,
					focusable = false,
					border = "rounded",
				})
				vim.api.nvim_set_option_value("winhighlight", winhighlight, { win = preview_winid })
				vim.api.nvim_set_option_value("number", false, { win = preview_winid })
				vim.api.nvim_set_option_value("relativenumber", false, { win = preview_winid })
				vim.api.nvim_set_option_value("cursorline", false, { win = preview_winid })
				vim.api.nvim_set_option_value("signcolumn", "yes", { win = preview_winid })
			end
			if not vim.api.nvim_win_is_valid(list_winid) then
				list_winid = vim.api.nvim_open_win(list_bufnr, false, {
					relative = "editor",
					width = screen_width,
					height = screen_height - 5 - math.floor((screen_height - 5) / 2) - 2,
					col = start_col,
					row = start_row + 3,
					focusable = false,
					border = "rounded",
					-- title = 'Result',
					-- title_pos = 'center',
					-- noautocmd = true,
				})
			end
		else
			if not vim.api.nvim_win_is_valid(list_winid) then
				list_winid = vim.api.nvim_open_win(list_bufnr, false, {

					relative = "editor",
					width = screen_width,
					height = screen_height - 5,
					col = start_col,
					row = start_row + 3,
					focusable = false,
					border = "rounded",
					-- title = 'Result',
					-- title_pos = 'center',
					-- noautocmd = true,
				})
			end
		end
		if not vim.api.nvim_win_is_valid(promot_winid) then
			promot_winid = vim.api.nvim_open_win(promot_bufnr, true, {
				relative = "editor",
				width = screen_width,
				height = 1,
				col = start_col,
				row = start_row,
				focusable = true,
				border = "rounded",
				-- noautocmd = true,
			})
		end
	end
	vim.api.nvim_set_option_value(
		"winhighlight",
		winhighlight,
		{ win = list_winid }
	)
	vim.api.nvim_set_option_value(
		"winhighlight",
		winhighlight,
		{ win = promot_winid }
	)
	vim.api.nvim_set_option_value("buftype", "nowrite", { buf = promot_bufnr })
	vim.api.nvim_set_option_value("buftype", "nowrite", { buf = list_bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = promot_bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = list_bufnr })
	vim.api.nvim_set_option_value("number", false, { win = list_winid })
	vim.api.nvim_set_option_value("relativenumber", false, { win = list_winid })
	vim.api.nvim_set_option_value("cursorline", true, { win = list_winid })
	vim.api.nvim_set_option_value("signcolumn", "yes", { win = list_winid })
	vim.api.nvim_set_option_value("number", false, { win = promot_winid })
	vim.api.nvim_set_option_value("relativenumber", false, { win = promot_winid })
	vim.api.nvim_set_option_value("cursorline", false, { win = promot_winid })
	vim.api.nvim_set_option_value("signcolumn", "yes", { win = promot_winid })
	vim.api.nvim_buf_set_extmark(promot_bufnr, extns, 0, 0, {
		sign_text = config.prompt.icon,
		sign_hl_group = config.prompt.icon_hl,
	})
	local augroup = vim.api.nvim_create_augroup("picker.nvim", {
		clear = true,
	})

	vim.api.nvim_create_autocmd({ "TextChangedI" }, {
		group = augroup,
		buffer = promot_bufnr,
		callback = function(ev)
			local input = vim.api.nvim_buf_get_lines(promot_bufnr, 0, 1, false)[1]
			vim.api.nvim_win_set_cursor(list_winid, { 1, 1 })
			local results = source.get()
			filter_rst = filter.filter(input, results)

			vim.api.nvim_buf_set_lines(
				list_bufnr,
				0,
				-1,
				false,
				vim.tbl_map(function(t)
					return results[t[1]].str
				end, filter_rst)
			)
			if #filter_rst > 0 then
				highlight_list_windows()
				if config.window.enable_preview and source.preview then
					source.preview(filter_rst[1][4], preview_winid, preview_bufnr)
				end
			end
			update_result_count()
		end,
	})
	-- disable this key binding in promot buffer
	for _, k in ipairs({ "<C-c>" }) do
		vim.keymap.set("i", k, "<Nop>", { buffer = promot_bufnr })
	end
	vim.keymap.set("i", config.mappings.close, function()
		vim.cmd("noautocmd stopinsert")
		vim.api.nvim_win_close(promot_winid, true)
		vim.api.nvim_win_close(list_winid, true)
		if vim.api.nvim_win_is_valid(preview_winid) then
			vim.api.nvim_win_close(preview_winid, true)
		end
	end, { buffer = promot_bufnr })
	if type(source.actions) == "function" then
		for key, action in pairs(source.actions()) do
			vim.keymap.set("i", key, function()
				vim.cmd("noautocmd stopinsert")
				local cursor = vim.api.nvim_win_get_cursor(list_winid)
				vim.api.nvim_win_close(promot_winid, true)
				vim.api.nvim_win_close(list_winid, true)
				if vim.api.nvim_win_is_valid(preview_winid) then
					vim.api.nvim_win_close(preview_winid, true)
				end
				action(filter_rst[cursor[1]][4])
			end, { buffer = promot_bufnr })
		end
	else
		vim.keymap.set("i", config.mappings.open_item, function()
			vim.cmd("noautocmd stopinsert")
			local cursor = vim.api.nvim_win_get_cursor(list_winid)
			vim.api.nvim_win_close(promot_winid, true)
			vim.api.nvim_win_close(list_winid, true)
			if vim.api.nvim_win_is_valid(preview_winid) then
				vim.api.nvim_win_close(preview_winid, true)
			end
			source.default_action(filter_rst[cursor[1]][4])
		end, { buffer = promot_bufnr })
	end
	vim.keymap.set("i", config.mappings.next_item, function()
		local cursor = vim.api.nvim_win_get_cursor(list_winid)
		if cursor[1] < vim.api.nvim_buf_line_count(list_bufnr) then
			cursor[1] = cursor[1] + 1
		else
			cursor[1] = 1
		end
		vim.api.nvim_win_set_cursor(list_winid, cursor)
		highlight_list_windows()
		if config.window.enable_preview and source.preview and #filter_rst > 0 then
			source.preview(filter_rst[cursor[1]][4], preview_winid, preview_bufnr)
		end
		update_result_count()
	end, { buffer = promot_bufnr })
	vim.keymap.set("i", config.mappings.previous_item, function()
		local cursor = vim.api.nvim_win_get_cursor(list_winid)
		if cursor[1] > 1 then
			cursor[1] = cursor[1] - 1
		else
			cursor[1] = vim.api.nvim_buf_line_count(list_bufnr)
		end
		vim.api.nvim_win_set_cursor(list_winid, cursor)
		highlight_list_windows()
		if config.window.enable_preview and source.preview and #filter_rst > 0 then
			source.preview(filter_rst[cursor[1]][4], preview_winid, preview_bufnr)
		end
		update_result_count()
	end, { buffer = promot_bufnr })
	vim.keymap.set("i", config.mappings.toggle_preview, function()
		config.window.enable_preview = not config.window.enable_preview
		if not config.window.enable_preview then
			if vim.api.nvim_win_is_valid(preview_winid) then
				vim.api.nvim_win_close(preview_winid, true)
			end
			if config.prompt.position == "bottom" then
				vim.api.nvim_win_set_config(list_winid, {

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
			else
				vim.api.nvim_win_set_config(list_winid, {

					relative = "editor",
					width = screen_width,
					height = screen_height - 5,
					col = start_col,
					row = start_row + 3,
					focusable = false,
					border = "rounded",
					-- title = 'Result',
					-- title_pos = 'center',
					-- noautocmd = true,
				})
			end
		elseif config.window.enable_preview and source.preview_win then
			if config.prompt.position == "bottom" then
				if not vim.api.nvim_buf_is_valid(preview_bufnr) then
					preview_bufnr = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = preview_bufnr })
				end
				-- 初始化时，清空 preview 窗口内容
				vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, {})
				if not vim.api.nvim_win_is_valid(preview_winid) then
					preview_winid = vim.api.nvim_open_win(preview_bufnr, false, {
						relative = "editor",
						width = screen_width,
						height = math.floor((screen_height - 5) / 2),
						col = start_col,
						row = start_row,
						focusable = false,
						border = "rounded",
					})
					vim.api.nvim_set_option_value(
						"winhighlight",
						winhighlight,
						{ win = preview_winid }
					)
					vim.api.nvim_set_option_value("number", false, { win = preview_winid })
					vim.api.nvim_set_option_value("relativenumber", false, { win = preview_winid })
					vim.api.nvim_set_option_value("cursorline", false, { win = preview_winid })
					vim.api.nvim_set_option_value("signcolumn", "yes", { win = preview_winid })
				end
				local cursor = vim.api.nvim_win_get_cursor(list_winid)
				source.preview(filter_rst[cursor[1]][4], preview_winid, preview_bufnr)
				vim.api.nvim_win_set_config(list_winid, {

					relative = "editor",
					width = screen_width,
					height = screen_height - 5 - math.floor((screen_height - 5) / 2) - 2,
					col = start_col,
					row = start_row + math.floor((screen_height - 5) / 2) + 2,
					focusable = false,
					border = "rounded",
					-- title = 'Result',
					-- title_pos = 'center',
					-- noautocmd = true,
				})
			else
				if not vim.api.nvim_buf_is_valid(preview_bufnr) then
					preview_bufnr = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = preview_bufnr })
				end
				-- 初始化时，清空 preview 窗口内容
				vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, {})
				if not vim.api.nvim_win_is_valid(preview_winid) then
					preview_winid = vim.api.nvim_open_win(preview_bufnr, false, {
						relative = "editor",
						width = screen_width,
						height = math.floor((screen_height - 5) / 2),
						col = start_col,
						row = start_row + math.floor((screen_height - 5) / 2) + 4,
						focusable = false,
						border = "rounded",
					})
					vim.api.nvim_set_option_value(
						"winhighlight",
						winhighlight,
						{ win = preview_winid }
					)
					vim.api.nvim_set_option_value("number", false, { win = preview_winid })
					vim.api.nvim_set_option_value("relativenumber", false, { win = preview_winid })
					vim.api.nvim_set_option_value("cursorline", false, { win = preview_winid })
					vim.api.nvim_set_option_value("signcolumn", "yes", { win = preview_winid })
				end
				local cursor = vim.api.nvim_win_get_cursor(list_winid)
				source.preview(filter_rst[cursor[1]][4], preview_winid, preview_bufnr)
				vim.api.nvim_win_set_config(list_winid, {

					relative = "editor",
					width = screen_width,
					height = screen_height - 5 - math.floor((screen_height - 5) / 2) - 2,
					col = start_col,
					row = start_row + 3,
					focusable = false,
					border = "rounded",
					-- title = 'Result',
					-- title_pos = 'center',
					-- noautocmd = true,
				})
			end
		end
		highlight_list_windows()
	end, { buffer = promot_bufnr })
	if ok then
		cmp.setup.buffer({
			completion = {
				autocomplete = false,
			},
		})
	end
	if opt.input then
		vim.api.nvim_buf_set_lines(promot_bufnr, 0, -1, false, { opt.input })
	end
	vim.api.nvim_input("A")
	vim.cmd("doautocmd TextChangedI")
end

return M
