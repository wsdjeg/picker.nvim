---@class Picker.BufferPreviewer
local M = {}

local preview_timer_id = -1 ---@type integer

local timerout = 500 ---@type integer

local line_number = 1 ---@type integer
local previous_line = 1 ---@type integer
local preview_winid ---@type integer
local preview_bufnr ---@type integer
local update_context = false ---@type boolean

local function preview_timer()
  if
    preview_bufnr
    and vim.api.nvim_buf_is_valid(preview_bufnr)
    and (
      vim.api.nvim_buf_line_count(preview_bufnr) < #M.buflines
      or update_context
    )
  then
    vim.api.nvim_set_option_value('modifiable', true, { buf = preview_bufnr })
    vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, M.buflines)
    vim.api.nvim_set_option_value(
      'filetype',
      M.filetype,
      { buf = preview_bufnr }
    )
    if vim.api.nvim_win_is_valid(preview_winid) then
      vim.api.nvim_set_option_value(
        'cursorline',
        true,
        { win = preview_winid }
      )
    end
  end
  if
    line_number ~= previous_line and vim.api.nvim_win_is_valid(preview_winid)
  then
    vim.api.nvim_win_set_cursor(preview_winid, { line_number, 0 })
    vim.api.nvim_win_call(preview_winid, function()
      vim.cmd('noautocmd normal! zz')
    end)
  end
end

M.buflines = {} ---@type string[]
M.filetype = '' ---@type string|nil

---@param linenr integer
---@param win integer
---@param buf integer
---@param redraw? boolean force update context
function M.preview(linenr, win, buf, redraw)
  vim.fn.timer_stop(preview_timer_id)
  line_number = linenr
  preview_winid = win
  preview_bufnr = buf
  update_context = redraw
  preview_timer_id =
    vim.fn.timer_start(timerout, preview_timer, { ['repeat'] = 1 })
end

return M
