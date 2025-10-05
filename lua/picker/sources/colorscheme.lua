local M = {}

function M.get()
    return vim.fn.getcompletion('colorscheme ', 'cmdline')
end

function M.default_action(selected)
    vim.cmd('colorscheme ' .. selected)
end


return M
