local M = {}

local util = require('picker.util')
local previewer = require('picker.previewer.buffer')
local items = {}

function M.get()
    return items
end

---@param entry PickerItem
function M.default_action(entry)
    vim.api.nvim_win_set_cursor(
        0,
        { entry.value.range.start.line + 1, entry.value.range.start.character }
    )
end

function M.set(opt)
    local bufnr = opt.buf
    previewer.buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
    previewer.filetype = ft
    local win = vim.api.nvim_get_current_win()
    local client = vim.lsp.get_clients({ bufnr = bufnr })[1]
    if not client then
        return
    end
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

    items = {}

    client:request(util.feature_map.document_symbols, params, function(err, result, ctx, ...)
        if not result or err then
            return
        end

        -- {
        --   detail = "",
        --   kind = 13,
        --   name = "bufnr",
        --   range = {
        --     ["end"] = {
        --       character = 44,
        --       line = 0
        --     },
        --     start = {
        --       character = 6,
        --       line = 0
        --     }
        --   },
        --   selectionRange = {
        --     ["end"] = {
        --       character = 11,
        --       line = 0
        --     },
        --     start = {
        --       character = 6,
        --       line = 0
        --     }
        --   }
        -- }

        for _, symbol in ipairs(result) do
            table.insert(items, {
                value = symbol,
                str = string.format('%s %s', util.symbol_kind(symbol.kind), symbol.name),
                highlight = {
                    { 0, #util.symbol_kind(symbol.kind) + 1, 'Comment' },
                },
            })
        end
        require('picker.windows').handle_prompt_changed()
    end, bufnr)
end

M.preview_win = true

function M.preview(item, win, buf)
    previewer.preview(item.value.range.start.line + 1, win, buf)
end

return M
