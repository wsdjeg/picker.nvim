-- cmd = ctags --lua-kinds=f --output-format=json --fields=+line  plugins.lua

local M = {}

local bufnr

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
local cmd = { "ctags", "--lua-kinds=f", "--output-format=json", "--fields=+line" }

---@return table<PickerItem>
function M.get() 
    return vim.split(vim.system(cmd, {text = true}):wait().stdout, "\n", {trimempty = true})
end

---@param selected PickerItem
function M.default_action(selected) end

M.preview_win = false

function M.preview(item, win, buf) end

return M
