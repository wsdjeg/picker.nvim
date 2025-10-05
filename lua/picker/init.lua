local M = {}

local util = require("picker.util")

function M.open(argv)
	util.info("argv is:" .. vim.inspect(argv))
	local source = require("picker.sources." .. argv[1])
	require("picker.windows").open(source)
end

function M.setup(opt)
	require("picker.config").setup(opt)
end

return M
