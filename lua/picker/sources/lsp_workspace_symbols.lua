---@class Picker.Sources.LspWorkspaceSymbols
local M = {}

local util = require('picker.util')
local previewer = require('picker.previewer.file')
local items = {} ---@type PickerItem[]

---@return PickerItem[] items
function M.get()
  return items
end

---@param entry PickerItem
function M.default_action(entry)
  vim.cmd.edit(vim.uri_to_fname(entry.value.location.uri))
  vim.api.nvim_win_set_cursor(0, {
    entry.value.location.range.start.line + 1,
    entry.value.location.range.start.character,
  })
end

---@param opt { buf: integer }
function M.set(opt)
  local client = vim.lsp.get_clients({ bufnr = opt.buf })[1]
  if not client then
    return
  end

  items = {}
  client:request(
    util.feature_map.workspace_symbols,
    { query = '' },
    ---@param result lsp.WorkspaceSymbol
    function(err, result)
      if not result or err then
        return
      end

      -- {
      --   kind = 13,
      --   location = {
      --     range = {
      --       ["end"] = {
      --         character = 27,
      --         line = 4257
      --       },
      --       start = {
      --         character = 9,
      --         line = 4257
      --       }
      --     },
      --     uri = "file:///d%3A/Scoop/apps/neovim/current/share/nvim/runtime/lua/vim/_meta/vimfn.lua"
      --   },
      --   name = "vim.fn.highlightID"
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
  local filename = vim.uri_to_fname(item.value.location.uri)
  previewer.preview(filename, win, buf, {
    lnum = item.value.location.range.start.line + 1,
    syntax = vim.filetype.match({ filename = filename }),
  })
end
return M
