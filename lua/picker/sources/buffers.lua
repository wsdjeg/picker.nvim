local M = {}

function M.get()
	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then
			return false
		end
        return true
	end, vim.api.nvim_list_bufs())

	return vim.tbl_map(function(t)
		return vim.api.nvim_buf_get_name(t)
	end, bufnrs)
end

function M.default_action(s)
	vim.cmd("edit " .. s)
end

return M
