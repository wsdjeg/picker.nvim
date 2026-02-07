---@class Picker.Sources.AsyncFiles
local M = {}

local previewer = require('picker.previewer.file')
local util = require('picker.util')

local job
local get_icon ---@type nil|fun(name: string, ext?: string, opts?: any): string, string

---@return boolean ok
function M.enabled()
  local ok
  ok, job = pcall(require, 'job')
  if not ok then
    util.notify('async_files source require wsdjeg/job.nvim')
  end
  return ok
end

local items = {} ---@type PickerItem[]
local cmd = { ---@type string[]|string
  'rg',
  '--files',
  '--hidden',
  '--ignore',
  '--text',
  '--glob',
  '!.git/',
}

local jobid = -1 ---@type integer

---@param id integer
---@param data string[]
local function on_stdout(id, data)
  if id ~= jobid then
    return
  end
  vim.tbl_map(function(t) ---@param t string
    if get_icon then
      local icon, hl = get_icon(vim.fn.fnamemodify(t, ':t'))
      table.insert(items, {
        str = (icon or '󰈔') .. ' ' .. t,
        value = t,
        highlight = { { 0, 2, hl } },
      })
    else
      table.insert(items, { value = t, str = t })
    end
  end, data)
  require('picker.windows').handle_prompt_changed()
end

---@param id integer
local function on_exit(id)
  if id ~= jobid then
    return
  end

  jobid = -1
  require('picker.windows').handle_prompt_changed()
end

local function async_run()
  items = {}
  if jobid > 0 then
    job.stop(jobid)
  end
  jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_exit = on_exit,
  })
end

---@param opt? { cmd?: string[]|string }
function M.set(opt)
  local ok, devicon = pcall(require, 'nvim-web-devicons')
  if ok then
    get_icon = devicon.get_icon
  end
  opt = opt or {}

  cmd = opt.cmd or cmd
  async_run()
end

---@return PickerItem[] items
function M.get()
  return items
end

---@param item PickerItem
function M.default_action(item)
  vim.cmd.edit(item.value)
end

---@return table<string, fun(entry: { value: string })> keymaps
function M.actions()
  return { ---@type table<string, fun(entry: { value: string })>
    ['<C-v>'] = function(entry)
      vim.cmd.vsplit(entry.value)
    end,
    ['<C-t>'] = function(entry)
      vim.cmd.tabedit(entry.value)
    end,
  }
end

local hidden = true ---@type boolean

---@return table<string, function> keymaps
function M.redraw_actions()
  return {
    ['<C-h>'] = function()
      if hidden then
        cmd = {
          'rg',
          '--files',
          '--hidden',
          '--ignore',
          '--text',
          '--glob',
          '!.git/',
        }
        hidden = false
      else
        cmd = { 'rg', '--files', '--ignore', '--text', '--glob', '!.git/' }
        hidden = true
      end
      async_run()
    end,
  }
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value, win, buf)
end

return M
