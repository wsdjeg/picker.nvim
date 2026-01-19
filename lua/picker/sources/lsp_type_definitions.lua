local M = {}

local util = require('picker.util')
local previewer = require('picker.previewer.file')
local items = {}

function M.get()
  return items
end

---@param entry PickerItem
function M.default_action(entry)
  vim.cmd.edit(vim.uri_to_fname(entry.value.targetUri))
  vim.api.nvim_win_set_cursor(
    0,
    {
      entry.value.targetRange.start.line + 1,
      entry.value.targetRange.start.character + 1,
    }
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

  items = {}

  client:request(
    util.feature_map.type_definitions,
    params,
    function(err, result, ctx, ...)
      if err or not result then
        return
      end

      for _, declaration in ipairs(result) do
        local filename = vim.uri_to_fname(declaration.uri)
        local file_bufnr = vim.uri_to_bufnr(declaration.uri)

        local line = declaration.range.start.line
        local context = vim.api.nvim_buf_get_lines(
          file_bufnr,
          line,
          line + 1,
          false
        )[1] or ''

        table.insert(items, {
          value = {
            targetUri = declaration.uri,
            targetRange = declaration.range,
          },
          str = string.format(
            '%s:%d:%s',
            vim.fn.fnamemodify(filename, ':.'),
            line + 1,
            context
          ),
          highlight = {
            {
              0,
              #vim.fn.fnamemodify(filename, ':.') + 2 + #tostring(line + 1),
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
  local filename = vim.uri_to_fname(item.value.targetUri)
  local line = item.value.targetRange.start.line
  previewer.preview(
    filename,
    win,
    buf,
    {
      lnum = line + 1,
      syntax = vim.filetype.match({ filename = filename }),
    }
  )
end

return M
