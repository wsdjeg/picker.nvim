local M = {}

local previewer = require('picker.previewer.colorscheme')

function M.get()
    return vim.fn.getcompletion('colorscheme ', 'cmdline')
end

function M.default_action(selected)
    vim.cmd('colorscheme ' .. selected)
end

M.preview_win = false

function M.preview(item, win, buf)
    previewer.preview(item, win, buf)
end

return M
