-- test/qflist_spec.lua
-- Tests for the qflist picker source

local lu = require('luaunit')
local qflist = require('picker.sources.qflist')

TestQfList = {}

function TestQfList:setup()
  -- Clear quickfix list
  vim.fn.setqflist({})
  -- Create a test buffer with content
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, 'test_qflist_file.lua')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    'local x = 1',
    'local y = 2',
    'local z = 3',
  })
  -- Add entries to quickfix list
  vim.fn.setqflist({
    { bufnr = buf, lnum = 1, text = 'local x = 1' },
    { bufnr = buf, lnum = 2, text = 'local y = 2' },
  })
end

function TestQfList:teardown()
  vim.fn.setqflist({})
  -- Clean up test buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match('test_qflist_file') then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function TestQfList:test_get_returns_table()
  local items = qflist.get()
  lu.assertEquals(type(items), 'table')
end

function TestQfList:test_get_returns_qflist_entries()
  local items = qflist.get()
  lu.assertEquals(#items, 2)
end

function TestQfList:test_get_item_has_str()
  local items = qflist.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestQfList:test_get_item_str_contains_filename()
  local items = qflist.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str:match('test_qflist_file') then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'str should contain filename')
end

function TestQfList:test_get_item_str_contains_line_number()
  local items = qflist.get()
  lu.assertNotNil(items[1].str:match(':1:'), 'str should contain line number 1')
  lu.assertNotNil(items[2].str:match(':2:'), 'str should contain line number 2')
end

function TestQfList:test_get_item_has_value()
  local items = qflist.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertNotNil(item.value.lnum)
    lu.assertNotNil(item.value.text)
    break
  end
end

function TestQfList:test_get_item_has_highlight()
  local items = qflist.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.highlight)
    lu.assertEquals(type(item.highlight), 'table')
    break
  end
end

function TestQfList:test_get_empty_qflist()
  vim.fn.setqflist({})
  local items = qflist.get()
  lu.assertEquals(#items, 0)
end

function TestQfList:test_preview_win_is_true()
  lu.assertTrue(qflist.preview_win)
end

function TestQfList:test_has_default_action()
  lu.assertNotNil(qflist.default_action)
  lu.assertEquals(type(qflist.default_action), 'function')
end

return TestQfList

