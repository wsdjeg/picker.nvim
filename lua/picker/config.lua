local M = {}

local default = {}

function M.setup(opt)
    default = vim.tbl_deep_extend('force', default, opt)
end

return M
