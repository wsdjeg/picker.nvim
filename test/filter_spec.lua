-- test/filter_spec.lua
-- Tests for the filter module

local lu = require('luaunit')
local config = require('picker.config')
local filter = require('picker.filter')

TestFilter = {}

function TestFilter:setup()
  -- Reset config to defaults
  config.setup({
    filter = {
      ignorecase = false,
      matcher = 'fzy',
    },
  })
end

-- Helper: create a fake source with items
local function make_source(strs)
  local items = {}
  for _, s in ipairs(strs) do
    table.insert(items, { str = s })
  end
  return {
    state = { items = items },
    filter_items = {},
  }
end

function TestFilter:test_empty_input_returns_all_items()
  local source = make_source({ 'apple', 'banana', 'cherry' })
  filter.filter('', source, false)
  lu.assertEquals(#source.filter_items, 3)
  -- Each item should have empty positions and score 0
  for i, item in ipairs(source.filter_items) do
    lu.assertEquals(item[1], i) -- original index
    lu.assertEquals(item[2], {}) -- no matched positions
    lu.assertEquals(item[3], 0) -- score 0
  end
end

function TestFilter:test_basic_filter()
  local source = make_source({ 'apple', 'banana', 'cherry', 'apricot' })
  filter.filter('ap', source, false)
  lu.assertEquals(#source.filter_items, 2)
  lu.assertEquals(source.filter_items[1][4].str, 'apple')
  lu.assertEquals(source.filter_items[2][4].str, 'apricot')
end

function TestFilter:test_no_matches()
  local source = make_source({ 'apple', 'banana' })
  filter.filter('xyz', source, false)
  lu.assertEquals(#source.filter_items, 0)
end

function TestFilter:test_results_sorted_by_score_desc()
  local source = make_source({ 'axpx', 'apple', 'ap' })
  filter.filter('ap', source, false)
  -- 'ap' should score highest (exact match), then 'apple', then 'axpx'
  lu.assertEquals(source.filter_items[1][4].str, 'ap')
  lu.assertEquals(source.filter_items[2][4].str, 'apple')
  lu.assertEquals(source.filter_items[3][4].str, 'axpx')
  -- Verify scores are descending
  lu.assertTrue(source.filter_items[1][3] >= source.filter_items[2][3])
  lu.assertTrue(source.filter_items[2][3] >= source.filter_items[3][3])
end

function TestFilter:test_filter_items_contain_original_index()
  local source = make_source({ 'apple', 'banana', 'apricot' })
  filter.filter('ap', source, false)
  -- 'apple' is index 1, 'apricot' is index 3
  lu.assertEquals(source.filter_items[1][1], 1)
  lu.assertEquals(source.filter_items[2][1], 3)
end

function TestFilter:test_filter_items_contain_positions()
  local source = make_source({ 'apple' })
  filter.filter('ap', source, false)
  -- 'ap' matches positions 1,2 in 'apple'
  lu.assertNotNil(source.filter_items[1][2])
  lu.assertTrue(#source.filter_items[1][2] > 0)
end

function TestFilter:test_filter_items_contain_original_item()
  local source = make_source({ 'apple', 'banana' })
  filter.filter('ap', source, false)
  lu.assertNotNil(source.filter_items[1][4])
  lu.assertEquals(source.filter_items[1][4].str, 'apple')
end

function TestFilter:test_previous_input_updated()
  local source = make_source({ 'apple', 'banana' })
  filter.filter('ap', source, false)
  lu.assertEquals(source.state.previous_input, 'ap')
end

function TestFilter:test_incremental_filter_uses_previous_results()
  local source = make_source({ 'apple', 'apricot', 'banana' })
  -- First filter with 'ap'
  filter.filter('ap', source, false)
  lu.assertEquals(#source.filter_items, 2)

  -- Now filter with 'apl' (which is a refinement of 'ap')
  filter.filter('apl', source, false)
  lu.assertEquals(#source.filter_items, 1)
  lu.assertEquals(source.filter_items[1][4].str, 'apple')
end

function TestFilter:test_case_sensitive()
  local source = make_source({ 'Apple', 'apple', 'APPLE' })
  filter.filter('AP', source, true)
  -- Only 'APPLE' should match with case_sensitive=true
  lu.assertEquals(#source.filter_items, 1)
  lu.assertEquals(source.filter_items[1][4].str, 'APPLE')
end

function TestFilter:test_case_insensitive()
  local source = make_source({ 'Apple', 'apple', 'APPLE' })
  filter.filter('ap', source, false)
  lu.assertEquals(#source.filter_items, 3)
end

return TestFilter

