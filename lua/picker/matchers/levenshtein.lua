--- Levenshtein编辑距离算法实现
local M = {}

--- 计算Levenshtein距离并转换为得分
--- @param needle string 输入字符串
--- @param haystack string 候选字符串
--- @return number 得分，负值表示距离，值越大（越接近0）匹配越好
function M.score(needle, haystack)
  if needle == "" or haystack == "" then return 0 end
  
  local n, h = #needle, #haystack
  local matrix = {}
  
  -- 初始化矩阵
  for i = 0, n do
    matrix[i] = {}
    for j = 0, h do
      if i == 0 then
        matrix[i][j] = j
      elseif j == 0 then
        matrix[i][j] = i
      else
        matrix[i][j] = 0
      end
    end
  end
  
  -- 填充矩阵
  for i = 1, n do
    for j = 1, h do
      if needle:sub(i, i) == haystack:sub(j, j) then
        matrix[i][j] = matrix[i-1][j-1]
      else
        matrix[i][j] = math.min(
          matrix[i-1][j] + 1,   -- 删除
          matrix[i][j-1] + 1,   -- 插入
          matrix[i-1][j-1] + 1  -- 替换
        )
      end
    end
  end
  
  return -matrix[n][h] -- 负距离作为得分
end

return M
