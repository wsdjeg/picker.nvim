-- test/marks_spec.lua
-- Tests for the marks picker source

local lu = require('luaunit')
local marks = require('picker.sources.marks')

TestMarks = {}

function TestMarks:test_get_returns_table()
  local items = marks.get()
  lu.assertEquals(type(items), 'table')
end

function TestMarks:test_get_includes_set_mark()
  -- Set a mark and verify it appears
  vim.cmd('mark T')
  local items = marks.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value and item.value.mark and item.value.mark:match('T') then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'mark T should be in results')
end

function TestMarks:test_get_item_has_str()
  local items = marks.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    break
  end
end

function TestMarks:test_get_item_has_value()
  local items = marks.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    break
  end
end

function TestMarks:test_get_item_has_highlight()
  vim.cmd('mark T')
  local items = marks.get()
  for _, item in ipairs(items) do
    if item.highlight then
      lu.assertEquals(type(item.highlight), 'table')
      break
    end
  end
end

function TestMarks:test_preview_win_is_true()
  lu.assertTrue(marks.preview_win)
end

function TestMarks:test_has_default_action()
  lu.assertNotNil(marks.default_action)
  lu.assertEquals(type(marks.default_action), 'function')
end

return TestMarks

