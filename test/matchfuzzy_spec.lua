-- test/matchfuzzy_spec.lua
-- Tests for the matchfuzzy matcher (wraps vim.fn.matchfuzzypos)

local lu = require('luaunit')
local matchfuzzy = require('picker.matchers.matchfuzzy')

TestMatchfuzzy = {}

-- has_match tests

function TestMatchfuzzy:test_has_match_simple()
  lu.assertTrue(matchfuzzy.has_match('abc', 'abcdef'))
end

function TestMatchfuzzy:test_has_match_subsequence()
  lu.assertTrue(matchfuzzy.has_match('acf', 'abcdef'))
end

function TestMatchfuzzy:test_has_match_no_match()
  lu.assertFalse(matchfuzzy.has_match('xyz', 'abcdef'))
end

function TestMatchfuzzy:test_has_match_empty_needle()
  lu.assertTrue(matchfuzzy.has_match('', 'abcdef'))
end

function TestMatchfuzzy:test_has_match_case_insensitive()
  lu.assertTrue(matchfuzzy.has_match('ABC', 'abcdef'))
  lu.assertTrue(matchfuzzy.has_match('abc', 'ABCDEF'))
end

function TestMatchfuzzy:test_has_match_case_sensitive()
  lu.assertFalse(matchfuzzy.has_match('ABC', 'abcdef', true))
  lu.assertTrue(matchfuzzy.has_match('ABC', 'ABCdef', true))
end

function TestMatchfuzzy:test_has_match_needle_longer_than_haystack()
  lu.assertFalse(matchfuzzy.has_match('abcdefg', 'abc'))
end

-- positions tests

function TestMatchfuzzy:test_positions_exact_match()
  local positions = matchfuzzy.positions('abc', 'abc')
  lu.assertEquals(positions, { 1, 2, 3 })
end

function TestMatchfuzzy:test_positions_subsequence()
  local positions = matchfuzzy.positions('acf', 'abcdef')
  lu.assertEquals(positions, { 1, 3, 6 })
end

function TestMatchfuzzy:test_positions_case_insensitive()
  local positions = matchfuzzy.positions('ABC', 'abcdef')
  lu.assertEquals(positions, { 1, 2, 3 })
end

function TestMatchfuzzy:test_positions_case_sensitive()
  local positions = matchfuzzy.positions('ABC', 'ABCdef', true)
  lu.assertEquals(positions, { 1, 2, 3 })
end

function TestMatchfuzzy:test_positions_single_char()
  local positions = matchfuzzy.positions('x', 'xyz')
  lu.assertEquals(positions, { 1 })
end

function TestMatchfuzzy:test_positions_returns_table()
  local positions = matchfuzzy.positions('ap', 'apple')
  lu.assertNotNil(positions)
  lu.assertEquals(type(positions), 'table')
  lu.assertTrue(#positions > 0)
end

return TestMatchfuzzy

