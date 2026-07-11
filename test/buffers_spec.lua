-- test/buffers_spec.lua
-- Tests for the buffers picker source

local lu = require('luaunit')
local buffers = require('picker.sources.buffers')

TestBuffers = {}

function TestBuffers:setup()
  -- Delete all buffers except current
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.fn.buflisted(buf) == 1 then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function TestBuffers:test_get_returns_table()
  local items = buffers.get()
  lu.assertEquals(type(items), 'table')
end

function TestBuffers:test_get_returns_listed_buffers()
  -- At least the current buffer should be listed
  local items = buffers.get()
  lu.assertTrue(#items >= 1)
end

function TestBuffers:test_get_item_has_str()
  local items = buffers.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    break
  end
end

function TestBuffers:test_get_item_has_bufnr()
  local items = buffers.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.bufnr)
    lu.assertEquals(type(item.bufnr), 'number')
    break
  end
end

function TestBuffers:test_get_includes_new_buffer()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, 'test_buffer.txt')
  local items = buffers.get()
  local found = false
  for _, item in ipairs(items) do
    if item.bufnr == buf then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'new buffer should be in results')
  vim.api.nvim_buf_delete(buf, { force = true })
end

function TestBuffers:test_get_excludes_unlisted_buffer()
  local buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_name(buf, 'unlisted_buffer.txt')
  local items = buffers.get()
  local found = false
  for _, item in ipairs(items) do
    if item.bufnr == buf then
      found = true
      break
    end
  end
  lu.assertFalse(found, 'unlisted buffer should not be in results')
  vim.api.nvim_buf_delete(buf, { force = true })
end

function TestBuffers:test_actions_returns_table()
  local actions = buffers.actions()
  lu.assertEquals(type(actions), 'table')
end

function TestBuffers:test_actions_has_vertical_split()
  local actions = buffers.actions()
  lu.assertNotNil(actions['<C-v>'])
end

function TestBuffers:test_actions_has_tab_split()
  local actions = buffers.actions()
  lu.assertNotNil(actions['<C-t>'])
end

function TestBuffers:test_preview_win_is_true()
  lu.assertTrue(buffers.preview_win)
end

return TestBuffers

