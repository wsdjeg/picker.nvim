-- Based on: https://github.com/swarn
-- Modifications:
-- 1. filter returns each item's candidate string as the 4th element
-- 2. FFI acceleration for compute() when available (double[] instead of table[][])
-- 3. Uses shared has_match and FFI detection from matchers base module
--
-- The lua implementation of the fzy string matching algorithm

local base = require('picker.matchers')

local SCORE_GAP_LEADING = -0.005
local SCORE_GAP_TRAILING = -0.005
local SCORE_GAP_INNER = -0.01
local SCORE_MATCH_CONSECUTIVE = 1.0
local SCORE_MATCH_SLASH = 0.9
local SCORE_MATCH_WORD = 0.8
local SCORE_MATCH_CAPITAL = 0.7
local SCORE_MATCH_DOT = 0.6
local SCORE_MAX = math.huge
local SCORE_MIN = -math.huge
local MATCH_MAX_LENGTH = 1024

-- Use FFI detection from the base module (shared across all matchers)
local has_ffi = base.has_ffi
local ffi = base.ffi

---@class Pickers.Matchers.Fzy
local fzy = {}

-- Use the shared has_match from the base module
fzy.has_match = base.has_match

-- ============ Lua table implementation (fallback) ============

---@param c string
local function is_lower(c)
  return string.match(c, '%l')
end

---@param c string
local function is_upper(c)
  return string.match(c, '%u')
end

---@param haystack string
---@return table<integer, number> match_bonus
local function precompute_bonus(haystack)
  local match_bonus = {} ---@type table<integer, number>
  local last_char = '/'
  for i = 1, string.len(haystack) do
    local this_char = string.sub(haystack, i, i)
    if last_char == '/' or last_char == '\\' then
      match_bonus[i] = SCORE_MATCH_SLASH
    elseif last_char == '-' or last_char == '_' or last_char == ' ' then
      match_bonus[i] = SCORE_MATCH_WORD
    elseif last_char == '.' then
      match_bonus[i] = SCORE_MATCH_DOT
    elseif is_lower(last_char) and is_upper(this_char) then
      match_bonus[i] = SCORE_MATCH_CAPITAL
    else
      match_bonus[i] = 0
    end

    last_char = this_char
  end

  return match_bonus
end

---@param needle string
---@param haystack string
---@param D number[][]
---@param M number[][]
---@param case_sensitive? boolean
local function compute(needle, haystack, D, M, case_sensitive)
  -- Note that the match bonuses must be computed before the arguments are
  -- converted to lowercase, since there are bonuses for camelCase.
  local match_bonus = precompute_bonus(haystack)
  local n = string.len(needle)
  local m = string.len(haystack)

  if not case_sensitive then
    needle = string.lower(needle)
    haystack = string.lower(haystack)
  end

  -- Because lua only grants access to chars through substring extraction,
  -- get all the characters from the haystack once now, to reuse below.
  local haystack_chars = {}
  for i = 1, m do
    haystack_chars[i] = string.sub(haystack, i, i)
  end

  for i = 1, n do
    D[i] = {}
    M[i] = {}

    local prev_score = SCORE_MIN
    local gap_score = i == n and SCORE_GAP_TRAILING or SCORE_GAP_INNER
    local needle_char = string.sub(needle, i, i)

    for j = 1, m do
      if needle_char == haystack_chars[j] then
        local score = SCORE_MIN
        if i == 1 then
          score = ((j - 1) * SCORE_GAP_LEADING) + match_bonus[j]
        elseif j > 1 then
          local a = M[i - 1][j - 1] + match_bonus[j]
          local b = D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE
          score = math.max(a, b)
        end
        D[i][j] = score
        prev_score = math.max(score, prev_score + gap_score)
        M[i][j] = prev_score
      else
        D[i][j] = SCORE_MIN
        prev_score = prev_score + gap_score
        M[i][j] = prev_score
      end
    end
  end
end

