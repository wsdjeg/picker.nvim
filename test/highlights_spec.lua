-- test/highlights_spec.lua
-- Tests for the highlights picker source

local lu = require('luaunit')
local highlights = require('picker.sources.highlights')

TestHighlights = {}

function TestHighlights:test_get_returns_table()
  local items = highlights.get()
  lu.assertEquals(type(items), 'table')
end

function TestHighlights:test_get_returns_non_empty()
  -- Neovim always has built-in highlight groups
  local items = highlights.get()
  lu.assertTrue(#items > 0)
end

function TestHighlights:test_get_item_has_str()
  local items = highlights.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestHighlights:test_get_item_has_value()
  local items = highlights.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    break
  end
end

function TestHighlights:test_get_item_has_highlight()
  local items = highlights.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.highlight)
    lu.assertEquals(type(item.highlight), 'table')
    break
  end
end

function TestHighlights:test_get_contains_known_highlight()
  -- 'Normal' is a built-in highlight group
  local items = highlights.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str == 'Normal' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'Normal highlight group should be in results')
end

function TestHighlights:test_get_highlight_uses_group_name_as_hl()
  -- The highlight field should reference the group name itself
  local items = highlights.get()
  for _, item in ipairs(items) do
    -- highlight[1] = { start, end, hl_group_name }
    lu.assertEquals(item.highlight[1][3], item.str)
    break
  end
end

function TestHighlights:test_preview_win_is_true()
  lu.assertTrue(highlights.preview_win)
end

return TestHighlights

