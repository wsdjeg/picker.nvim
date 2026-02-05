local M = {}

local filter = require('picker.filter')
local util = require('picker.util')

local source -- global source

---@type PickerLayout
local layout -- global layout

local extns = vim.api.nvim_create_namespace('picker.nvim')

local config

local prompt_count_id

local insert_timer_id = -1

local current_icon_extmark

local function update_result_count()
  local count = vim.api.nvim_buf_line_count(layout.list_buf)
  local line = vim.api.nvim_win_get_cursor(layout.list_win)[1]
  prompt_count_id =
    vim.api.nvim_buf_set_extmark(layout.prompt_buf, extns, 0, 0, {
      id = prompt_count_id,
      virt_text = { { string.format('%d/%d', line, count), 'Comment' } },
      virt_text_pos = 'right_align',
    })
  current_icon_extmark =
    vim.api.nvim_buf_set_extmark(layout.list_buf, extns, line - 1, 0, {
      id = current_icon_extmark,
      sign_text = config.window.current_icon,
      sign_hl_group = config.window.current_icon_hl,
    })
end

local extmars = {}
local ns = vim.api.nvim_create_namespace('picker-matched-chars')

local function clear_highlight()
  if #extmars > 0 then
    for _, id in ipairs(extmars) do
      vim.api.nvim_buf_del_extmark(layout.list_buf, ns, id)
    end
    extmars = {}
  end
end

local function highlight_list_windows()
  clear_highlight()
  local info = vim.fn.getwininfo(layout.list_win)[1]
  local from = info.topline
  local to = info.botline
  if source.filter_items and #source.filter_items > 0 then
    for x = from, to do
      for y = 1, #source.filter_items[x][2] do
        local col = source.filter_items[x][2][y]
        local id =
          vim.api.nvim_buf_set_extmark(layout.list_buf, ns, x - 1, col - 1, {
            end_col = col,
            hl_group = config.highlight.matched,
          })
        table.insert(extmars, id)
      end
      if config.window.show_score then
        local id =
          vim.api.nvim_buf_set_extmark(layout.list_buf, ns, x - 1, 0, {
            virt_text = {
              {
                tostring(source.filter_items[x][3]),
                config.highlight.score,
              },
            },
            virt_text_pos = 'eol_right_align',
          })
        table.insert(extmars, id)
      end
      if source.filter_items[x][4].highlight then
        for y = 1, #source.filter_items[x][4].highlight do
          local col_a, col_b, hl =
            unpack(source.filter_items[x][4].highlight[y])
          local id =
            vim.api.nvim_buf_set_extmark(layout.list_buf, ns, x - 1, col_a, {
              end_col = col_b,
              hl_group = hl,
            })
          table.insert(extmars, id)
        end
      end
    end
  end
end

