local M = {}
local configs = {
  {
    name = 'prompt-top',
    desc = 'change the prompt position to top',
    func = function()
      require('picker').setup({
        prompt = {
          position = 'top', --- bottom or top
        },
      })
    end,
  },
  {
    name = 'prompt-bottom',
    desc = 'change the prompt position to bottom',
    func = function()
      require('picker').setup({
        prompt = {
          position = 'bottom', --- bottom or top
        },
      })
    end,
  },
  {
    name = 'show-score',
    desc = 'display matched score',
    func = function()
      require('picker').setup({
        window = {
          show_score = true, --- boolean
        },
      })
    end,
  },
  {
    name = 'hide-score',
    desc = 'hide matched score',
    func = function()
      require('picker').setup({
        window = {
          show_score = false, --- boolean
        },
      })
    end,
  },
  {
    name = 'ignrecase',
    desc = 'change filter ignrecase to true',
    func = function()
      require('picker').setup({
        filter = {
          ignorecase = true, --- bottom or top
        },
      })
    end,
  },
  {
    name = 'noignrecase',
    desc = 'change filter ignrecase to false',
    func = function()
      require('picker').setup({
        filter = {
          ignorecase = false, --- bottom or top
        },
      })
    end,
  },
  {
    name = 'matcher-fzy',
    desc = 'use fzy matcher',
    func = function()
      require('picker').setup({
        filter = {
          matcher = 'fzy',
        },
      })
    end,
  },
  {
    name = 'matcher-matchfuzzy',
    desc = 'use built-in matchfuzzy matcher',
    func = function()
      require('picker').setup({
        filter = {
          matcher = 'matchfuzzy',
        },
      })
    end,
  },
  {
    name = 'matcher-levenshtein',
    desc = 'use levenshtein matcher',
    func = function()
      require('picker').setup({
        filter = {
          matcher = 'levenshtein',
        },
      })
    end,
  },
}

---@return table<PickerItem>
function M.get()
  local layouts = vim.tbl_map(function(t)
    return vim.fn.fnamemodify(t, ':t:r')
  end, vim.api.nvim_get_runtime_file('lua/picker/layout/*.lua', true))
  local rst = vim.tbl_map(function(t)
    return {
      str = string.format('%s -> %s', t.name, t.desc),
      value = t,
      highlight = {
        { 0, #t.name, 'TODO' },
        { #t.name, #t.name + 4, 'Comment' },
        { #t.name + 4, #t.name + #t.desc + 4, 'String' },
      },
    }
  end, configs)
  for _, layout in ipairs(layouts) do
    local t = {
      name = string.format('layout-%s', layout),
      desc = string.format('change to %s layout', layout),
      func = function()
        require('picker').setup({
          window = {
            layout = layout,
          },
        })
      end,
    }
    table.insert(rst, {
      str = string.format('%s -> %s', t.name, t.desc),
      value = t,
      highlight = {
        { 0, #t.name, 'TODO' },
        { #t.name, #t.name + 4, 'Comment' },
        { #t.name + 4, #t.name + #t.desc + 4, 'String' },
      },
    })
  end
  return rst
end

---@param entry PickerItem
function M.default_action(entry)
  entry.value.func()
end

return M
