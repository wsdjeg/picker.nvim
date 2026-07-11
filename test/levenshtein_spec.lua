-- test/levenshtein_spec.lua
-- Tests for the levenshtein matcher algorithm

local lu = require('luaunit')
local levenshtein = require('picker.matchers.levenshtein')

TestLevenshtein = {}

-- has_match tests

function TestLevenshtein:test_has_match_simple()
  lu.assertTrue(levenshtein.has_match('abc', 'abcdef'))
end

function TestLevenshtein:test_has_match_subsequence()
  lu.assertTrue(levenshtein.has_match('acf', 'abcdef'))
end

function TestLevenshtein:test_has_match_no_match()
  lu.assertFalse(levenshtein.has_match('xyz', 'abcdef'))
end

function TestLevenshtein:test_has_match_empty_needle()
  lu.assertTrue(levenshtein.has_match('', 'abcdef'))
end

function TestLevenshtein:test_has_match_case_insensitive()
  lu.assertTrue(levenshtein.has_match('ABC', 'abcdef'))
  lu.assertTrue(levenshtein.has_match('abc', 'ABCDEF'))
end

function TestLevenshtein:test_has_match_case_sensitive()
  lu.assertFalse(levenshtein.has_match('ABC', 'abcdef', true))
  lu.assertTrue(levenshtein.has_match('ABC', 'ABCdef', true))
end

function TestLevenshtein:test_has_match_needle_longer_than_haystack()
  lu.assertFalse(levenshtein.has_match('abcdefg', 'abc'))
end

-- positions tests

function TestLevenshtein:test_positions_exact_match()
  local positions, score = levenshtein.positions('abc', 'abc')
  lu.assertEquals(positions, { 1, 2, 3 })
  lu.assertEquals(score, 0) -- distance 0, negated
end

function TestLevenshtein:test_positions_subsequence()
  local positions, score = levenshtein.positions('acf', 'abcdef')
  lu.assertEquals(positions, { 1, 3, 6 })
  -- Levenshtein distance between 'acf' and 'abcdef' is 3 (insert b, d, e)
  lu.assertEquals(score, -3)
end

function TestLevenshtein:test_positions_empty_needle()
  -- Edge case: returns 0, {}, {0, 0} (different from normal signature)
  local positions, score = levenshtein.positions('', 'abcdef')
  lu.assertEquals(positions, 0)
  lu.assertEquals(score, {})
end

function TestLevenshtein:test_positions_empty_haystack()
  -- Edge case: returns 0, {}, {0, 0} (different from normal signature)
  local positions, score = levenshtein.positions('abc', '')
  lu.assertEquals(positions, 0)
  lu.assertEquals(score, {})
end

function TestLevenshtein:test_positions_with_insertions()
  -- 'ac' in 'abc' -> positions {1, 3}, distance 1 (insert 'b')
  local positions, score = levenshtein.positions('ac', 'abc')
  lu.assertEquals(positions, { 1, 3 })
  lu.assertEquals(score, -1)
end

function TestLevenshtein:test_positions_with_deletions()
  -- 'abcd' in 'abc' -> distance 1 (delete 'd')
  local positions, score = levenshtein.positions('abcd', 'abc')
  lu.assertEquals(positions, { 1, 2, 3 })
  lu.assertEquals(score, -1)
end

function TestLevenshtein:test_positions_case_insensitive()
  local positions, score = levenshtein.positions('ABC', 'abcdef')
  lu.assertEquals(positions, { 1, 2, 3 })
  -- After lowercasing: 'abc' vs 'abcdef', distance is 3 (insert d, e, f)
  lu.assertEquals(score, -3)
end

function TestLevenshtein:test_positions_case_sensitive()
  local positions, score = levenshtein.positions('ABC', 'abcdef', true)
  -- No character matches with case sensitivity
  -- Levenshtein distance is 6 (3 substitutions + 3 insertions)
  lu.assertEquals(positions, {})
  lu.assertEquals(score, -6)
end

function TestLevenshtein:test_positions_single_char()
  local positions, score = levenshtein.positions('x', 'xyz')
  lu.assertEquals(positions, { 1 })
  -- Levenshtein distance between 'x' and 'xyz' is 2 (insert y, z)
  lu.assertEquals(score, -2)
end

function TestLevenshtein:test_positions_completely_different()
  local positions, score = levenshtein.positions('xyz', 'abc')
  lu.assertEquals(positions, {}) -- no exact matches
  lu.assertEquals(score, -3) -- distance 3 (3 substitutions)
end

return TestLevenshtein

