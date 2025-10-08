local M = {}

function M.get()

    return require('mru').get()
    
end

function M.default_action(s)
    vim.cmd('edit ' .. s)
end


return M

