---@class Picker.Sources.LspReferences
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
  vim.cmd.edit(vim.uri_to_fname(entry.value.uri))
  vim.api.nvim_win_set_cursor(
    0,
    { entry.value.range.start.line + 1, entry.value.range.start.character }
  )
end

---@param opt { buf: integer }
function M.set(opt)
  local client = vim.lsp.get_clients({ bufnr = opt.buf })[1]
  if not client then
    return
  end
  local params = vim.lsp.util.make_position_params(
    vim.api.nvim_get_current_win(),
    client.offset_encoding
  )

  params = vim.tbl_extend('force', params, {
    context = { includeDeclaration = true },
  })

  items = {}

  client:request(
    util.feature_map.references,
    params,
    ---@param result? lsp.Location[]
    function(err, result)
      if not result or err then
        return
      end

      -- { {
      --     range = {
      --       ["end"] = {
      --         character = 17,
      --         line = 10
      --       },
      --       start = {
      --         character = 6,
      --         line = 10
      --       }
      --     },
      --     uri = "file:///c%3A/Users/wsdjeg/AppData/Local/nvim/lua/picker/sources/lsp.lua"
      --   }, {
      --     range = {
      --       ["end"] = {
      --         character = 26,
      --         line = 21
      --       },
      --       start = {
      --         character = 15,
      --         line = 21
      --       }
      --     },
      --     uri = "file:///c%3A/Users/wsdjeg/AppData/Local/nvim/lua/picker/sources/lsp.lua"
      --   } }

      for _, ref in ipairs(result) do
        local filename = vim.fn.fnamemodify(vim.uri_to_fname(ref.uri), ':.')
        table.insert(items, {
          value = ref,
          str = string.format(
            '%s:%d:%s',
            filename,
            ref.range.start.line,
            vim.api.nvim_buf_get_lines(
              vim.uri_to_bufnr(ref.uri),
              ref.range.start.line,
              ref.range.start.line + 1,
              false
            )[1] or ''
          ),
          highlight = {
            {
              0,
              string.len(filename) + 2 + string.len(
                tostring(ref.range.start.line)
              ),
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
  local filename = vim.uri_to_fname(item.value.uri)
  previewer.preview(filename, win, buf, {
    lnum = item.value.range.start.line + 1,
    syntax = vim.filetype.match({ filename = filename }),
  })
end
return M
