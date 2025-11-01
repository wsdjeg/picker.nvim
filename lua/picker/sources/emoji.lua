local M = {}

local emojis = {}

-- emoji json file: https://github.com/muan/unicode-emoji-json

local previewer = require('picker.previewer.buffer')
local url =
    'https://raw.githubusercontent.com/muan/unicode-emoji-json/refs/heads/main/data-by-emoji.json'
local file = vim.fn.stdpath('cache') .. '/picker.nvim/data-by-emoji.json'

function M.set()
    if vim.fn.filereadable(file) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
        vim.system({ 'curl', '-fLo', file, '--create-dirs', url }, {}, function(obj)
            require('picker.windows').handle_prompt_changed()
        end)
    end
end

function M.get()
    if #emojis == 0 and vim.fn.filereadable(file) == 1 then
        local data = vim.json.decode(table.concat(vim.fn.readfile(file, ''), '\n'))
        for icon, info in pairs(data) do
            info.icon = icon
            table.insert(emojis, {
                value = info,
                str = string.format('%s %s', icon, info.name),
            })
        end
    end
    return emojis
end

function M.default_action(entry)
    vim.api.nvim_paste(entry.value.icon, false, -1)
end

M.preview_win = true

function M.preview(item, win, buf)
    previewer.buflines = vim.split(vim.inspect(item.value), '[\r]?\n')
    previewer.filetype = 'lua'
    previewer.preview(1, win, buf, true)
end
return M
