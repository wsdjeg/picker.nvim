--- Levenshtein编辑距离算法实现
local M = {}

function M.has_match(needle, haystack, case_sensitive)
    if not case_sensitive then
        needle = string.lower(needle)
        haystack = string.lower(haystack)
    end

    local j = 1
    for i = 1, string.len(needle) do
        j = string.find(haystack, needle:sub(i, i), j, true)
        if not j then
            return false
        else
            j = j + 1
        end
    end

    return true
end

--- 计算Levenshtein距离并转换为得分
--- @param needle string 输入字符串
--- @param haystack string 候选字符串
function M.positions(needle, haystack, case_sensitive)
    if not case_sensitive then
        needle = string.lower(needle)
        haystack = string.lower(haystack)
    end
    local n, m = #needle, #haystack
    if n == 0 or m == 0 then
        return 0, {}, { 0, 0 }
    end

    -- full DP matrix for backtracking
    local dp = {}
    for i = 0, n do
        dp[i] = {}
        dp[i][0] = i
    end
    for j = 0, m do
        dp[0][j] = j
    end

    -- fill
    for i = 1, n do
        for j = 1, m do
            local cost = (needle:sub(i, i) == haystack:sub(j, j)) and 0 or 1
            dp[i][j] = math.min(
                dp[i - 1][j] + 1, -- delete
                dp[i][j - 1] + 1, -- insert
                dp[i - 1][j - 1] + cost -- replace or match
            )
        end
    end

    local dist = dp[n][m]

    --------------------------------------------------------------------
    -- Backtrack to recover positions
    --------------------------------------------------------------------
    local positions = {}
    local i, j = n, m

    while i > 0 and j > 0 do
        local cost = (needle:sub(i, i) == haystack:sub(j, j)) and 0 or 1

        if dp[i][j] == dp[i - 1][j - 1] + cost then
            -- match or replace
            if cost == 0 then
                table.insert(positions, 1, j) -- record matched position
            end
            i, j = i - 1, j - 1
        elseif dp[i][j] == dp[i - 1][j] + 1 then
            -- delete
            i = i - 1
        else
            -- insert
            j = j - 1
        end
    end

    return positions, -dist
end

return M
