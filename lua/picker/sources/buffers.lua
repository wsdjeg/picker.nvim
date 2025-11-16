local M = {}

local previewer = require('picker.previewer.file')

local get_icon

function M.set()
    local ok, devicon = pcall(require, 'nvim-web-devicons')
    if ok then
        get_icon = devicon.get_icon
    end
end

function M.get()
    local bufnrs = vim.tbl_filter(function(bufnr)
        if 1 ~= vim.fn.buflisted(bufnr) then
            return false
        end
        return true
    end, vim.api.nvim_list_bufs())

    return vim.tbl_map(function(t)
        if get_icon then
            local bufname = vim.api.nvim_buf_get_name(t)
            local icon, hl = get_icon(vim.fn.fnamemodify(bufname, ':t'))
            return {
                str = (icon or '󰈔') .. ' ' .. vim.fn.fnamemodify(bufname, ':.'),
                value = t,
                highlight = {
                    { 0, 2, hl },
                },
            }
        else
            return {
                value = t,
                str = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(t), ':.'),
            }
        end
    end, bufnrs)
end

function M.default_action(s)
    vim.api.nvim_set_current_buf(s.value)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
    previewer.preview(item.str, win, buf)
end

return M
