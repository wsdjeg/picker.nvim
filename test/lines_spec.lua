-- test/lines_spec.lua
-- Tests for the lines picker source

local lu = require('luaunit')
local lines = require('picker.sources.lines')

TestLines = {}

function TestLines:setup()
  -- Create a test buffer with known content
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    'line one',
    'line two',
    'line three',
  })
  lines.set({ buf = buf })
end

function TestLines:test_get_returns_table()
  local items = lines.get()
  lu.assertEquals(type(items), 'table')
end

function TestLines:test_get_returns_all_lines()
  local items = lines.get()
  lu.assertEquals(#items, 3)
end

function TestLines:test_get_item_str_matches_line()
  local items = lines.get()
  lu.assertEquals(items[1].str, 'line one')
  lu.assertEquals(items[2].str, 'line two')
  lu.assertEquals(items[3].str, 'line three')
end

function TestLines:test_get_item_has_value()
  local items = lines.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertNotNil(item.value.line)
    lu.assertNotNil(item.value.text)
    break
  end
end

function TestLines:test_get_item_value_line_is_line_number()
  local items = lines.get()
  lu.assertEquals(items[1].value.line, 1)
  lu.assertEquals(items[2].value.line, 2)
  lu.assertEquals(items[3].value.line, 3)
end

function TestLines:test_get_item_value_text_matches_str()
  local items = lines.get()
  for _, item in ipairs(items) do
    lu.assertEquals(item.value.text, item.str)
    break
  end
end

function TestLines:test_get_empty_buffer()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  lines.set({ buf = buf })
  local items = lines.get()
  -- Neovim buffers always have at least one line (possibly empty)
  lu.assertTrue(#items <= 1)
  if #items == 1 then
    lu.assertEquals(items[1].str, '')
  end
  vim.api.nvim_buf_delete(buf, { force = true })
end

function TestLines:test_preview_win_is_true()
  lu.assertTrue(lines.preview_win)
end

return TestLines

