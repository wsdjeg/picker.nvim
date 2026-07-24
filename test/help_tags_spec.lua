-- test/help_tags_spec.lua
-- Tests for the help_tags picker source

local lu = require('luaunit')
local help_tags = require('picker.sources.help_tags')

TestHelpTags = {}

function TestHelpTags:test_get_returns_table()
  local items = help_tags.get()
  lu.assertEquals(type(items), 'table')
end

function TestHelpTags:test_get_returns_non_empty()
  -- Neovim runtime should always have help tags
  local items = help_tags.get()
  lu.assertTrue(#items > 0, 'should find help tags in runtime')
end

function TestHelpTags:test_get_item_has_str()
  local items = help_tags.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestHelpTags:test_get_item_has_value()
  local items = help_tags.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertNotNil(item.value.name)
    lu.assertNotNil(item.value.filename)
    break
  end
end

function TestHelpTags:test_get_item_value_name_matches_str()
  local items = help_tags.get()
  for _, item in ipairs(items) do
    lu.assertEquals(item.value.name, item.str)
    break
  end
end

function TestHelpTags:test_get_contains_known_help_tag()
  -- 'vim' is a common help tag in Neovim
  local items = help_tags.get()
  local found = false
  for _, item in ipairs(items) do
    if item.str == 'vim' or item.str == 'help' or item.str == 'intro' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'should find a known help tag like vim/help/intro')
end

function TestHelpTags:test_get_item_filename_is_readable()
  local items = help_tags.get()
  for _, item in ipairs(items) do
    -- At least one item should have a readable filename
    if vim.fn.filereadable(item.value.filename) == 1 then
      lu.assertTrue(true)
      return
    end
  end
  lu.assertTrue(false, 'at least one help file should be readable')
end

function TestHelpTags:test_preview_win_is_true()
  lu.assertTrue(help_tags.preview_win)
end

function TestHelpTags:test_has_default_action()
  lu.assertNotNil(help_tags.default_action)
  lu.assertEquals(type(help_tags.default_action), 'function')
end

return TestHelpTags

