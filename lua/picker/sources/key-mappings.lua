local M = {}

M.get = function()
    local items = {}

    local maps = vim.api.nvim_get_keymap('n')

    for _, map in ipairs(maps) do
        local item = { value = map }
        item.str = vim.fn.keytrans(vim.api.nvim_replace_termcodes(map.lhs, true, true, true))

        item.str = item.str
            .. string.rep(' ', 50 - #item.str)
            .. (map.desc or map.rhs or tostring(map.callback))
        table.insert(items, item)
    end

    return items
end

M.default_action = function(entry)
    vim.api.nvim_input(entry.value.lhs)
end

M.preview_win = true
local previewer = require('picker.previewer.buffer')

function M.preview(item, win, buf)
    previewer.buflines = vim.split(vim.inspect(item.value), '[\r]?\n')
    previewer.filetype = 'lua'
    previewer.preview(1, win, buf, true)
end
return M
