-- Uses Neovim's built-in matchfuzzy and matchfuzzypos function.
-- This matcher delegates to vim.fn for matching logic but still uses
-- the shared has_match pre-filter from the base module for consistency.

local base = require('picker.matchers')

local matchfuzzy = {}

-- Use the shared has_match from the base module
matchfuzzy.has_match = base.has_match

--- Find match positions using vim.fn.matchfuzzypos.
---@param needle string
---@param haystack string
---@param case_sensitive? boolean
---@return table<integer, integer> positions
---@return number score
function matchfuzzy.positions(needle, haystack, case_sensitive)
  if not case_sensitive then
    needle = string.lower(needle)
    haystack = string.lower(haystack)
  end
  local _, positions, scopes =
    unpack(vim.fn.matchfuzzypos({ haystack }, needle, { matchseq = true }))
  return vim.tbl_map(function(t)
    return vim.fn.byteidx(haystack, t) + 1
  end, positions[1]),
    scopes[1]
end

--- The name of the currently-running implementation.
--- Always 'vim' since this matcher uses Neovim's built-in matchfuzzypos.
---@return 'vim' implementation
function matchfuzzy.get_implementation_name()
  return 'vim'
end

return matchfuzzy

