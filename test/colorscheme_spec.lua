-- test/colorscheme_spec.lua
-- Tests for the colorscheme picker source

local lu = require('luaunit')
local colorscheme = require('picker.sources.colorscheme')

TestColorscheme = {}

function TestColorscheme:test_get_returns_table()
  local items = colorscheme.get()
  lu.assertEquals(type(items), 'table')
end

function TestColorscheme:test_get_returns_non_empty()
  -- Neovim always has at least the 'default' colorscheme
  local items = colorscheme.get()
  lu.assertTrue(#items > 0)
end

function TestColorscheme:test_get_item_has_str()
  local items = colorscheme.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestColorscheme:test_get_item_has_value()
  local items = colorscheme.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertEquals(item.value, item.str)
    break
  end
end

function TestColorscheme:test_get_contains_default_colorscheme()
  -- 'default' is a built-in colorscheme
  local items = colorscheme.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str == 'default' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'default colorscheme should be in results')
end

function TestColorscheme:test_preview_win_is_false()
  lu.assertFalse(colorscheme.preview_win)
end

function TestColorscheme:test_has_cleanup_function()
  lu.assertNotNil(colorscheme.cleanup)
  lu.assertEquals(type(colorscheme.cleanup), 'function')
end

return TestColorscheme

