-- test/fzy_spec.lua
-- Tests for the fzy matcher algorithm

local lu = require('luaunit')
local fzy = require('picker.matchers.fzy')

TestFzy = {}

-- has_match tests

function TestFzy:test_has_match_simple()
  lu.assertTrue(fzy.has_match('abc', 'abcdef'))
end

function TestFzy:test_has_match_subsequence()
  lu.assertTrue(fzy.has_match('acf', 'abcdef'))
end

function TestFzy:test_has_match_no_match()
  lu.assertFalse(fzy.has_match('xyz', 'abcdef'))
end

function TestFzy:test_has_match_empty_needle()
  lu.assertTrue(fzy.has_match('', 'abcdef'))
end

function TestFzy:test_has_match_case_insensitive()
  lu.assertTrue(fzy.has_match('ABC', 'abcdef'))
  lu.assertTrue(fzy.has_match('abc', 'ABCDEF'))
end

function TestFzy:test_has_match_case_sensitive()
  lu.assertFalse(fzy.has_match('ABC', 'abcdef', true))
  lu.assertTrue(fzy.has_match('ABC', 'ABCdef', true))
end

function TestFzy:test_has_match_needle_longer_than_haystack()
  lu.assertFalse(fzy.has_match('abcdefg', 'abc'))
end

-- positions tests

function TestFzy:test_positions_exact_match()
  local positions, score = fzy.positions('abc', 'abc')
  lu.assertEquals(positions, { 1, 2, 3 })
  lu.assertEquals(score, math.huge)
end

function TestFzy:test_positions_subsequence()
  local positions, score = fzy.positions('acf', 'abcdef')
  lu.assertEquals(positions, { 1, 3, 6 })
  lu.assertTrue(score > 0)
end

function TestFzy:test_positions_empty_needle()
  local positions, score = fzy.positions('', 'abcdef')
  lu.assertEquals(positions, {})
  lu.assertEquals(score, -math.huge)
end

function TestFzy:test_positions_empty_haystack()
  local positions, score = fzy.positions('abc', '')
  lu.assertEquals(positions, {})
  lu.assertEquals(score, -math.huge)
end

function TestFzy:test_positions_needle_longer_than_haystack()
  local positions, score = fzy.positions('abcdef', 'abc')
  lu.assertEquals(positions, {})
  lu.assertEquals(score, -math.huge)
end

-- score tests

function TestFzy:test_score_exact_match_is_max()
  local score = fzy.score('abc', 'abc')
  lu.assertEquals(score, math.huge)
end

function TestFzy:test_score_needle_longer_than_haystack_is_min()
  -- fzy.score assumes needle is a subsequence of haystack
  -- When needle is longer, it returns SCORE_MIN
  local score = fzy.score('abcdefg', 'abc')
  lu.assertEquals(score, -math.huge)
end

function TestFzy:test_score_empty_needle_is_min()
  local score = fzy.score('', 'abc')
  lu.assertEquals(score, -math.huge)
end

function TestFzy:test_score_empty_haystack_is_min()
  local score = fzy.score('abc', '')
  lu.assertEquals(score, -math.huge)
end

function TestFzy:test_score_consecutive_better_than_scattered()
  local consecutive = fzy.score('abc', 'abcdef')
  local scattered = fzy.score('acf', 'abcdef')
  lu.assertTrue(consecutive > scattered)
end

function TestFzy:test_score_word_boundary_bonus()
  -- Matching at word boundaries should score higher
  local word_match = fzy.score('ba', 'foo_bar')
  local inner_match = fzy.score('oo', 'foo_bar')
  lu.assertTrue(word_match > inner_match)
end

function TestFzy:test_score_slash_bonus()
  -- Matching after a slash should score higher
  local slash_match = fzy.score('ba', 'foo/bar')
  local inner_match = fzy.score('oo', 'foo/bar')
  lu.assertTrue(slash_match > inner_match)
end

-- filter tests

function TestFzy:test_filter_basic()
  local haystacks = { 'apple', 'banana', 'cherry', 'apricot' }
  local results = fzy.filter('ap', haystacks)
  -- Should match 'apple' and 'apricot'
  lu.assertEquals(#results, 2)
  lu.assertEquals(results[1][1], 1) -- index of 'apple'
  lu.assertEquals(results[1][4], 'apple')
  lu.assertEquals(results[2][1], 4) -- index of 'apricot'
  lu.assertEquals(results[2][4], 'apricot')
end

function TestFzy:test_filter_no_matches()
  local haystacks = { 'apple', 'banana' }
  local results = fzy.filter('xyz', haystacks)
  lu.assertEquals(#results, 0)
end

function TestFzy:test_filter_empty_needle_matches_all()
  local haystacks = { 'apple', 'banana' }
  local results = fzy.filter('', haystacks)
  lu.assertEquals(#results, 2)
end

-- utility functions

function TestFzy:test_get_score_min()
  lu.assertEquals(fzy.get_score_min(), -math.huge)
end

function TestFzy:test_get_score_max()
  lu.assertEquals(fzy.get_score_max(), math.huge)
end

function TestFzy:test_get_max_length()
  lu.assertEquals(fzy.get_max_length(), 1024)
end

function TestFzy:test_get_implementation_name()
  lu.assertEquals(fzy.get_implementation_name(), 'lua')
end

return TestFzy

