---@class Picker.Sources.Lines
local M = {}
local opts = {} ---@type { current_buf: integer }
local previewer = require('picker.previewer.buffer')

---@return PickerItem[] items
function M.get()
  local bufnr = opts.current_buf
  previewer.buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  previewer.filetype =
    vim.api.nvim_get_option_value('filetype', { buf = bufnr })

  local items = {} ---@type PickerItem[]
  for linenr, v in ipairs(previewer.buflines) do
    table.insert(items, {
      value = { line = linenr, text = v },
      str = v,
    })
  end
  return items
end

---@param selected PickerItem
function M.default_action(selected)
  vim.cmd(tostring(selected.value.line))
end

---@param opt { buf: integer }
function M.set(opt)
  opts.current_buf = opt.buf
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value.line, win, buf)
end
return M
