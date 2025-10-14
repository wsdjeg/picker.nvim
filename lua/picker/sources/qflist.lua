local M = {}

local previewer = require('picker.previewer.file')

function M.get()
    local p = vim.fn.getqflist()

    return vim.tbl_map(function(t)
        t.file = vim.api.nvim_buf_get_name(t.bufnr)
        return {
            value = t,
            str = string.format('%s:%d:%s', t.file, t.lnum, t.text),
            highlight = {
                {
                    0,
                    #t.file + #tostring(t.lnum) + 2,
                    'Comment',
                },
            },
        }
    end, p)
end

function M.default_action(entry)
    vim.cmd('edit ' .. entry.value.file)
    vim.cmd(tostring(entry.value.lnum))
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
    previewer.preview(item.value.file, win, buf, item.value.lnum)
end

return M

