--- Picker Matcher Base Module
--- Provides shared utilities and a unified loader for all matcher implementations.
---
--- Each matcher module under `picker.matchers.*` should implement the
--- PickerMatcher interface (see types.lua). This base module extracts the
--- common `has_match` pre-filter and FFI detection so individual matchers
--- don't duplicate them.
---
--- To create a custom matcher:
---   1. Create `lua/picker/matchers/my_matcher.lua`
---   2. Implement `positions()` and `get_implementation_name()`
---   3. Optionally implement `score()`, `filter()`, score helpers
---   4. Use `base.has_match` for the pre-filter (or override with your own)
---   5. Set `config.filter.matcher = 'my_matcher'`
local M = {}

--- Check FFI availability at load time (shared across all matchers).
--- Matchers can use this to decide between FFI and pure-Lua implementations.
M.has_ffi, M.ffi = pcall(require, 'ffi')

--- Check if `needle` is a subsequence of the `haystack`.
--- This is the common pre-filter used by all matchers before calling
--- the more expensive `positions()` function.
---
---@param needle string The search query
---@param haystack string The candidate string to search in
---@param case_sensitive? boolean Whether matching is case sensitive
---@return boolean match True if needle is a subsequence of haystack
function M.has_match(needle, haystack, case_sensitive)
  if not case_sensitive then
    needle = string.lower(needle)
    haystack = string.lower(haystack)
  end

  local j = 1
  for i = 1, string.len(needle) do
    j = string.find(haystack, string.sub(needle, i, i), j, true)
    if not j then
      return false
    end
    j = j + 1
  end

  return true
end

--- Load a matcher module by name.
--- Falls back to the built-in `fzy` matcher if the requested one is
--- missing or doesn't implement the required `positions()` function.
---
---@param name string Matcher name (e.g. 'fzy', 'matchfuzzy', 'levenshtein')
---@return PickerMatcher matcher The loaded matcher module
function M.load(name)
  local ok, matcher = pcall(require, 'picker.matchers.' .. name)
  if not ok or type(matcher.positions) ~= 'function' then
    matcher = require('picker.matchers.fzy')
  end
  return matcher
end

return M

