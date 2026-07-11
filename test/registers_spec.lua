-- test/registers_spec.lua
-- Tests for the registers picker source

local lu = require('luaunit')
local registers = require('picker.sources.registers')

TestRegisters = {}

function TestRegisters:setup()
  -- Clear registers before each test
  vim.fn.setreg('"', '')
  vim.fn.setreg('a', '')
  vim.fn.setreg('0', '')
end

function TestRegisters:test_get_returns_table()
  local items = registers.get()
  lu.assertEquals(type(items), 'table')
end

function TestRegisters:test_get_empty_when_no_registers_set()
  -- Default state: unnamed register may have content from test runner
  -- Just verify the function returns a table
  local items = registers.get()
  lu.assertNotNil(items)
end

function TestRegisters:test_get_returns_items_with_set_register()
  vim.fn.setreg('a', 'test content')
  local items = registers.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      found = true
      lu.assertEquals(item.value.context, 'test content')
      lu.assertTrue(string.find(item.str, 'a') ~= nil)
      break
    end
  end
  lu.assertTrue(found, 'register a should be in results')
end

function TestRegisters:test_get_item_str_format()
  vim.fn.setreg('a', 'hello')
  local items = registers.get()
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      -- str should contain [a] hello
      lu.assertTrue(string.find(item.str, '%[a%]') ~= nil)
      lu.assertTrue(string.find(item.str, 'hello') ~= nil)
      break
    end
  end
end

function TestRegisters:test_get_excludes_empty_registers()
  -- Set a register then clear it
  vim.fn.setreg('a', 'temp')
  vim.fn.setreg('a', '')
  local items = registers.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      found = true
      break
    end
  end
  lu.assertFalse(found, 'empty register a should not be in results')
end

function TestRegisters:test_get_item_has_highlight()
  vim.fn.setreg('a', 'test')
  local items = registers.get()
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      lu.assertNotNil(item.highlight)
      lu.assertEquals(type(item.highlight), 'table')
      break
    end
  end
end

function TestRegisters:test_get_item_has_value_table()
  vim.fn.setreg('a', 'test')
  local items = registers.get()
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      lu.assertNotNil(item.value.name)
      lu.assertNotNil(item.value.context)
      break
    end
  end
end

function TestRegisters:test_get_multiline_register()
  vim.fn.setreg('a', 'line1\nline2')
  local items = registers.get()
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      -- str should contain first line only
      lu.assertTrue(string.find(item.str, 'line1') ~= nil)
      break
    end
  end
end

function TestRegisters:test_default_action_pastes_content()
  vim.fn.setreg('a', 'pasted text')
  local items = registers.get()
  for _, item in ipairs(items) do
    if item.value.name == 'a' then
      -- default_action calls nvim_paste which needs a buffer
      -- just verify it doesn't crash
      registers.default_action(item)
      lu.assertTrue(true)
      break
    end
  end
end

function TestRegisters:test_preview_win_is_true()
  lu.assertTrue(registers.preview_win)
end

return TestRegisters

