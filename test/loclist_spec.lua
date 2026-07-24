-- test/loclist_spec.lua
-- Tests for the loclist picker source

local lu = require('luaunit')
local loclist = require('picker.sources.loclist')

TestLoclist = {}

function TestLoclist:setup()
  -- Clear location list
  vim.fn.setloclist(0, {})
  -- Create a test buffer with content
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, 'test_loclist_file.lua')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    'local x = 1',
    'local y = 2',
    'local z = 3',
  })
  -- Add entries to location list
  vim.fn.setloclist(0, {
    { bufnr = buf, lnum = 1, text = 'local x = 1' },
    { bufnr = buf, lnum = 2, text = 'local y = 2' },
  })
end

function TestLoclist:teardown()
  vim.fn.setloclist(0, {})
  -- Clean up test buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match('test_loclist_file') then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function TestLoclist:test_get_returns_table()
  local items = loclist.get()
  lu.assertEquals(type(items), 'table')
end

function TestLoclist:test_get_returns_loclist_entries()
  local items = loclist.get()
  lu.assertEquals(#items, 2)
end

function TestLoclist:test_get_item_has_str()
  local items = loclist.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestLoclist:test_get_item_str_contains_shortname()
  local items = loclist.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str:match('test_loclist_file') then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'str should contain short name')
end

function TestLoclist:test_get_item_str_contains_line_number()
  local items = loclist.get()
  lu.assertNotNil(items[1].str:match(':1:'), 'str should contain line number 1')
  lu.assertNotNil(items[2].str:match(':2:'), 'str should contain line number 2')
end

function TestLoclist:test_get_item_has_value()
  local items = loclist.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertNotNil(item.value.lnum)
    lu.assertNotNil(item.value.text)
    lu.assertNotNil(item.value.shortname)
    break
  end
end

function TestLoclist:test_get_item_has_highlight()
  local items = loclist.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.highlight)
    lu.assertEquals(type(item.highlight), 'table')
    break
  end
end

function TestLoclist:test_get_empty_loclist()
  vim.fn.setloclist(0, {})
  local items = loclist.get()
  lu.assertEquals(#items, 0)
end

function TestLoclist:test_preview_win_is_true()
  lu.assertTrue(loclist.preview_win)
end

function TestLoclist:test_has_default_action()
  lu.assertNotNil(loclist.default_action)
  lu.assertEquals(type(loclist.default_action), 'function')
end

return TestLoclist

