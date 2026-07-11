-- test/util_spec.lua
-- Tests for picker.util module

local lu = require('luaunit')
local util = require('picker.util')

TestUtil = {}

-- symbol_kind tests

function TestUtil:test_symbol_kind_known_kind()
  -- SymbolKind.Function = 12
  local result = util.symbol_kind(12)
  lu.assertNotNil(result)
  lu.assertEquals(type(result), 'string')
end

function TestUtil:test_symbol_kind_class()
  -- SymbolKind.Class = 5
  local result = util.symbol_kind(5)
  lu.assertNotNil(result)
end

function TestUtil:test_symbol_kind_module()
  -- SymbolKind.Module = 2
  local result = util.symbol_kind(2)
  lu.assertNotNil(result)
end

function TestUtil:test_symbol_kind_unknown_returns_kind_name()
  -- Use a kind number that exists in SymbolKind but may not have an icon
  -- SymbolKind.Boolean = 10
  local result = util.symbol_kind(10)
  lu.assertNotNil(result)
end

-- feature_map tests

function TestUtil:test_feature_map_has_document_symbols()
  lu.assertEquals(util.feature_map.document_symbols, 'textDocument/documentSymbol')
end

function TestUtil:test_feature_map_has_references()
  lu.assertEquals(util.feature_map.references, 'textDocument/references')
end

function TestUtil:test_feature_map_has_definitions()
  lu.assertEquals(util.feature_map.definitions, 'textDocument/definition')
end

function TestUtil:test_feature_map_has_type_definitions()
  lu.assertEquals(util.feature_map.type_definitions, 'textDocument/typeDefinition')
end

function TestUtil:test_feature_map_has_implementations()
  lu.assertEquals(util.feature_map.implementations, 'textDocument/implementation')
end

function TestUtil:test_feature_map_has_workspace_symbols()
  lu.assertEquals(util.feature_map.workspace_symbols, 'workspace/symbol')
end

function TestUtil:test_feature_map_has_declarations()
  lu.assertEquals(util.feature_map.declarations, 'textDocument/declaration')
end

function TestUtil:test_feature_map_has_incoming_calls()
  lu.assertEquals(util.feature_map.incoming_calls, 'callHierarchy/incomingCalls')
end

function TestUtil:test_feature_map_has_outgoing_calls()
  lu.assertEquals(util.feature_map.outgoing_calls, 'callHierarchy/outgoingCalls')
end

function TestUtil:test_feature_map_is_table()
  lu.assertEquals(type(util.feature_map), 'table')
end

-- notify/info tests (should not crash without external modules)

function TestUtil:test_notify_does_not_crash()
  -- notify requires 'notify' module which may not be installed
  -- should silently return without error
  util.notify('test message')
  lu.assertTrue(true) -- if we reach here, no crash
end

function TestUtil:test_info_does_not_crash()
  -- info requires 'logger' module which may not be installed
  -- should silently return without error
  util.info('test message')
  lu.assertTrue(true)
end

return TestUtil

