-- test/search_history_spec.lua
-- Tests for the search history picker source

local lu = require('luaunit')
local search_history = require('picker.sources.search_history')

TestSearchHistory = {}

function TestSearchHistory:setup()
  -- Clear search history before each test
  vim.fn.histdel('search')
end

function TestSearchHistory:test_get_returns_table()
  local items = search_history.get()
  lu.assertEquals(type(items), 'table')
end

function TestSearchHistory:test_get_empty_when_no_history()
  local items = search_history.get()
  lu.assertEquals(#items, 0)
end

function TestSearchHistory:test_get_returns_items_after_search()
  vim.fn.histadd('search', 'hello')
  local items = search_history.get()
  lu.assertEquals(#items, 1)
  lu.assertEquals(items[1].str, 'hello')
end

function TestSearchHistory:test_get_returns_multiple_items()
  vim.fn.histadd('search', 'pattern1')
  vim.fn.histadd('search', 'pattern2')
  vim.fn.histadd('search', 'pattern3')
  local items = search_history.get()
  lu.assertEquals(#items, 3)
  -- Items should be in reverse order (newest first)
  lu.assertEquals(items[1].str, 'pattern3')
  lu.assertEquals(items[2].str, 'pattern2')
  lu.assertEquals(items[3].str, 'pattern1')
end

function TestSearchHistory:test_get_item_has_value_table()
  vim.fn.histadd('search', 'test_pattern')
  local items = search_history.get()
  lu.assertNotNil(items[1].value)
  lu.assertEquals(items[1].value.cmd, 'test_pattern')
  lu.assertNotNil(items[1].value.index)
end

function TestSearchHistory:test_actions_returns_table()
  local actions = search_history.actions()
  lu.assertEquals(type(actions), 'table')
end

function TestSearchHistory:test_actions_has_delete_key()
  local actions = search_history.actions()
  lu.assertNotNil(actions['<C-d>'])
end

function TestSearchHistory:test_actions_delete_removes_entry()
  vim.fn.histadd('search', 'to_delete')
  local items = search_history.get()
  lu.assertEquals(#items, 1)
  -- Delete the entry
  local actions = search_history.actions()
  actions['<C-d>'](items[1])
  -- Verify it's deleted
  local remaining = search_history.get()
  lu.assertEquals(#remaining, 0)
end

return TestSearchHistory

