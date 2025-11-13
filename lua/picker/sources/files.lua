local M = {}

local previewer = require('picker.previewer.file')

local list_files_cmd = { 'rg', '--files' }

local get_icon

function M.set(opt)
    opt = opt or {}

    if opt.cmd then
        list_files_cmd = opt.cmd
    end
    local ok, devicon = pcall(require, 'nvim-web-devicons')
    if not ok then
        devicon = nil
    else
        get_icon = devicon.get_icon
    end
end

function M.get()
    return vim.tbl_map(
        function(t)
            if get_icon then
                local icon, hl = get_icon(t)
                return {
                    value = vim.fn.fnamemodify(t, ':p'),
                    str = (icon or '󰈔') .. ' ' .. t,
                    highlight = {
                        { 0, 2, hl },
                    },
                }
            end
            return {
                value = vim.fn.fnamemodify(t, ':p'),
                str = t,
            }
        end,
        vim.split(
            vim.system(list_files_cmd, { text = true }):wait().stdout,
            '\n',
            { trimempty = true }
        )
    )
end

function M.actions()
    return {
        ['<C-v>'] = function(entry)
            vim.cmd('vsplit ' .. entry.value)
        end,
        ['<C-t>'] = function(entry)
            vim.cmd('tabedit ' .. entry.value)
        end,
    }
end

---@field item PickerItem
function M.default_action(item)
    vim.cmd('edit ' .. item.value)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
    previewer.preview(item.value, win, buf)
end

return M
