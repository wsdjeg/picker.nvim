local M = {}

---@type PickerLayout
local layout = {
    preview_buf = -1,
    preview_win = -1,
    list_buf = -1,
    list_win = -1,
    prompt_buf = -1,
    prompt_win = -1,
}

local winhighlight = 'NormalFloat:Normal,FloatBorder:WinSeparator,Search:None,CurSearch:None'
local extns = vim.api.nvim_create_namespace('picker.nvim')

---@return PickerLayout
function M.render_windows(source, config)
    -- 窗口位置
    -- 宽度： columns 的 80%
    local screen_width = math.floor(vim.o.columns * config.window.width)
    -- 起始位位置： lines * 10%, columns * 10%
    local start_col = math.floor(vim.o.columns * config.window.col)
    local start_row = math.floor(vim.o.lines * config.window.row)
    -- 整体高度：lines 的 80%
    local screen_height = math.floor(vim.o.lines * config.window.height)
    if not vim.api.nvim_buf_is_valid(layout.list_buf) then
        layout.list_buf = vim.api.nvim_create_buf(false, false)
    end
    if not vim.api.nvim_buf_is_valid(layout.prompt_buf) then
        -- 初始化 prompt buffer
        layout.prompt_buf = vim.api.nvim_create_buf(false, false)
        vim.api.nvim_set_option_value('filetype', 'picker-prompt', { buf = layout.prompt_buf })
    end
    if config.prompt.position == 'bottom' then
        -- 启用预览，并且source需要预览窗口，则初始化预览窗口
        if config.window.enable_preview and source.preview_win then
            if not vim.api.nvim_buf_is_valid(layout.preview_buf) then
                layout.preview_buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = layout.preview_buf })
            end
            -- 初始化时，清空 preview 窗口内容
            vim.api.nvim_buf_set_lines(layout.preview_buf, 0, -1, false, {})
            if not vim.api.nvim_win_is_valid(layout.preview_win) then
                layout.preview_win = vim.api.nvim_open_win(layout.preview_buf, false, {
                    relative = 'editor',
                    width = screen_width,
                    height = math.floor((screen_height - 5) / 2),
                    col = start_col,
                    row = start_row,
                    focusable = false,
                    border = 'rounded',
                })
                vim.api.nvim_set_option_value(
                    'winhighlight',
                    winhighlight,
                    { win = layout.preview_win }
                )
                vim.api.nvim_set_option_value('number', false, { win = layout.preview_win })
                vim.api.nvim_set_option_value('relativenumber', false, { win = layout.preview_win })
                vim.api.nvim_set_option_value('cursorline', false, { win = layout.preview_win })
                vim.api.nvim_set_option_value('signcolumn', 'yes', { win = layout.preview_win })
            else
                vim.api.nvim_win_set_config(layout.preview_win, {
                    relative = 'editor',
                    width = screen_width,
                    height = math.floor((screen_height - 5) / 2),
                    col = start_col,
                    row = start_row,
                    focusable = false,
                    border = 'rounded',
                })
            end
            if not vim.api.nvim_win_is_valid(layout.list_win) then
                layout.list_win = vim.api.nvim_open_win(layout.list_buf, false, {
                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5 - math.floor((screen_height - 5) / 2) - 2,
                    col = start_col,
                    row = start_row + math.floor((screen_height - 5) / 2) + 2,
                    focusable = false,
                    border = 'rounded',
                    -- title = 'Result',
                    -- title_pos = 'center',
                    -- noautocmd = true,
                })
            else
                vim.api.nvim_win_set_config(layout.list_win, {
                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5 - math.floor((screen_height - 5) / 2) - 2,
                    col = start_col,
                    row = start_row + math.floor((screen_height - 5) / 2) + 2,
                    focusable = false,
                    border = 'rounded',
                    -- title = 'Result',
                    -- title_pos = 'center',
                    -- noautocmd = true,
                })
            end
        else
            if vim.api.nvim_win_is_valid(layout.preview_win) then
                vim.api.nvim_win_close(layout.preview_win, true)
            end
            if not vim.api.nvim_win_is_valid(layout.list_win) then
                layout.list_win = vim.api.nvim_open_win(layout.list_buf, false, {

                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5,
                    col = start_col,
                    row = start_row,
                    focusable = false,
                    border = 'rounded',
                    -- title = 'Result',
                    -- title_pos = 'center',
                    -- noautocmd = true,
                })
            else
                vim.api.nvim_win_set_config(layout.list_win, {
                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5,
                    col = start_col,
                    row = start_row,
                    focusable = false,
                    border = 'rounded',
                    -- title = 'Result',
                    -- title_pos = 'center',
                    -- noautocmd = true,
                })
            end
        end
        if not vim.api.nvim_win_is_valid(layout.prompt_win) then
            layout.prompt_win = vim.api.nvim_open_win(layout.prompt_buf, true, {
                relative = 'editor',
                width = screen_width,
                height = 1,
                col = start_col,
                row = start_row + screen_height - 3,
                focusable = true,
                border = 'rounded',
                title = config.prompt.title and string.format(' %s ', source.name),
                title_pos = 'center',
                -- noautocmd = true,
            })
        end
    else
        if config.window.enable_preview and source.preview_win then
            if not vim.api.nvim_buf_is_valid(layout.preview_buf) then
                layout.preview_buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = layout.preview_buf })
            end
            -- 初始化时，清空 preview 窗口内容
            vim.api.nvim_buf_set_lines(layout.preview_buf, 0, -1, false, {})
            if not vim.api.nvim_win_is_valid(layout.preview_win) then
                layout.preview_win = vim.api.nvim_open_win(layout.preview_buf, false, {
                    relative = 'editor',
                    width = screen_width,
                    height = math.floor((screen_height - 5) / 2),
                    col = start_col,
                    row = start_row + math.floor((screen_height - 5) / 2) + 4,
                    focusable = false,
                    border = 'rounded',
                })
                vim.api.nvim_set_option_value(
                    'winhighlight',
                    winhighlight,
                    { win = layout.preview_win }
                )
                vim.api.nvim_set_option_value('number', false, { win = layout.preview_win })
                vim.api.nvim_set_option_value('relativenumber', false, { win = layout.preview_win })
                vim.api.nvim_set_option_value('cursorline', false, { win = layout.preview_win })
                vim.api.nvim_set_option_value('signcolumn', 'yes', { win = layout.preview_win })
            else
                vim.api.nvim_win_set_config(layout.preview_win, {
                    relative = 'editor',
                    width = screen_width,
                    height = math.floor((screen_height - 5) / 2),
                    col = start_col,
                    row = start_row + math.floor((screen_height - 5) / 2) + 4,
                    focusable = false,
                    border = 'rounded',
                })
            end
            if not vim.api.nvim_win_is_valid(layout.list_win) then
                layout.list_win = vim.api.nvim_open_win(layout.list_buf, false, {
                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5 - math.floor((screen_height - 5) / 2 + 0.5) - 1,
                    col = start_col,
                    row = start_row + 3,
                    focusable = false,
                    border = 'rounded',
                })
            else
                vim.api.nvim_win_set_config(layout.list_win, {
                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5 - math.floor((screen_height - 5) / 2 + 0.5) - 1,
                    col = start_col,
                    row = start_row + 3,
                    focusable = false,
                    border = 'rounded',
                })
            end
        else
            if vim.api.nvim_win_is_valid(layout.preview_win) then
                vim.api.nvim_win_close(layout.preview_win, true)
            end
            if not vim.api.nvim_win_is_valid(layout.list_win) then
                layout.list_win = vim.api.nvim_open_win(layout.list_buf, false, {

                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5,
                    col = start_col,
                    row = start_row + 3,
                    focusable = false,
                    border = 'rounded',
                })
            else
                vim.api.nvim_win_set_config(layout.list_win, {

                    relative = 'editor',
                    width = screen_width,
                    height = screen_height - 5,
                    col = start_col,
                    row = start_row + 3,
                    focusable = false,
                    border = 'rounded',
                })
            end
        end
        if not vim.api.nvim_win_is_valid(layout.prompt_win) then
            layout.prompt_win = vim.api.nvim_open_win(layout.prompt_buf, true, {
                relative = 'editor',
                width = screen_width,
                height = 1,
                col = start_col,
                row = start_row,
                focusable = true,
                border = 'rounded',
                title = config.prompt.title and string.format(' %s ', source.name),
                title_pos = 'center',
                -- noautocmd = true,
            })
        end
    end
    vim.api.nvim_set_option_value('winhighlight', winhighlight, { win = layout.list_win })
    vim.api.nvim_set_option_value('winhighlight', winhighlight, { win = layout.prompt_win })
    vim.api.nvim_set_option_value('buftype', 'nowrite', { buf = layout.prompt_buf })
    vim.api.nvim_set_option_value('buftype', 'nowrite', { buf = layout.list_buf })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = layout.prompt_buf })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = layout.list_buf })
    vim.api.nvim_set_option_value('number', false, { win = layout.list_win })
    vim.api.nvim_set_option_value('relativenumber', false, { win = layout.list_win })
    vim.api.nvim_set_option_value('cursorline', true, { win = layout.list_win })
    vim.api.nvim_set_option_value('signcolumn', 'yes', { win = layout.list_win })
    vim.api.nvim_set_option_value('number', false, { win = layout.prompt_win })
    vim.api.nvim_set_option_value('relativenumber', false, { win = layout.prompt_win })
    vim.api.nvim_set_option_value('cursorline', false, { win = layout.prompt_win })
    vim.api.nvim_set_option_value('signcolumn', 'yes', { win = layout.prompt_win })
    vim.api.nvim_set_option_value('scrolloff', 0, { win = layout.list_win })
    vim.api.nvim_buf_set_extmark(layout.prompt_buf, extns, 0, 0, {
        sign_text = config.prompt.icon,
        sign_hl_group = config.prompt.icon_hl,
    })
    return layout
end

return M
