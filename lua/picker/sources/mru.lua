local M = {}

local previewer = require('picker.previewer.file')


M.preview_win = true

function M.preview(item, win, buf)
    previewer.preview(item, win, buf)
end

function M.get()

    return require('mru').get()
    
end

function M.default_action(s)
    vim.cmd('edit ' .. s)
end


return M

