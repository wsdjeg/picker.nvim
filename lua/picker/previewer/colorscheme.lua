local M = {}

local preview_timer_id = -1

local timerout = 500

local colorscheme

local function preview_timer(t)
	if colorscheme and #colorscheme > 0 then
		vim.cmd("colorscheme " .. colorscheme)
	end
end
function M.preview(item, _, _)
	vim.fn.timer_stop(preview_timer_id)
	colorscheme = item
	preview_timer_id = vim.fn.timer_start(timerout, preview_timer, { ["repeat"] = 1 })
end

return M
