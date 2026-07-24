-- test/matchers_init_spec.lua
-- Tests for the matchers base module (lua/picker/matchers/init.lua)

local lu = require('luaunit')
local matchers = require('picker.matchers')

TestMatchersInit = {}

-- has_match tests (shared pre-filter)

function TestMatchersInit:test_has_match_simple()
  lu.assertTrue(matchers.has_match('abc', 'abcdef'))
end

function TestMatchersInit:test_has_match_subsequence()
  lu.assertTrue(matchers.has_match('acf', 'abcdef'))
end

function TestMatchersInit:test_has_match_no_match()
  lu.assertFalse(matchers.has_match('xyz', 'abcdef'))
end

function TestMatchersInit:test_has_match_empty_needle()
  lu.assertTrue(matchers.has_match('', 'abcdef'))
end

function TestMatchersInit:test_has_match_empty_haystack()
  lu.assertFalse(matchers.has_match('a', ''))
end

function TestMatchersInit:test_has_match_both_empty()
  lu.assertTrue(matchers.has_match('', ''))
end

function TestMatchersInit:test_has_match_case_insensitive_default()
  lu.assertTrue(matchers.has_match('ABC', 'abcdef'))
  lu.assertTrue(matchers.has_match('abc', 'ABCDEF'))
end

function TestMatchersInit:test_has_match_case_sensitive()
  lu.assertFalse(matchers.has_match('ABC', 'abcdef', true))
  lu.assertTrue(matchers.has_match('ABC', 'ABCdef', true))
end

function TestMatchersInit:test_has_match_needle_longer_than_haystack()
  lu.assertFalse(matchers.has_match('abcdefg', 'abc'))
end

function TestMatchersInit:test_has_match_single_char()
  lu.assertTrue(matchers.has_match('a', 'abc'))
  lu.assertFalse(matchers.has_match('z', 'abc'))
end

function TestMatchersInit:test_has_match_exact_match()
  lu.assertTrue(matchers.has_match('abc', 'abc'))
end

function TestMatchersInit:test_has_match_duplicate_chars()
  -- 'aa' should match 'aba' (subsequence)
  lu.assertTrue(matchers.has_match('aa', 'aba'))
  lu.assertFalse(matchers.has_match('aaa', 'aba'))
end

function TestMatchersInit:test_has_match_special_chars()
  lu.assertTrue(matchers.has_match('a.b', 'a.test.b'))
  lu.assertTrue(matchers.has_match('/usr', '/usr/local/bin'))
end

-- load tests

function TestMatchersInit:test_load_fzy()
  local matcher = matchers.load('fzy')
  lu.assertNotNil(matcher)
  lu.assertEquals(type(matcher.positions), 'function')
end

function TestMatchersInit:test_load_levenshtein()
  local matcher = matchers.load('levenshtein')
  lu.assertNotNil(matcher)
  lu.assertEquals(type(matcher.positions), 'function')
end

function TestMatchersInit:test_load_matchfuzzy()
  local matcher = matchers.load('matchfuzzy')
  lu.assertNotNil(matcher)
  lu.assertEquals(type(matcher.positions), 'function')
end

function TestMatchersInit:test_load_unknown_falls_back_to_fzy()
  local matcher = matchers.load('nonexistent_matcher')
  lu.assertNotNil(matcher)
  lu.assertEquals(type(matcher.positions), 'function')
  -- Should fall back to fzy
  lu.assertNotNil(matcher.get_implementation_name)
end

function TestMatchersInit:test_load_returns_module_with_has_match()
  local matcher = matchers.load('fzy')
  lu.assertEquals(type(matcher.has_match), 'function')
end

function TestMatchersInit:test_load_returns_module_with_score()
  local matcher = matchers.load('fzy')
  lu.assertEquals(type(matcher.score), 'function')
end

-- has_ffi field

function TestMatchersInit:test_has_ffi_is_boolean()
  lu.assertEquals(type(matchers.has_ffi), 'boolean')
end

return TestMatchersInit

