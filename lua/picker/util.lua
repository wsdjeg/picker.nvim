local M = {}

local nt
local log

function M.notify(msg)
	if not nt then
		pcall(function()
			nt = require("notify")
		end)
	end
	if not nt then
		return
	end
	nt.notify(msg)
end

function M.info(msg)
	if not log then
		pcall(function()
			log = require("logger").derive("picker")
		end)
	end
	if not log then
		return
	end
	log.info(msg)
end

local kind_icons = {
	Array = " ",
	Boolean = "󰨙 ",
	Class = " ",
	Color = " ",
	Control = " ",
	Collapsed = " ",
	Constant = "󰏿 ",
	Constructor = " ",
	Copilot = " ",
	Enum = " ",
	EnumMember = " ",
	Event = " ",
	Field = " ",
	File = " ",
	Folder = " ",
	Function = "󰊕 ",
	Interface = " ",
	Key = " ",
	Keyword = " ",
	Method = "󰊕 ",
	Module = " ",
	Namespace = "󰦮 ",
	Null = " ",
	Number = "󰎠 ",
	Object = " ",
	Operator = " ",
	Package = " ",
	Property = " ",
	Reference = " ",
	Snippet = "󱄽 ",
	String = " ",
	Struct = "󰆼 ",
	Text = " ",
	TypeParameter = " ",
	Unit = " ",
	Unknown = " ",
	Value = " ",
	Variable = "󰀫 ",
}

local kinds = {}
for k, v in pairs(vim.lsp.protocol.SymbolKind) do
	if type(v) == "number" then
		kinds[v] = k
	end
end
function M.symbol_kind(kind)
	return kind_icons[kinds[kind]] or kinds[kind]
end
M.feature_map = {
	document_symbols = "textDocument/documentSymbol",
	references = "textDocument/references",
	definitions = "textDocument/definition",
	type_definitions = "textDocument/typeDefinition",
	implementations = "textDocument/implementation",
	workspace_symbols = "workspace/symbol",
	incoming_calls = "callHierarchy/incomingCalls",
	outgoing_calls = "callHierarchy/outgoingCalls",
}

return M
