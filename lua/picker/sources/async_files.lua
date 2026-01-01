local M = {}

local previewer = require('picker.previewer.file')
local util = require('picker.util')

local job
local get_icon

function M.enabled()
  local ok
  ok, job = pcall(require, 'job')
  if not ok then
    util.notify('async_files source require wsdjeg/job.nvim')
  end
  return ok
end

---@type PickerItem[]
local items = {}

local cmd =
  { 'rg', '--files', '--hidden', '--ignore', '--text', '--glob', '!.git/' }

local jobid = -1

local function on_stdout(id, data)
  if id == jobid then
    vim.tbl_map(function(t)
      if get_icon then
        local icon, hl = get_icon(vim.fn.fnamemodify(t, ':t'))
        table.insert(items, {
          str = (icon or '󰈔') .. ' ' .. t,
          value = t,
          highlight = {
            { 0, 2, hl },
          },
        })
      else
        table.insert(items, {
          value = t,
          str = t,
        })
      end
    end, data)
    require('picker.windows').handle_prompt_changed()
  end
end
local function on_exit(id)
  if id == jobid then
    jobid = -1
    require('picker.windows').handle_prompt_changed()
  end
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

function M.set(opt)
  local ok, devicon = pcall(require, 'nvim-web-devicons')
  if ok then
    get_icon = devicon.get_icon
  end
  opt = opt or {}

  cmd = opt.cmd or cmd
  async_run()
end

function M.get()
  return items
end

---@field item PickerItem
function M.default_action(item)
  vim.cmd('edit ' .. item.value)
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

local hidden = true

function M.redraw_actions()
  return {
    ['<C-h>'] = function(entry)
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

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
  previewer.preview(item.value, win, buf)
end

return M
