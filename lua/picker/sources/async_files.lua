local M = {}

local previewer = require("picker.previewer.file")
local util = require("picker.util")

local ok, job = pcall(require, "job")

function M.enabled()
	if not ok then
		util.notify("async_files source require wsdjeg/job.nvim")
	end
	return ok
end

---@type PickerItem[]
local items = {}

local cmd = { "rg", "--files" }

local jobid = -1

local function callback()
	if 	M.state
		and M.state.previous_input then
        require('picker.filter').filter(M.state.previous_input, source)
    end
end

local function on_stdout(id, data)
	if id == jobid then
		vim.tbl_map(function(t)
			table.insert(items, {
				value = t,
				str = t,
			})
		end, data)
        callback()
	end
end
local function on_stderr(id, data) end
local function on_exit(id, data, singin)
	if id == jobid then
		jobid = -1
        callback()
	end
end

local function async_run()
	if jobid > 0 then
		job.stop(jobid)
	end
	jobid = job.start(cmd, {
		on_stdout = on_stdout,
		on_stderr = on_stderr,
		on_exit = on_exit,
	})
	return items
end
function M.set(opt)
	opt = opt or {}

	cmd = opt.cmd or cmd
	items = {}

	async_run()
end

function M.get()
	return items
end

---@field item PickerItem
function M.default_action(item)
	vim.cmd("edit " .. item.value)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(item.value, win, buf)
end

return M
