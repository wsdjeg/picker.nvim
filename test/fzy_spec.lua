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
  local word_match = fzy.score('ba', 'foo_bar')
  local inner_match = fzy.score('oo', 'foo_bar')
  lu.assertTrue(word_match > inner_match)
end

function TestFzy:test_score_slash_bonus()
  local slash_match = fzy.score('ba', 'foo/bar')
  local inner_match = fzy.score('oo', 'foo/bar')
  lu.assertTrue(slash_match > inner_match)
end

-- filter tests

function TestFzy:test_filter_basic()
  local haystacks = { 'apple', 'banana', 'cherry', 'apricot' }
  local results = fzy.filter('ap', haystacks)
  lu.assertEquals(#results, 2)
  lu.assertEquals(results[1][1], 1)
  lu.assertEquals(results[1][4], 'apple')
  lu.assertEquals(results[2][1], 4)
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
  local name = fzy.get_implementation_name()
  lu.assertTrue(name == 'ffi' or name == 'lua',
    'implementation name should be "ffi" or "lua", got: ' .. tostring(name))
end

-- FFI consistency: score and positions should work correctly
-- regardless of which implementation is active

function TestFzy:test_score_and_positions_consistency()
  -- Test multiple patterns to ensure FFI and Lua paths produce same results
  local test_cases = {
    { needle = 'abc', haystack = 'abcdef' },
    { needle = 'acf', haystack = 'abcdef' },
    { needle = 'ap', haystack = 'apple' },
    { needle = 'ba', haystack = 'foo/bar' },
    { needle = 'ba', haystack = 'foo_bar' },
    { needle = 'abc', haystack = 'ABC' },
    { needle = 'ABC', haystack = 'abcdef' },
    { needle = 'test', haystack = 'src/test/file.lua' },
    { needle = 'fz', haystack = 'fzy.lua' },
  }

  for _, tc in ipairs(test_cases) do
    local s = fzy.score(tc.needle, tc.haystack)
    local p, s2 = fzy.positions(tc.needle, tc.haystack)
    -- score from score() and positions() should match
    lu.assertEquals(s, s2,
      string.format('score mismatch for %q in %q: %g vs %g',
        tc.needle, tc.haystack, s, s2))
    -- positions should have correct length
    if s ~= -math.huge and s ~= math.huge then
      lu.assertEquals(#p, #tc.needle,
        string.format('positions length mismatch for %q in %q',
          tc.needle, tc.haystack))
    end
  end
end

function TestFzy:test_positions_camelcase_bonus()
  -- camelCase boundary should get bonus
  local positions, score = fzy.positions('B', 'fooBar')
  -- 'B' is at position 4 in 'fooBar'
  lu.assertEquals(positions, { 4 })
end

function TestFzy:test_positions_dot_bonus()
  -- dot boundary should get bonus
  local positions, score = fzy.positions('f', 'foo.bar')
  -- First 'f' at position 1
  lu.assertEquals(positions, { 1 })
end

return TestFzy

