local lv = require('picker.matchers.levenshtein')
local fzy = require('picker.matchers.fzy')

local give = {'abc', 'bluyer', 'acssd'}
local input = 'c'

for _, v in ipairs(give) do print(lv.score(input, v)) end
for _, v in ipairs(give) do print(fzy.score(input, v)) end

table.sort(give, function(a, b)
    return fzy.score(input, a) > fzy.score(input, b)
end)

vim.print(vim.tbl_filter(function(t)
    return fzy.score(input, t) ~= -math.huge
end, give))
vim.print(give)

local a, b = fzy.score('ac', 'abc')
vim.print(a)
vim.print(b)
