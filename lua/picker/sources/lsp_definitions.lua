---@class Picker.Sources.LspDefinitions
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
    util.feature_map.definitions,
    vim.tbl_extend(
      'force',
      vim.lsp.util.make_position_params(
        vim.api.nvim_get_current_win(),
        client.offset_encoding
      ),
      {
        context = { includeDeclaration = true },
      }
    ),
    ---@param result? lsp.DefinitionLink[]
    function(err, result)
      if not result or err then
        return
      end

      -- { {
      --     originSelectionRange = {
      --       ["end"] = {
      --         character = 14,
      --         line = 18
      --       },
      --       start = {
      --         character = 8,
      --         line = 18
      --       }
      --     },
      --     targetRange = {
      --       ["end"] = {
      --         character = 5,
      --         line = 12
      --       },
      --       start = {
      --         character = 0,
      --         line = 12
      --       }
      --     },
      --     targetSelectionRange = {
      --       ["end"] = {
      --         character = 5,
      --         line = 12
      --       },
      --       start = {
      --         character = 0,
      --         line = 12
      --       }
      --     },
      --     targetUri = "file:///d%3A/scratch/lsp_def.lua"
      --   }, {
      --     originSelectionRange = {
      --       ["end"] = {
      --         character = 14,
      --         line = 18
      --       },
      --       start = {
      --         character = 8,
      --         line = 18
      --       }
      --     },
      --     targetRange = {
      --       ["end"] = {
      --         character = 73,
      --         line = 14
      --       },
      --       start = {
      --         character = 67,
      --         line = 14
      --       }
      --     },
      --     targetSelectionRange = {
      --       ["end"] = {
      --         character = 73,
      --         line = 14
      --       },
      --       start = {
      --         character = 67,
      --         line = 14
      --       }
      --     },
      --     targetUri = "file:///d%3A/scratch/lsp_def.lua"
      --   }, {
      --     originSelectionRange = {
      --       ["end"] = {
      --         character = 14,
      --         line = 18
      --       },
      --       start = {
      --         character = 8,
      --         line = 18
      --       }
      --     },
      --     targetRange = {
      --       ["end"] = {
      --         character = 10,
      --         line = 16
      --       },
      --       start = {
      --         character = 4,
      --         line = 16
      --       }
      --     },
      --     targetSelectionRange = {
      --       ["end"] = {
      --         character = 10,
      --         line = 16
      --       },
      --       start = {
      --         character = 4,
      --         line = 16
      --       }
      --     },
      --     targetUri = "file:///d%3A/scratch/lsp_def.lua"
      --   }, {
      --     originSelectionRange = {
      --       ["end"] = {
      --         character = 14,
      --         line = 18
      --       },
      --       start = {
      --         character = 8,
      --         line = 18
      --       }
      --     },
      --     targetRange = {
      --       ["end"] = {
      --         character = 10,
      --         line = 17
      --       },
      --       start = {
      --         character = 4,
      --         line = 17
      --       }
      --     },
      --     targetSelectionRange = {
      --       ["end"] = {
      --         character = 10,
      --         line = 17
      --       },
      --       start = {
      --         character = 4,
      --         line = 17
      --       }
      --     },
      --     targetUri = "file:///d%3A/scratch/lsp_def.lua"
      --   } }

      for _, definition in ipairs(result) do
        local filename =
          vim.fn.fnamemodify(vim.uri_to_fname(definition.targetUri), ':.')
        table.insert(items, {
          value = definition,
          str = string.format(
            '%s:%d:%s',
            filename,
            definition.targetRange.start.line + 1,
            vim.api.nvim_buf_get_lines(
              vim.uri_to_bufnr(definition.targetUri),
              definition.targetRange.start.line,
              definition.targetRange.start.line + 1,
              false
            )[1] or ''
          ),
          highlight = {
            {
              0,
              string.len(filename)
                + 2
                + string.len(tostring(definition.targetRange.start.line)),
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
