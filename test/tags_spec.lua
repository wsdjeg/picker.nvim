-- test/tags_spec.lua
-- Tests for the tags picker source

local lu = require('luaunit')
local tags = require('picker.sources.tags')

TestTags = {}

function TestTags:test_get_returns_table()
  local items = tags.get()
  lu.assertEquals(type(items), 'table')
end

function TestTags:test_get_item_has_str()
  local items = tags.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    break
  end
end

function TestTags:test_get_item_has_value()
  local items = tags.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    break
  end
end

function TestTags:test_preview_win_is_true()
  lu.assertTrue(tags.preview_win)
end

function TestTags:test_has_default_action()
  lu.assertNotNil(tags.default_action)
  lu.assertEquals(type(tags.default_action), 'function')
end

return TestTags

