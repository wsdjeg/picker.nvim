---@class Picker.Sources.Buffers
local M = {}

local previewer = require('picker.previewer.file')

local get_icon ---@type nil|fun(name: string, ext?: string, opts?: any): string, string

function M.set()
  local ok, devicon = pcall(require, 'nvim-web-devicons')
  if ok then
    get_icon = devicon.get_icon
  end
end

function M.get()
  local bufnrs = vim.tbl_filter(function(bufnr) ---@param bufnr integer
    return 1 == vim.fn.buflisted(bufnr)
  end, vim.api.nvim_list_bufs())

  return vim.tbl_map(function(t) ---@param t integer
    if not get_icon then
      return {
        bufnr = t,
        str = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(t), ':.'),
      }
    end
    local bufname = vim.api.nvim_buf_get_name(t)
    local base_name = vim.fn.fnamemodify(bufname, ':t')
    local icon, hl = get_icon(base_name)
    local str = vim.fn.fnamemodify(bufname, ':.')
    return {
      str = (icon or '󰈔') .. ' ' .. str,
      bufnr = t,
      highlight = {
        { 0, 2, hl },
        { 3, #str - #base_name + 4, 'Comment' },
      },
    }
  end, bufnrs)
end

---@param s { bufnr: integer }
function M.default_action(s)
  vim.api.nvim_set_current_buf(s.bufnr)
end

---@return table<string, fun(entry: PickerItem)> actions
function M.actions()
  return { ---@type table<string, fun(entry: PickerItem)>
    ['<C-v>'] = function(entry)
      vim.cmd(string.format('vertical sbuffer %d', entry.bufnr))
    end,
    ['<C-t>'] = function(entry)
      vim.cmd(string.format('tab sbuffer %d', entry.bufnr))
    end,
  }
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(vim.api.nvim_buf_get_name(item.bufnr), win, buf)
end

return M
