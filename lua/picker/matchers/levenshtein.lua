--- Levenshtein edit distance matcher.
--- Scores candidates by edit distance — fewer edits means a better match.
--- Uses the shared has_match pre-filter from the base module.

local base = require('picker.matchers')

local M = {}

-- Use the shared has_match from the base module
M.has_match = base.has_match

--- Compute Levenshtein distance and return matched positions with score.
---@param needle string Input string
---@param haystack string Candidate string
---@param case_sensitive? boolean
---@return table<integer, integer> positions Matched positions in haystack
---@return number score Negative edit distance (higher is better)
function M.positions(needle, haystack, case_sensitive)
  if not case_sensitive then
    needle = string.lower(needle)
    haystack = string.lower(haystack)
  end
  local n, m = #needle, #haystack
  if n == 0 or m == 0 then
    return {}, 0
  end

  -- Full DP matrix for backtracking
  local dp = {}
  for i = 0, n do
    dp[i] = {}
    dp[i][0] = i
  end
  for j = 0, m do
    dp[0][j] = j
  end

  -- Fill DP matrix
  for i = 1, n do
    for j = 1, m do
      local cost = string.sub(needle, i, i) == string.sub(haystack, j, j)
          and 0
        or 1
      dp[i][j] = math.min(
        dp[i - 1][j] + 1, -- delete
        dp[i][j - 1] + 1, -- insert
        dp[i - 1][j - 1] + cost -- replace or match
      )
    end
  end

  local dist = dp[n][m]

  -- Backtrack to recover matched positions
  local positions = {}
  local i, j = n, m

  while i > 0 and j > 0 do
    local cost = string.sub(needle, i, i) == string.sub(haystack, j, j) and 0
      or 1

    if dp[i][j] == dp[i - 1][j - 1] + cost then
      -- Match or replace
      if cost == 0 then
        table.insert(positions, 1, j)
      end
      i, j = i - 1, j - 1
    elseif dp[i][j] == dp[i - 1][j] + 1 then
      -- Delete
      i = i - 1
    else
      -- Insert
      j = j - 1
    end
  end

  return positions, -dist
end

--- The name of the currently-running implementation.
--- Always 'lua' since this is a pure Lua implementation.
---@return 'lua' implementation
function M.get_implementation_name()
  return 'lua'
end

return M

