---@class Picker.Sources.LspDeclarations
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
  vim.cmd.edit(vim.uri_to_fname(entry.value.targetUri))
  vim.api.nvim_win_set_cursor(0, {
    entry.value.targetRange.start.line + 1,
    entry.value.targetRange.start.character + 1,
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
    util.feature_map.declarations,
    vim.lsp.util.make_position_params(
      vim.api.nvim_get_current_win(),
      client.offset_encoding
    ),
    ---@param result? lsp.Location[]
    function(err, result)
      if err or not result then
        return
      end

      -- lsp declaration result: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_declaration
      for _, declaration in ipairs(result) do
        local filename =
          vim.fn.fnamemodify(vim.uri_to_fname(declaration.uri), ':.')
        table.insert(items, {
          value = {
            targetUri = declaration.uri,
            targetRange = declaration.range,
          },
          str = string.format(
            '%s:%d:%s',
            filename,
            declaration.range.start.line + 1,
            vim.api.nvim_buf_get_lines(
              vim.uri_to_bufnr(declaration.uri),
              declaration.range.start.line,
              declaration.range.start.line + 1,
              false
            )[1] or ''
          ),
          highlight = {
            {
              0,
              string.len(filename)
                + 2
                + string.len(tostring(declaration.range.start.line + 1)),
              'Comment',
            },
          },
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
  local filename = vim.uri_to_fname(item.value.targetUri)
  previewer.preview(filename, win, buf, {
    lnum = item.value.targetRange.start.line + 1,
    syntax = vim.filetype.match({ filename = filename }),
  })
end
return M
