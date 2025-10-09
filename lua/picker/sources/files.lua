local M = {}

function M.get()

    return vim.split(vim.system({'rg', '--files'}, {text = true}):wait().stdout, "\n", {trimempty = true})
    
end

function M.default_action(s)
    vim.cmd('edit ' .. s)
end

M.preview_win = true

return M
