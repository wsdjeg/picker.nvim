local M = {}

local util = require("picker.util")
local previewer = require("picker.previewer.file")
local items = {}

function M.get()
	return items
end

---@param entry PickerItem
function M.default_action(entry)
    vim.cmd.edit(vim.uri_to_fname(entry.value.location.uri))
	vim.api.nvim_win_set_cursor(0, { entry.value.location.range.start.line + 1, entry.value.location.range.start.character })
end

function M.set(opt)
	local bufnr = opt.buf
	local client = vim.lsp.get_clients({ bufnr = bufnr })[1]
	if not client then
		return
	end
	local params = { query = "" }

	items = {}

	client:request(util.feature_map.workspace_symbols, params, function(err, result, ctx, ...)
		if not result or err then
			return
		end

		-- {
		--   kind = 13,
		--   location = {
		--     range = {
		--       ["end"] = {
		--         character = 27,
		--         line = 4257
		--       },
		--       start = {
		--         character = 9,
		--         line = 4257
		--       }
		--     },
		--     uri = "file:///d%3A/Scoop/apps/neovim/current/share/nvim/runtime/lua/vim/_meta/vimfn.lua"
		--   },
		--   name = "vim.fn.highlightID"
		-- }

		for _, symbol in ipairs(result) do
			table.insert(items, {
				value = symbol,
				str = string.format("[%s] %s", util.symbol_kind(symbol.kind), symbol.name),
				highlight = {
					{ 0, #util.symbol_kind(symbol.kind) + 2, "Comment" },
				},
			})
		end
		vim.cmd("doautocmd TextChangedI")
	end, bufnr)
end

M.preview_win = true

function M.preview(item, win, buf)
	local filename = vim.uri_to_fname(item.value.location.uri)
	local line = item.value.location.range.start.line
	previewer.preview(filename, win, buf, { lnum = line + 1, syntax = vim.filetype.match({ filename = filename }) })
end

return M
