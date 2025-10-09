local M = {}

local preview_timer_id = -1

local timerout = 500

local preview_winid, preview_bufid, preview_file

local function preview_timer(t)
	-- if preview win does exists, return
	if not vim.api.nvim_win_is_valid(preview_winid) then
		return
	end
	local fd = vim.uv.fs_open(preview_file, "r", 438)
	local stat = vim.uv.fs_fstat(fd)
	local context = vim.split(vim.uv.fs_read(fd, stat.size, 0), "[\r]?\n", { trimempty = true })
	vim.uv.fs_close(fd)

	if #context == 0 then
		return
	end
	vim.api.nvim_buf_set_option(preview_bufid, "syntax", '')
	vim.api.nvim_buf_set_lines(preview_bufid, 0, -1, false, context)
	local ft = vim.filetype.match({ filename = preview_file })
	if ft then
		vim.api.nvim_buf_set_option(preview_bufid, "syntax", ft)
	else
		local ftdetect_autocmd = vim.api.nvim_get_autocmds({
			group = "filetypedetect",
			event = "BufRead",
			pattern = "*." .. vim.fn.fnamemodify(preview_file, ":e"),
		})
		-- logger.info(vim.inspect(ftdetect_autocmd))
		if ftdetect_autocmd[1] then
			if ftdetect_autocmd[1].command and vim.startswith(ftdetect_autocmd[1].command, "set filetype=") then
				ft = ftdetect_autocmd[1].command:gsub("set filetype=", "")
				vim.api.nvim_buf_set_option(preview_bufid, "syntax", ft)
			end
		end
	end
end
function M.preview(item, win, buf)
	vim.fn.timer_stop(preview_timer_id)
	preview_winid = win
	preview_bufid = buf
	preview_file = item
	if preview_file and vim.fn.filereadable(preview_file) == 1 then
		preview_timer_id = vim.fn.timer_start(timerout, preview_timer, { ["repeat"] = 1 })
	end
end

return M
