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

-- ============ Sync filter tests ============

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

-- ============ Async filter tests ============

function TestFilter:test_async_empty_input_returns_all_items()
  local source = make_source({ 'apple', 'banana', 'cherry' })
  local done = false
  filter.filter_async('', source, false, function()
    done = true
  end)
  -- Empty input is synchronous (no coroutine needed)
  lu.assertTrue(done)
  lu.assertEquals(#source.filter_items, 3)
end

function TestFilter:test_async_basic_filter()
  local source = make_source({ 'apple', 'banana', 'cherry', 'apricot' })
  local done = false
  filter.filter_async('ap', source, false, function()
    done = true
  end)
  -- Small dataset: completes in first resume (no yield)
  lu.assertTrue(done)
  lu.assertEquals(#source.filter_items, 2)
  lu.assertEquals(source.filter_items[1][4].str, 'apple')
  lu.assertEquals(source.filter_items[2][4].str, 'apricot')
end

function TestFilter:test_async_no_matches()
  local source = make_source({ 'apple', 'banana' })
  local done = false
  filter.filter_async('xyz', source, false, function()
    done = true
  end)
  lu.assertTrue(done)
  lu.assertEquals(#source.filter_items, 0)
end

function TestFilter:test_async_results_sorted_by_score_desc()
  local source = make_source({ 'axpx', 'apple', 'ap' })
  local done = false
  filter.filter_async('ap', source, false, function()
    done = true
  end)
  lu.assertTrue(done)
  lu.assertEquals(source.filter_items[1][4].str, 'ap')
  lu.assertEquals(source.filter_items[2][4].str, 'apple')
  lu.assertEquals(source.filter_items[3][4].str, 'axpx')
  lu.assertTrue(source.filter_items[1][3] >= source.filter_items[2][3])
  lu.assertTrue(source.filter_items[2][3] >= source.filter_items[3][3])
end

function TestFilter:test_async_previous_input_updated()
  local source = make_source({ 'apple', 'banana' })
  local done = false
  filter.filter_async('ap', source, false, function()
    done = true
  end)
  lu.assertTrue(done)
  lu.assertEquals(source.state.previous_input, 'ap')
end

function TestFilter:test_async_large_dataset()
  -- Create > CHUNK_SIZE (500) items to test chunked processing
  local strs = {}
  for i = 1, 1000 do
    table.insert(strs, 'item_' .. i)
  end
  table.insert(strs, 'apple')
  table.insert(strs, 'apricot')

  local source = make_source(strs)
  local done = false
  filter.filter_async('ap', source, false, function()
    done = true
  end)
  -- Wait for async chunks to complete via event loop
  local ok = vim.wait(5000, function()
    return done
  end)
  lu.assertTrue(ok, 'filter_async did not complete within timeout')
  lu.assertEquals(#source.filter_items, 2)
  lu.assertEquals(source.filter_items[1][4].str, 'apple')
  lu.assertEquals(source.filter_items[2][4].str, 'apricot')
end

function TestFilter:test_async_cancellation()
  -- When a newer filter starts, the older one should be cancelled
  local strs = {}
  for i = 1, 1000 do
    table.insert(strs, 'item_' .. i)
  end
  table.insert(strs, 'apple')

  local source = make_source(strs)
  local old_done = false
  local new_done = false

  -- Start old filter (large dataset, will yield after first chunk)
  filter.filter_async('item', source, false, function()
    old_done = true
  end)

  -- Immediately start new filter (cancels old one)
  filter.filter_async('apple', source, false, function()
    new_done = true
  end)

  local ok = vim.wait(5000, function()
    return new_done
  end)
  lu.assertTrue(ok, 'new filter did not complete within timeout')
  -- New filter should complete
  lu.assertTrue(new_done)
  -- Old filter should NOT complete (cancelled by newer filter)
  lu.assertFalse(old_done)
end

function TestFilter:test_async_progressive_filter()
  local source = make_source({ 'apple', 'apricot', 'banana' })

  -- First filter with 'ap'
  local done1 = false
  filter.filter_async('ap', source, false, function()
    done1 = true
  end)
  lu.assertTrue(done1)
  lu.assertEquals(#source.filter_items, 2)

  -- Now filter with 'apl' (refinement of 'ap')
  local done2 = false
  filter.filter_async('apl', source, false, function()
    done2 = true
  end)
  lu.assertTrue(done2)
  lu.assertEquals(#source.filter_items, 1)
  lu.assertEquals(source.filter_items[1][4].str, 'apple')
end

return TestFilter

