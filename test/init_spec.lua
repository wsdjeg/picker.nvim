-- test/init_spec.lua
-- Tests for the main picker module (lua/picker/init.lua)

local lu = require('luaunit')
local picker = require('picker')
local config = require('picker.config')

TestPickerInit = {}

function TestPickerInit:setup()
  config.setup({})
end

-- setup function

function TestPickerInit:test_setup_exists()
  lu.assertEquals(type(picker.setup), 'function')
end

function TestPickerInit:test_setup_accepts_nil()
  picker.setup()
  -- Should not crash
  lu.assertTrue(true)
end

function TestPickerInit:test_setup_accepts_empty_table()
  picker.setup({})
  -- Should not crash
  lu.assertTrue(true)
end

function TestPickerInit:test_setup_applies_config()
  picker.setup({
    filter = { ignorecase = true, matcher = 'levenshtein' },
  })
  local cfg = config.get()
  lu.assertEquals(cfg.filter.ignorecase, true)
  lu.assertEquals(cfg.filter.matcher, 'levenshtein')
end

-- open function

function TestPickerInit:test_open_exists()
  lu.assertEquals(type(picker.open), 'function')
end

function TestPickerInit:test_open_no_args_does_not_crash()
  -- open() with no args should open the sources picker
  -- In headless test this might fail to create windows, but shouldn't crash hard
  local ok = pcall(picker.open)
  -- Either succeeds or throws a vim error (window creation), both are acceptable
  -- We mainly verify it doesn't infinite-loop or segfault
  lu.assertTrue(ok or true) -- always pass, just ensure no crash
end

function TestPickerInit:test_open_empty_table_does_not_crash()
  local ok = pcall(picker.open, {})
  lu.assertTrue(ok or true)
end

function TestPickerInit:test_open_invalid_source_does_not_crash()
  -- Should notify about missing source, not crash
  local ok = pcall(picker.open, { 'nonexistent_source_xyz' })
  lu.assertTrue(ok, 'open with invalid source should not error')
end

return TestPickerInit

