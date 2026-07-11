-- test/config_spec.lua
-- Tests for picker.config module

local lu = require('luaunit')
local config = require('picker.config')

TestConfig = {}

function TestConfig:setup()
  -- Reset to defaults before each test
  config.setup({})
end

function TestConfig:test_get_returns_default_config()
  local cfg = config.get()
  lu.assertNotNil(cfg)
  lu.assertEquals(cfg.filter.ignorecase, false)
  lu.assertEquals(cfg.filter.matcher, 'fzy')
end

function TestConfig:test_default_window_values()
  local cfg = config.get()
  lu.assertEquals(cfg.window.layout, 'default')
  lu.assertEquals(cfg.window.width, 0.8)
  lu.assertEquals(cfg.window.height, 0.8)
  lu.assertEquals(cfg.window.border, 'rounded')
  lu.assertEquals(cfg.window.current_icon, '>')
  lu.assertEquals(cfg.window.enable_preview, false)
end

function TestConfig:test_default_mappings()
  local cfg = config.get()
  lu.assertEquals(cfg.mappings.close, '<Esc>')
  lu.assertEquals(cfg.mappings.next_item, '<Tab>')
  lu.assertEquals(cfg.mappings.previous_item, '<S-Tab>')
  lu.assertEquals(cfg.mappings.open_item, '<Enter>')
  lu.assertEquals(cfg.mappings.toggle_preview, '<C-p>')
end

function TestConfig:test_default_prompt()
  local cfg = config.get()
  lu.assertEquals(cfg.prompt.position, 'bottom')
  lu.assertEquals(cfg.prompt.icon, '>')
  lu.assertEquals(cfg.prompt.title, true)
end

function TestConfig:test_default_highlight()
  local cfg = config.get()
  lu.assertEquals(cfg.highlight.matched, 'Tag')
  lu.assertEquals(cfg.highlight.score, 'Comment')
end

function TestConfig:test_setup_overrides_filter()
  config.setup({
    filter = {
      ignorecase = true,
      matcher = 'levenshtein',
    },
  })
  local cfg = config.get()
  lu.assertEquals(cfg.filter.ignorecase, true)
  lu.assertEquals(cfg.filter.matcher, 'levenshtein')
end

function TestConfig:test_setup_overrides_window()
  config.setup({
    window = {
      width = 0.5,
      height = 0.6,
    },
  })
  local cfg = config.get()
  lu.assertEquals(cfg.window.width, 0.5)
  lu.assertEquals(cfg.window.height, 0.6)
  -- Unchanged values should keep defaults
  lu.assertEquals(cfg.window.border, 'rounded')
end

function TestConfig:test_setup_deep_merge()
  config.setup({
    window = {
      width = 1.0,
    },
    prompt = {
      icon = '$',
    },
  })
  local cfg = config.get()
  -- window.width overridden
  lu.assertEquals(cfg.window.width, 1.0)
  -- window.height keeps default
  lu.assertEquals(cfg.window.height, 0.8)
  -- prompt.icon overridden
  lu.assertEquals(cfg.prompt.icon, '$')
  -- prompt.position keeps default
  lu.assertEquals(cfg.prompt.position, 'bottom')
end

function TestConfig:test_setup_empty_table_preserves_current()
  -- setup({}) does NOT reset to defaults - it merges with current config
  -- Set a known value, then call setup({}), value should persist
  config.setup({ filter = { matcher = 'levenshtein' } })
  config.setup({})
  local cfg = config.get()
  lu.assertEquals(cfg.filter.matcher, 'levenshtein')
end

return TestConfig

