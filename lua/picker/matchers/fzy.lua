local M = {}

--- 计算fzy匹配得分
--- @param needle string 输入字符串
--- @param haystack string 候选字符串
--- @return number 得分，越大表示匹配越好，-math.huge表示不匹配
function M.score(needle, haystack)
  if needle == "" or haystack == "" then return 0 end
  if #needle > #haystack then return -math.huge end

  local score = 0
  local n_pos = 1
  local consecutive = 0
  
  for h_pos = 1, #haystack do
    if n_pos > #needle then break end
    
    if needle:sub(n_pos, n_pos) == haystack:sub(h_pos, h_pos) then
      score = score + 1
      consecutive = consecutive + 1
      score = score + consecutive * 0.1 -- 连续匹配加分
      if h_pos == 1 then score = score + 0.5 end -- 首字母匹配加分
      n_pos = n_pos + 1
    else
      consecutive = 0
    end
  end
  
  if n_pos <= #needle then return -math.huge end -- 未完全匹配
  score = score - (#haystack - #needle) * 0.05 -- 长度惩罚
  return score
end

return M
