-- test/sources_spec.lua
-- Tests for the sources registry module (lua/picker/sources.lua)

local lu = require('luaunit')
local sources = require('picker.sources')

TestSources = {}

function TestSources:test_get_returns_table()
  local items = sources.get()
  lu.assertEquals(type(items), 'table')
end

function TestSources:test_get_returns_non_empty()
  -- Should find source files in lua/picker/sources/
  local items = sources.get()
  lu.assertTrue(#items > 0)
end

function TestSources:test_get_item_has_str()
  local items = sources.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestSources:test_get_item_has_value()
  local items = sources.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertEquals(item.value, item.str)
    break
  end
end

function TestSources:test_get_contains_known_source()
  -- 'buffers' is a known source file
  local items = sources.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str == 'buffers' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'buffers source should be in results')
end

function TestSources:test_get_contains_files_source()
  local items = sources.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str == 'files' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'files source should be in results')
end

function TestSources:test_get_contains_colorscheme_source()
  local items = sources.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str == 'colorscheme' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'colorscheme source should be in results')
end

function TestSources:test_preview_win_is_false()
  lu.assertFalse(sources.preview_win)
end

function TestSources:test_has_default_action()
  lu.assertNotNil(sources.default_action)
  lu.assertEquals(type(sources.default_action), 'function')
end

return TestSources

