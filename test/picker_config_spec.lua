-- test/picker_config_spec.lua
-- Tests for the picker_config source (configuration shortcuts)

local lu = require('luaunit')
local picker_config = require('picker.sources.picker_config')
local config = require('picker.config')

TestPickerConfig = {}

function TestPickerConfig:setup()
  config.setup({})
end

function TestPickerConfig:test_get_returns_table()
  local items = picker_config.get()
  lu.assertEquals(type(items), 'table')
end

function TestPickerConfig:test_get_returns_non_empty()
  local items = picker_config.get()
  lu.assertTrue(#items > 0)
end

function TestPickerConfig:test_get_item_has_str()
  local items = picker_config.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.str)
    lu.assertEquals(type(item.str), 'string')
    lu.assertTrue(#item.str > 0)
    break
  end
end

function TestPickerConfig:test_get_item_has_value()
  local items = picker_config.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.value)
    lu.assertNotNil(item.value.name)
    lu.assertNotNil(item.value.desc)
    lu.assertNotNil(item.value.func)
    break
  end
end

function TestPickerConfig:test_get_item_has_highlight()
  local items = picker_config.get()
  for _, item in ipairs(items) do
    lu.assertNotNil(item.highlight)
    lu.assertEquals(type(item.highlight), 'table')
    break
  end
end

function TestPickerConfig:test_get_contains_prompt_top()
  local items = picker_config.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'prompt-top' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'prompt-top config should be in results')
end

function TestPickerConfig:test_get_contains_prompt_bottom()
  local items = picker_config.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'prompt-bottom' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'prompt-bottom config should be in results')
end

function TestPickerConfig:test_get_contains_matcher_fzy()
  local items = picker_config.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'matcher-fzy' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'matcher-fzy config should be in results')
end

function TestPickerConfig:test_get_contains_matcher_levenshtein()
  local items = picker_config.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'matcher-levenshtein' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'matcher-levenshtein config should be in results')
end

function TestPickerConfig:test_get_contains_ignorecase()
  local items = picker_config.get()
  local found = false
  for _, item in ipairs(items) do
    if item.value.name == 'ignorecase' then
      found = true
      break
    end
  end
  lu.assertTrue(found, 'ignorecase config should be in results')
end

function TestPickerConfig:test_default_action_runs_func()
  local items = picker_config.get()
  -- Find prompt-top and run its action
  for _, item in ipairs(items) do
    if item.value.name == 'prompt-top' then
      picker_config.default_action(item)
      local cfg = config.get()
      lu.assertEquals(cfg.prompt.position, 'top')
      -- Reset
      config.setup({})
      return
    end
  end
  lu.assertTrue(false, 'prompt-top not found')
end

function TestPickerConfig:test_default_action_matcher_levenshtein()
  local items = picker_config.get()
  for _, item in ipairs(items) do
    if item.value.name == 'matcher-levenshtein' then
      picker_config.default_action(item)
      local cfg = config.get()
      lu.assertEquals(cfg.filter.matcher, 'levenshtein')
      -- Reset
      config.setup({})
      return
    end
  end
  lu.assertTrue(false, 'matcher-levenshtein not found')
end

return TestPickerConfig

