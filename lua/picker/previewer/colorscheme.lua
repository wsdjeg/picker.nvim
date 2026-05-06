---@class Picker.ColorschemePreviewer
local M = {}

local preview_timer_id = -1 ---@type integer

local timerout = 500 ---@type integer

local colorscheme ---@type string

local original_colorscheme = vim.g.colors_name or 'default' ---@type string

local function preview_timer()
  if colorscheme and colorscheme ~= '' then
    vim.cmd.colorscheme(colorscheme)
  end
end

---@param item string
---@param win? integer
---@param buf? integer
function M.preview(item, win, buf)
  vim.fn.timer_stop(preview_timer_id)
  colorscheme = item
  preview_timer_id =
    vim.fn.timer_start(timerout, preview_timer, { ['repeat'] = 1 })
end

--- Restore the original colorscheme
function M.restore()
  vim.fn.timer_stop(preview_timer_id)
  if original_colorscheme then
    vim.cmd.colorscheme(original_colorscheme)
  end
end

return M
