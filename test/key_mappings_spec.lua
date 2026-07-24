-- test/key_mappings_spec.lua
-- Tests for the key-mappings picker source

local lu = require('luaunit')
local keymaps = require('picker.sources.key-mappings')

TestKeyMappings = {}

function TestKeyMappings:test_get_returns_table()
  local items = keymaps.get()
  lu.assertEquals(type(items), 'table')
end

function TestKeyMappings:test_get_returns_non_empty()
  -- Neovim always has some default keymaps
  local items = keymaps.get()
  lu.assertTrue(#items > 0)
end

function TestKeyMappings:test_get_item_has_str()
  local items = keymaps.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    break
  end
end

function TestKeyMappings:test_get_item_has_value()
  local items = keymaps.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    -- value is a keymap table with lhs, rhs, etc.
    lu.assertNotNil(item.value.lhs)
    break
  end
end

function TestKeyMappings:test_get_includes_custom_mapping()
  -- Add a test keymap
  vim.keymap.set('n', '<F15>', function() end, { desc = 'test_mapping_desc' })
  local items = keymaps.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.desc == 'test_mapping_desc' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'custom mapping should be in results')
  -- Cleanup
  vim.keymap.del('n', '<F15>')
end

function TestKeyMappings:test_get_item_str_contains_desc()
  vim.keymap.set('n', '<F16>', function() end, { desc = 'test_desc_xyz' })
  local items = keymaps.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str:match('test_desc_xyz') then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'str should contain description')
  vim.keymap.del('n', '<F16>')
end

function TestKeyMappings:test_preview_win_is_true()
  lu.assertTrue(keymaps.preview_win)
end

function TestKeyMappings:test_has_default_action()
  lu.assertNotNil(keymaps.default_action)
  lu.assertEquals(type(keymaps.default_action), 'function')
end

return TestKeyMappings

