---@class Picker.Sources.Emoji
local M = {}

local emojis = {} ---@type PickerItem[]

-- emoji json file: https://github.com/muan/unicode-emoji-json

local previewer = require('picker.previewer.buffer')
local url =
  'https://raw.githubusercontent.com/muan/unicode-emoji-json/refs/heads/main/data-by-emoji.json'
local file = vim.fn.stdpath('cache') .. '/picker.nvim/data-by-emoji.json'

local function load()
  if vim.tbl_isempty(emojis) and vim.fn.filereadable(file) == 1 then
    for icon, info in
      pairs(vim.json.decode(table.concat(vim.fn.readfile(file, ''), '\n')))
    do
      info.icon = icon
      table.insert(
        emojis,
        { value = info, str = string.format('%s %s', icon, info.name) }
      )
    end
  end
end

function M.set()
  if vim.fn.filereadable(file) ~= 0 then
    return
  end
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local ok, job = pcall(require, 'job')
  if not ok then
    vim.fn.system({ 'curl', '-fLo', file, '--create-dirs', url })
    return
  end
  --- vim.system on_exit must be called in fast event context
  --- and can not use vim.fn.timerstop which is used in handle_prompt_changed
  --- function.
  job.start({ 'curl', '-fLo', file, '--create-dirs', url }, {
    on_exit = function(_, data, single)
      if data == 0 and single == 0 then
        load()
        require('picker.windows').handle_prompt_changed()
      end
    end,
  })
end

---@return PickerItem[] emojis
function M.get()
  load()
  return emojis
end

---@param entry PickerItem
function M.default_action(entry)
  vim.api.nvim_paste(entry.value.icon, false, -1)
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.buflines = vim.split(vim.inspect(item.value), '[\r]?\n')
  previewer.filetype = 'lua'
  previewer.preview(1, win, buf, true)
end
return M
