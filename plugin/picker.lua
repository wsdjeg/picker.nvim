vim.api.nvim_create_user_command("Picker", function(opt)
	require("picker").open(opt.fargs, {
		buf = vim.api.nvim_get_current_buf(),
	})
end, {
	nargs = "*",
	complete = function(ArgLead, CmdLine, CursorPos)
		local sources = vim.api.nvim_get_runtime_file("lua/picker/sources/*.lua", true)
		local rst = vim.tbl_map(function(t)
			return vim.fn.fnamemodify(t, ":t:r")
		end, sources)
		return vim.tbl_filter(function(t)
			return vim.startswith(t, ArgLead)
		end, rst)
	end,
})
