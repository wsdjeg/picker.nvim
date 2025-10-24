local M = {}

local util = require("picker.util")

function M.open(argv, opt)
	util.info("argv is:" .. vim.inspect(argv))
	if #argv == 0 then
		require("picker.windows").open(require("picker.sources"))
		return
	end
	local ok, source = pcall(require, "picker.sources." .. argv[1])
	if not ok then
		util.notify(string.format('can not found source "%s" for picker.nvim', argv[1]))
	else
		if not source.enabled then
            source.name = source.name or argv[1]
			require("picker.windows").open(source, opt)
        elseif source.enabled and source.enabled() then
            source.name = source.name or argv[1]
			require("picker.windows").open(source, opt)
		end
	end
end

function M.setup(opt)
	require("picker.config").setup(opt)
end

return M