--- Lua table version of score
---@param needle string
---@param haystack string
---@param case_sensitive? boolean
---@return number score
local function score_lua(needle, haystack, case_sensitive)
  local n, m = string.len(needle), string.len(haystack)

  if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > m then
    return SCORE_MIN
  end
  if n == m then
    return SCORE_MAX
  end

  local D, M = {}, {} ---@type number[][], number[][]
  compute(needle, haystack, D, M, case_sensitive)
  return M[n][m]
end

--- Lua table version of positions
---@param needle string
---@param haystack string
---@param case_sensitive? boolean
---@return table<integer, integer> positions
---@return number score
local function positions_lua(needle, haystack, case_sensitive)
  local n, m = string.len(needle), string.len(haystack)

  if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > m then
    return {}, SCORE_MIN
  end
  if n == m then
    local consecutive = {}
    for i = 1, n do
      consecutive[i] = i
    end
    return consecutive, SCORE_MAX
  end

  local D, M = {}, {} ---@type number[][], number[][]
  compute(needle, haystack, D, M, case_sensitive)

  local positions = {} ---@type table<integer, integer>
  local match_required = false
  local j = m
  for i = n, 1, -1 do
    while j >= 1 do
      if D[i][j] ~= SCORE_MIN and (match_required or D[i][j] == M[i][j]) then
        match_required = i ~= 1
          and (j ~= 1)
          and (M[i][j] == D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE)
        positions[i] = j
        j = j - 1
        break
      end

      j = j - 1
    end
  end

  return positions, M[n][m]
end

-- ============ FFI implementation (accelerated) ============

local score_ffi, positions_ffi

if has_ffi then
  --- Byte-level helpers (faster than string.match for ASCII)
  ---@param b integer byte value
  ---@return boolean
  local function is_lower_byte(b)
    return b >= 97 and b <= 122 -- 'a' to 'z'
  end

  ---@param b integer byte value
  ---@return boolean
  local function is_upper_byte(b)
    return b >= 65 and b <= 90 -- 'A' to 'Z'
  end

  --- Compute DP matrices using FFI flat arrays
  --- D and M are double[n*m], 0-indexed: D[(i-1)*m + (j-1)] = D[i][j]
  ---@param needle string
  ---@param haystack string
  ---@param case_sensitive? boolean
  ---@return userdata D flat double[n*m] array
  ---@return userdata M flat double[n*m] array
  ---@return integer n
  ---@return integer m
  local function compute_ffi(needle, haystack, case_sensitive)
    local n = string.len(needle)
    local m = string.len(haystack)

    -- Bonus array (0-indexed, m elements)
    local bonus = ffi.new('double[?]', m)
    local last_byte = 47 -- '/' (ASCII 47)
    for i = 0, m - 1 do
      local b = string.byte(haystack, i + 1)
      if last_byte == 47 or last_byte == 92 then -- '/' or '\'
        bonus[i] = SCORE_MATCH_SLASH
      elseif last_byte == 45 or last_byte == 95 or last_byte == 32 then -- '-', '_', ' '
        bonus[i] = SCORE_MATCH_WORD
      elseif last_byte == 46 then -- '.'
        bonus[i] = SCORE_MATCH_DOT
      elseif is_lower_byte(last_byte) and is_upper_byte(b) then
        bonus[i] = SCORE_MATCH_CAPITAL
      else
        bonus[i] = 0
      end
      last_byte = b
    end

    if not case_sensitive then
      needle = string.lower(needle)
      haystack = string.lower(haystack)
    end

    -- Pre-extract haystack bytes into FFI array (uint8_t for unsigned)
    local hbytes = ffi.new('uint8_t[?]', m + 1)
    ffi.copy(hbytes, haystack)

    -- Flat DP matrices (0-indexed)
    local D = ffi.new('double[?]', n * m)
    local M = ffi.new('double[?]', n * m)

    for i = 1, n do
      local needle_byte = string.byte(needle, i)
      local prev_score = SCORE_MIN
      local gap_score = (i == n) and SCORE_GAP_TRAILING or SCORE_GAP_INNER
      local row_offset = (i - 1) * m

      for j = 1, m do
        local idx = row_offset + (j - 1)
        if needle_byte == hbytes[j - 1] then
          local score_val = SCORE_MIN
          if i == 1 then
            score_val = ((j - 1) * SCORE_GAP_LEADING) + bonus[j - 1]
          elseif j > 1 then
            local prev_idx = (i - 2) * m + (j - 2)
            local a = M[prev_idx] + bonus[j - 1]
            local b = D[prev_idx] + SCORE_MATCH_CONSECUTIVE
            score_val = math.max(a, b)
          end
          D[idx] = score_val
          prev_score = math.max(score_val, prev_score + gap_score)
          M[idx] = prev_score
        else
          D[idx] = SCORE_MIN
          prev_score = prev_score + gap_score
          M[idx] = prev_score
        end
      end
    end

    return D, M, n, m
  end

  score_ffi = function(needle, haystack, case_sensitive)
    local n, m = string.len(needle), string.len(haystack)

    if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > m then
      return SCORE_MIN
    end
    if n == m then
      return SCORE_MAX
    end

    local _, M = compute_ffi(needle, haystack, case_sensitive)
    return M[(n - 1) * m + (m - 1)]
  end

  positions_ffi = function(needle, haystack, case_sensitive)
    local n, m = string.len(needle), string.len(haystack)

    if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > m then
      return {}, SCORE_MIN
    end
    if n == m then
      local consecutive = {}
      for i = 1, n do
        consecutive[i] = i
      end
      return consecutive, SCORE_MAX
    end

    local D, M = compute_ffi(needle, haystack, case_sensitive)

    local positions = {} ---@type table<integer, integer>
    local match_required = false
    local j = m
    for i = n, 1, -1 do
      while j >= 1 do
        local idx = (i - 1) * m + (j - 1)
        if D[idx] ~= SCORE_MIN and (match_required or D[idx] == M[idx]) then
          -- Only access D[prev_idx] when i > 1 and j > 1 (short-circuit)
          local prev_idx = (i - 2) * m + (j - 2)
          match_required = i ~= 1
            and (j ~= 1)
            and (M[idx] == D[prev_idx] + SCORE_MATCH_CONSECUTIVE)
          positions[i] = j
          j = j - 1
          break
        end

        j = j - 1
      end
    end

    return positions, M[(n - 1) * m + (m - 1)]
  end
