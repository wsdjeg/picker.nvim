---@class Picker.Sources.LspDocumentSymbols
local M = {}

local util = require('picker.util')
local previewer = require('picker.previewer.buffer')
local items = {} ---@type PickerItem[]

---@return PickerItem[] items
function M.get()
  return items
end

---@param entry PickerItem
function M.default_action(entry)
  vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_buf(), {
    entry.value.range.start.line + 1,
    entry.value.range.start.character,
  })
end

---@param opt { buf: integer }
function M.set(opt)
  previewer.buflines = vim.api.nvim_buf_get_lines(opt.buf, 0, -1, false)
  previewer.filetype =
    vim.api.nvim_get_option_value('filetype', { buf = opt.buf })

  local client = vim.lsp.get_clients({ bufnr = opt.buf })[1]
  if not client then
    return
  end

  items = {}
  client:request(
    util.feature_map.document_symbols,
    vim.lsp.util.make_position_params(
      vim.api.nvim_get_current_win(),
      client.offset_encoding
    ),
    ---@param result? lsp.DocumentSymbol[]
    function(err, result)
      if not result or err then
        return
      end

      -- {
      --   detail = "",
      --   kind = 13,
      --   name = "bufnr",
      --   range = {
      --     ["end"] = {
      --       character = 44,
      --       line = 0
      --     },
      --     start = {
      --       character = 6,
      --       line = 0
      --     }
      --   },
      --   selectionRange = {
      --     ["end"] = {
      --       character = 11,
      --       line = 0
      --     },
      --     start = {
      --       character = 6,
      --       line = 0
      --     }
      --   }
      -- }

      for _, symbol in ipairs(result) do
        local kind = util.symbol_kind(symbol.kind)
        table.insert(items, {
          value = symbol,
          str = ('%s %s'):format(kind, symbol.name),
          highlight = { { 0, kind:len() + 1, 'Comment' } },
        })
      end
      require('picker.windows').handle_prompt_changed()
    end,
    opt.buf
  )
end

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.preview(item.value.range.start.line + 1, win, buf)
end
return M
