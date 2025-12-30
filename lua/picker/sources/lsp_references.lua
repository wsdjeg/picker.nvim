local M = {}

local util = require('picker.util')
local previewer = require('picker.previewer.file')
local items = {}

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

function M.set(opt)
  local bufnr = opt.buf
  local client = vim.lsp.get_clients({ bufnr = bufnr })[1]
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
    function(err, result, ctx, ...)
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
        local filename = vim.uri_to_fname(ref.uri)
        local file_bufnr = vim.uri_to_bufnr(ref.uri)
        local context = vim.api.nvim_buf_get_lines(
          file_bufnr,
          ref.range.start.line,
          ref.range.start.line + 1,
          false
        )[1] or ''
        table.insert(items, {
          value = ref,
          str = string.format(
            '%s:%d:%s',
            vim.fn.fnamemodify(filename, ':.'),
            ref.range.start.line,
            context
          ),
          highlight = {
            {
              0,
              #vim.fn.fnamemodify(filename, ':.') + 2 + #tostring(
                ref.range.start.line
              ),
              'Comment',
            },
          },
        })
      end
      require('picker.windows').handle_prompt_changed()
    end,
    bufnr
  )
end

M.preview_win = true

function M.preview(item, win, buf)
  local filename = vim.uri_to_fname(item.value.uri)
  local line = item.value.range.start.line
  previewer.preview(
    filename,
    win,
    buf,
    { lnum = line + 1, syntax = vim.filetype.match({ filename = filename }) }
  )
end

return M
