-- test/jumps_spec.lua
-- Tests for the jumps picker source

local lu = require('luaunit')
local jumps = require('picker.sources.jumps')

TestJumps = {}

function TestJumps:test_get_returns_table()
  local items = jumps.get()
  lu.assertEquals(type(items), 'table')
end

function TestJumps:test_get_item_has_str()
  local items = jumps.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    break
  end
end

function TestJumps:test_get_item_has_value()
  local items = jumps.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    break
  end
end

function TestJumps:test_preview_win_is_true()
  lu.assertTrue(jumps.preview_win)
end

function TestJumps:test_has_default_action()
  lu.assertNotNil(jumps.default_action)
  lu.assertEquals(type(jumps.default_action), 'function')
end

return TestJumps

