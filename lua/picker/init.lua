local M = {}

local util = require("picker.util")

function M.open(argv, opt)
	util.info("argv is:" .. vim.inspect(argv))
	local ok, source = pcall(require, "picker.sources." .. argv[1])
	if not ok then
        util.notify(string.format('can not found source "%s" for picker.nvim', argv[1]))
	else
        if source.set then
            source.set(opt)
        end
		require("picker.windows").open(source)
	end
end

function M.setup(opt)
	require("picker.config").setup(opt)
end

return M