end

-- ============ Public API ============

-- Choose implementation at load time based on FFI availability
fzy.score = has_ffi and score_ffi or score_lua
fzy.positions = has_ffi and positions_ffi or positions_lua

-- Apply `has_match` and `positions` to an array of haystacks.
---@param needle string
---@param haystacks string[]
---@param case_sensitive? boolean
---@return { [1]: integer, [2]: table<integer, integer>, [3]: number, [4]: string }[]
function fzy.filter(needle, haystacks, case_sensitive)
  ---@type { [1]: integer, [2]: table<integer, integer>, [3]: number, [4]: string }[]
  local result = {}
  for i, line in ipairs(haystacks) do
    if fzy.has_match(needle, line, case_sensitive) then
      local p, s = fzy.positions(needle, line, case_sensitive)
      table.insert(result, { i, p, s, line })
    end
  end

  return result
end

---@return number SCORE_MIN
function fzy.get_score_min()
  return SCORE_MIN
end

---@return number SCORE_MAX
function fzy.get_score_max()
  return SCORE_MAX
end

---@return integer MATCH_MAX_LENGTH
function fzy.get_max_length()
  return MATCH_MAX_LENGTH
end

---@return number floor
function fzy.get_score_floor()
  return MATCH_MAX_LENGTH * SCORE_GAP_INNER
end

---@return number ceiling
function fzy.get_score_ceiling()
  return MATCH_MAX_LENGTH * SCORE_MATCH_CONSECUTIVE
end

-- The name of the currently-running implementation, "ffi" or "lua".
---@return 'ffi'|'lua' implementation
function fzy.get_implementation_name()
  return has_ffi and 'ffi' or 'lua'
end

return fzy