--- @param s PickerSource
--- @param opt? table
function M.open(s, opt)
  source = s
  opt = opt or {}
  config = require('picker.config').get()
  if source.set then
    source.set(opt)
  end
  source.state = {}
  source.state.items = source.get()
  source.filter_items = {}

  local ok, _ = pcall(function()
    layout = require('picker.layout.' .. config.window.layout).render_windows(
      source,
      config
    )
  end)

  if not ok then
    util.notify(
      string.format(
        'can not found layout "%s" for picker.nvim',
        config.window.layout
      )
    )
    return
  end

  local augroup = vim.api.nvim_create_augroup('picker.nvim', {
    clear = true,
  })

  vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
    group = augroup,
    buffer = layout.prompt_buf,
    callback = M.handle_prompt_changed,
  })
  -- disable this key binding in promot buffer
  for _, k in ipairs({
    '<C-c>',
    '<F1>',
    '<F2>',
    '<F3>',
    '<F4>',
    '<F5>',
    '<F6>',
    '<F7>',
    '<F8>',
    '<F9>',
    '<F10>',
    '<F11>',
    '<F12>',
    '<C-j>', -- disable ctrl-j by default
  }) do
    vim.keymap.set('i', k, '<Nop>', { buffer = layout.prompt_buf })
  end
  vim.keymap.set('i', config.mappings.close, function()
    vim.fn.timer_stop(insert_timer_id)
    vim.cmd('noautocmd stopinsert')
    vim.api.nvim_win_close(layout.prompt_win, true)
    vim.api.nvim_win_close(layout.list_win, true)
    if vim.api.nvim_win_is_valid(layout.preview_win) then
      vim.api.nvim_win_close(layout.preview_win, true)
    end
  end, { buffer = layout.prompt_buf })
  vim.keymap.set('i', config.mappings.open_item, function()
    vim.fn.timer_stop(insert_timer_id)
    vim.cmd('noautocmd stopinsert')
    local cursor = vim.api.nvim_win_get_cursor(layout.list_win)
    vim.api.nvim_win_close(layout.prompt_win, true)
    vim.api.nvim_win_close(layout.list_win, true)
    if vim.api.nvim_win_is_valid(layout.preview_win) then
      vim.api.nvim_win_close(layout.preview_win, true)
    end
    -- if there is no item under cursor
    if source.filter_items and #source.filter_items >= 1 then
      source.default_action(source.filter_items[cursor[1]][4])
    end
  end, { buffer = layout.prompt_buf })
  if type(source.actions) == 'function' then
    for key, action in pairs(source.actions()) do
      vim.keymap.set('i', key, function()
        vim.fn.timer_stop(insert_timer_id)
        vim.cmd('noautocmd stopinsert')
        local cursor = vim.api.nvim_win_get_cursor(layout.list_win)
        vim.api.nvim_win_close(layout.prompt_win, true)
        vim.api.nvim_win_close(layout.list_win, true)
        if vim.api.nvim_win_is_valid(layout.preview_win) then
          vim.api.nvim_win_close(layout.preview_win, true)
        end
        -- make sure filter_items is not empty
        if source.filter_items and #source.filter_items >= 1 then
          action(source.filter_items[cursor[1]][4])
        end
      end, { buffer = layout.prompt_buf })
    end
  end
  if type(source.redraw_actions) == 'function' then
    for key, action in pairs(source.redraw_actions()) do
      vim.keymap.set('i', key, function()
        vim.fn.timer_stop(insert_timer_id)
        local cursor = vim.api.nvim_win_get_cursor(layout.list_win)
        -- make sure filter_items is not empty
        if source.filter_items and #source.filter_items >= 1 then
          action(source.filter_items[cursor[1]][4])
        else
          action()
        end
        source.state = {}
        source.state.items = source.get()
        source.filter_items = {}
        M.handle_prompt_changed()
      end, { buffer = layout.prompt_buf })
    end
  end
  vim.keymap.set('i', config.mappings.next_item, function()
    local cursor = vim.api.nvim_win_get_cursor(layout.list_win)
    if cursor[1] < vim.api.nvim_buf_line_count(layout.list_buf) then
      cursor[1] = cursor[1] + 1
    else
      cursor[1] = 1
    end
    vim.api.nvim_win_set_cursor(layout.list_win, cursor)
    highlight_list_windows()
    if
      config.window.enable_preview
      and source.preview
      and source.filter_items
      and #source.filter_items > 0
    then
      source.preview(
        source.filter_items[cursor[1]][4],
        layout.preview_win,
        layout.preview_buf
      )
    end
    update_result_count()
  end, { buffer = layout.prompt_buf })
  vim.keymap.set('i', config.mappings.previous_item, function()
    local cursor = vim.api.nvim_win_get_cursor(layout.list_win)
    if cursor[1] > 1 then
      cursor[1] = cursor[1] - 1
    else
      cursor[1] = vim.api.nvim_buf_line_count(layout.list_buf)
    end
    vim.api.nvim_win_set_cursor(layout.list_win, cursor)
    highlight_list_windows()
    if
      config.window.enable_preview
      and source.preview
      and source.filter_items
      and #source.filter_items > 0
    then
      source.preview(
        source.filter_items[cursor[1]][4],
        layout.preview_win,
        layout.preview_buf
      )
    end
    update_result_count()
  end, { buffer = layout.prompt_buf })
  vim.keymap.set('i', config.mappings.toggle_preview, function()
    config.window.enable_preview = not config.window.enable_preview
    require('picker.layout.' .. config.window.layout).render_windows(
      source,
      config
    )
    local cursor = vim.api.nvim_win_get_cursor(layout.list_win)
    if
      config.window.enable_preview
      and source.preview
      and source.filter_items
      and #source.filter_items > 0
    then
      source.preview(
        source.filter_items[cursor[1]][4],
        layout.preview_win,
        layout.preview_buf
      )
    end
    highlight_list_windows()
  end, { buffer = layout.prompt_buf })
  if opt.input then
    vim.api.nvim_buf_set_lines(layout.prompt_buf, 0, -1, false, { opt.input })
  end
  vim.api.nvim_input('A')
  M.handle_prompt_changed()
end

function M.handle_prompt_changed()
  vim.fn.timer_stop(insert_timer_id)
  insert_timer_id = vim.fn.timer_start(
    config.prompt.insert_timeout,
    function()
      if
        vim.api.nvim_buf_is_valid(layout.prompt_buf)
        and vim.api.nvim_buf_is_valid(layout.list_buf)
        and vim.api.nvim_win_is_valid(layout.prompt_win)
        and vim.api.nvim_win_is_valid(layout.list_win)
      then
        local input =
          vim.api.nvim_buf_get_lines(layout.prompt_buf, 0, 1, false)[1]
        vim.api.nvim_win_set_cursor(layout.list_win, { 1, 1 })
        filter.filter(input, source, config.filter.ignorecase)

        vim.api.nvim_buf_set_lines(
          layout.list_buf,
          0,
          -1,
          false,
          vim.tbl_map(function(t)
            return t[4].str
          end, source.filter_items)
        )
        if #source.filter_items > 0 then
          highlight_list_windows()
          if config.window.enable_preview and source.preview then
            source.preview(
              source.filter_items[1][4],
              layout.preview_win,
              layout.preview_buf
            )
          end
        else
          clear_highlight()
        end
        update_result_count()
      end
    end
  )
end

return M
