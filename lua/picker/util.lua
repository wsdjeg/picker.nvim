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

local kinds = {}
for k, v in pairs(vim.lsp.protocol.SymbolKind) do
	if type(v) == "number" then
		kinds[v] = k
	end
end
function M.symbol_kind(kind)
	return kinds[kind]
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
