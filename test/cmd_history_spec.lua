-- test/cmd_history_spec.lua
-- Tests for the command history picker source

local lu = require('luaunit')
local cmd_history = require('picker.sources.cmd_history')

TestCmdHistory = {}

function TestCmdHistory:setup()
  -- Clear command history before each test
  vim.fn.histdel('cmd')
end

function TestCmdHistory:test_get_returns_table()
  local items = cmd_history.get()
  lu.assertEquals(type(items), 'table')
end

function TestCmdHistory:test_get_empty_when_no_history()
  local items = cmd_history.get()
  lu.assertEquals(#items, 0)
end

function TestCmdHistory:test_get_returns_items_after_cmd()
  vim.fn.histadd('cmd', 'echo hello')
  local items = cmd_history.get()
  lu.assertEquals(#items, 1)
  lu.assertEquals(items[1].str, 'echo hello')
end

function TestCmdHistory:test_get_returns_multiple_items()
  vim.fn.histadd('cmd', 'echo one')
  vim.fn.histadd('cmd', 'echo two')
  vim.fn.histadd('cmd', 'echo three')
  local items = cmd_history.get()
  lu.assertEquals(#items, 3)
  -- Items should be in reverse order (newest first)
  lu.assertEquals(items[1].str, 'echo three')
  lu.assertEquals(items[2].str, 'echo two')
  lu.assertEquals(items[3].str, 'echo one')
end

function TestCmdHistory:test_get_item_has_value_table()
  vim.fn.histadd('cmd', 'echo test')
  local items = cmd_history.get()
  lu.assertNotNil(items[1].value)
  lu.assertEquals(items[1].value.cmd, 'echo test')
  lu.assertNotNil(items[1].value.index)
end

function TestCmdHistory:test_actions_returns_table()
  local actions = cmd_history.actions()
  lu.assertEquals(type(actions), 'table')
end

function TestCmdHistory:test_actions_has_delete_key()
  local actions = cmd_history.actions()
  lu.assertNotNil(actions['<C-d>'])
end

function TestCmdHistory:test_actions_delete_removes_entry()
  vim.fn.histadd('cmd', 'echo todelete')
  local items = cmd_history.get()
  lu.assertEquals(#items, 1)
  local index = items[1].value.index
  -- Delete the entry
  local actions = cmd_history.actions()
  actions['<C-d>'](items[1])
  -- Verify it's deleted
  local remaining = cmd_history.get()
  lu.assertEquals(#remaining, 0)
end

return TestCmdHistory

