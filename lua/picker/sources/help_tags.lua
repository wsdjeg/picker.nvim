local M = {}

local previewer = require("picker.previewer.file")
function M.get()
	local tags = {}

	local rtp = vim.o.runtimepath

	local ok, plug = pcall(require, "plug")

	if ok then
		for _, p in pairs(plug.get()) do
			if not p.loaded and p.rtp then
				rtp = rtp .. "," .. p.rtp
			end
		end
	end
	local all_tags_files = vim.fn.globpath(rtp, "doc/tags", 1, 1)

	local delimiter = string.char(9)
	for _, tag_file in ipairs(all_tags_files) do
		local fd = vim.uv.fs_open(tag_file, "r", 438)
		local stat = vim.uv.fs_fstat(fd)
		local context = vim.split(vim.uv.fs_read(fd, stat.size, 0), "[\r]?\n", { trimempty = true })
		vim.uv.fs_close(fd)
		for _, line in ipairs(context) do
			local fields = vim.split(line, delimiter, { trimempty = true })
			if #fields == 3 then
				table.insert(tags, {
					name = fields[1],
					filename = vim.fn.fnamemodify(tag_file, ":h") .. '/' .. fields[2],
					pattern = string.sub(fields[3], 2),
				})
			end
		end
	end

	return vim.tbl_map(function(t)
		return {
			value = t,
			str = t.name,
		}
	end, tags)
end

function M.default_action(entry)
	vim.cmd("help " .. entry.value.name)
end

M.preview_win = true

function M.preview(item, win, buf)
	previewer.preview(item.value.filename, win, buf, { pattern = item.value.pattern, syntax = 'help' })
end

return M
