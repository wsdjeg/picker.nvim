-- cmd = ctags --lua-kinds=f --output-format=json --fields=+line  plugins.lua

local M = {}
local opts = {}
local previewer = require("picker.previewer.buffer")

-- from: https://github.com/fcying/telescope-ctags-outline.nvim/blob/master/lua/ctags-outline/init.lua#L7C1-L34C6
local ft_opt = {
	aspvbs = "--asp-kinds=f",
	awk = "--awk-kinds=f",
	c = "--c-kinds=fp",
	cpp = "--c++-kinds=fp --language-force=C++",
	cs = "--c#-kinds=m",
	erlang = "--erlang-kinds=f",
	fortran = "--fortran-kinds=f",
	java = "--java-kinds=m",
	lisp = "--lisp-kinds=f",
	lua = "--lua-kinds=f",
	matla = "--matlab-kinds=f",
	pascal = "--pascal-kinds=f",
	php = "--php-kinds=f",
	python = "--python-kinds=fm --language-force=Python",
	ruby = "--ruby-kinds=fF",
	scheme = "--scheme-kinds=f",
	sh = "--sh-kinds=f",
	sql = "--sql-kinds=f",
	tcl = "--tcl-kinds=m",
	verilog = "--verilog-kinds=f",
	vim = "--vim-kinds=f",
	-- universal ctags
	javascript = "--javascript-kinds=f",
	go = "--go-kinds=f",
	rust = "--rust-kinds=fPM",
	ocaml = "--ocaml-kinds=mf",
}

---@return table<PickerItem>
function M.get()
	local bufnr = opts.current_buf
    previewer.buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    previewer.filetype = ft
	local cmd = { "ctags" }

	if ft_opt[ft] then
		table.insert(cmd, ft_opt[ft])
	end

	table.insert(cmd, "--output-format=json")
	table.insert(cmd, "--fields=+line")
	table.insert(cmd, bufname)

	---@class PickerCtagsOutput
	---@field name
	---@field line
	---@field _type
	---@field path
	---@field pattern
	---@field language
	---@field line
	---@field kind

	---@type table<PickerCtagsOutput>
	local ctags_output = vim.split(vim.system(cmd, { text = true }):wait().stdout, "\n", { trimempty = true })

	---@type table<PickerItem>
	local items = {}

	for _, v in ipairs(ctags_output) do
		local value = vim.json.decode(v)
		table.insert(items, {
			value = value,
			str = value.name,
		})
	end

	return items
end

---@param selected PickerItem
function M.default_action(selected)
	vim.cmd(tostring(selected.value.line))
end

function M.set(opt)
	opts.current_buf = opt.buf
end

M.preview_win = true

function M.preview(item, win, buf)
	previewer.preview(item.value.line, win, buf)
end

return M
