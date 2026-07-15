-- test/example_spec.lua
-- Example test file demonstrating luaunit test structure

local lu = require('luaunit')

TestExample = {}

function TestExample:test_setup()
  lu.assertNotNil(require('picker'))
end

function TestExample:test_config_defaults()
  local config = require('picker.config')
  lu.assertNotNil(config)
end

function TestExample:test_simple_assertion()
  lu.assertEquals(1 + 1, 2)
end

return TestExample

