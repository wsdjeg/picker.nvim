local M = {}
local previewer = require("picker.previewer.buffer")

local configs = {
	{
		name = "prompt-top",
		desc = "change the prompt position to top",
		func = function()
			require("picker").setup({
				prompt = {
					position = "top", --- bottom or top
				},
			})
		end,
	},
	{
		name = "prompt-bottom",
		desc = "change the prompt position to bottom",
		func = function()
			require("picker").setup({
				prompt = {
					position = "bottom", --- bottom or top
				},
			})
		end,
	},
}

---@return table<PickerItem>
function M.get()
	return vim.tbl_map(function(t)
		return {
			str = string.format("%s -> %s", t.name, t.desc),
			value = t,
            highlight = {
                {0, #t.name, 'TODO'},
                {#t.name, #t.name + 4, 'Comment'},
                {#t.name + 4, #t.name + #t.desc + 4, 'String'}
            }
		}
	end, configs)
end

---@param entry PickerItem
function M.default_action(entry)
	entry.value.func()
end

return M
