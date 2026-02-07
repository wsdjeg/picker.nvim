---@class Picker.Sources.Files
local M = {}

local previewer = require('picker.previewer.file')

local list_files_cmd = { ---@type string[]|string
  'rg',
  '--files',
  '--hidden',
  '--ignore',
  '--text',
  '--glob',
  '!.git/',
}

local get_icon ---@type nil|fun(name: string, ext?: string, opts?: any): string, string

---@param opt { cmd: string[]|string }
function M.set(opt)
  opt = opt or {}

  if opt.cmd then
    list_files_cmd = opt.cmd
  end
  local ok, devicon = pcall(require, 'nvim-web-devicons')
  if not ok then
    devicon = nil
    return
  end

  get_icon = devicon.get_icon
end

---@return PickerItem[] items
function M.get()
  return vim.tbl_map(
    function(t) ---@param t string
      if get_icon then
        local icon, hl = get_icon(t)
        return { ---@type PickerItem
          value = vim.fn.fnamemodify(t, ':p'),
          str = (icon or '󰈔') .. ' ' .. t,
          highlight = { { 0, 2, hl } },
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

---@return table<string, fun(entry: PickerItem)> actions
function M.actions()
  return { ---@type table<string, fun(entry: PickerItem)>
    ['<C-v>'] = function(entry)
      vim.cmd.vsplit(entry.value)
    end,
    ['<C-t>'] = function(entry)
      vim.cmd.tabedit(entry.value)
    end,
  }
end

local hidden = true ---@type boolean

---@return table<string, fun(entry: PickerItem)> actions
function M.redraw_actions()
  return { ---@type table<string, fun(entry: PickerItem)>
    ['<C-h>'] = function()
      list_files_cmd = { 'rg', '--files' }

      if hidden then
        table.insert(list_files_cmd, '--hidden')
        hidden = false
        return
      end
      hidden = true
    end,
  }
end

---@param item PickerItem
function M.default_action(item)
  vim.cmd.edit(item.value)
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value, win, buf)
end

return M
