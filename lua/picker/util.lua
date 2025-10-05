local M = {}

local nt
local log

function M.notify(msg)
	if not nt then
		pcall(function()
			nt = require("notify")
		end)
	end
	if not nt then
		return
	end
	nt.notify(msg)
end

function M.info(msg)
	if not log then
		pcall(function()
			log = require("logger").derive("picker")
		end)
	end
	if not log then
		return
	end
	log.info(msg)
end

return M
