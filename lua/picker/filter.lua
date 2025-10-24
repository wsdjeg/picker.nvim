local M = {}

local fzy = require("picker.matchers.fzy")
local config = require("picker.config").get()

local tid = -1

function M.filter(input, source, callback)
	if
		source.state
		and source.state.previous_input
		and source.state.previous_input == input
		and #input > 0
		and source.state.filter_count == #source.state.items
	then
		return
	end
	vim.fn.timer_stop(tid)
	local function async_task()
		local count = config.filter.loop_count
		if #input == 0 then
			source.filter_items = {}
			source.state.filter_count = 0
			for i, t in ipairs(source.state.items) do
				table.insert(source.filter_items, { i, {}, 0, t })
				source.state.filter_count = source.state.filter_count + 1
				if source.state.filter_count % count == 0 then
					coroutine.yield()
				end
			end
		else
			if
				source.state.previous_input
				and #source.state.previous_input > 0
				and fzy.has_match(source.state.previous_input, input)
			then
				source.state.saved_filter_items = source.filter_items
				source.filter_items = {}
				local x = 0
				for _, v in ipairs(source.state.saved_filter_items) do
					if fzy.has_match(input, v[4].str) then
						local p, s = fzy.positions(input, v[4].str)
						table.insert(source.filter_items, { _, p, s, v[4] })
					end
					x = x + 1
					if x % count == 0 then
						coroutine.yield()
					end
				end
				if source.state.filter_count < #source.state.items then
					for i = source.state.filter_count, #source.state.items do
						if fzy.has_match(input, source.state.items[i].str) then
							local p, s = fzy.positions(input, source.state.items[i].str)
							table.insert(source.filter_items, { _, p, s, source.state.items[i] })
						end
						source.state.filter_count = source.state.filter_count + 1
						if source.state.filter_count % count == 0 then
							coroutine.yield()
						end
					end
				end
			else
				source.filter_items = {}
				source.state.filter_count = 0
				for i = 1, #source.state.items do
					if fzy.has_match(input, source.state.items[i].str) then
						local p, s = fzy.positions(input, source.state.items[i].str)
						table.insert(source.filter_items, { _, p, s, source.state.items[i] })
					end
					source.state.filter_count = source.state.filter_count + 1
					if source.state.filter_count % count == 0 then
						coroutine.yield()
					end
				end
			end
		end
	end
	-- 创建一个协程
	local co = coroutine.create(async_task)

	local function loop(t)
		--- dead，suspended，running
		if coroutine.status(co) == "dead" then
			vim.fn.timer_stop(tid)
			return
		end
		coroutine.resume(co)
		table.sort(source.filter_items, function(a, b)
			return a[3] > b[3]
		end)
		source.state.callback()
	end

	tid = vim.fn.timer_start(config.filter.loop_timeout, loop, { ["repeat"] = -1 })
	source.state.previous_input = input
end

return M
