-- use neovim's matchfuzzy and matchfuzzypos function
local matchfuzzy = {}

function matchfuzzy.has_match(needle, haystack, case_sensitive)
  if not case_sensitive then
    needle = string.lower(needle)
    haystack = string.lower(haystack)
  end

  local j = 1
  for i = 1, string.len(needle) do
    j = string.find(haystack, string.sub(needle, i, i), j, true)
    if not j then
      return false
    else
      j = j + 1
    end
  end

  return true
end

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

return matchfuzzy
