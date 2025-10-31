# picker.nvim

picker.nvim is a highly customizable and extensible Neovim fuzzy finder plugin written in lua.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/picker.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/picker.nvim)](https://github.com/wsdjeg/picker.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/picker.nvim)](https://github.com/wsdjeg/picker.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/picker.nvim)](https://github.com/wsdjeg/picker.nvim/releases)

![picker-neovim](https://wsdjeg.net/images/picker-neovim.png)

<!-- vim-markdown-toc GFM -->

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
    - [Picker Command](#picker-command)
    - [Key bindings](#key-bindings)
- [Builtin sources](#builtin-sources)
    - [files](#files)
    - [cmd_history](#cmd_history)
    - [picker_config](#picker_config)
    - [highlights](#highlights)
    - [async_files](#async_files)
    - [colorscheme](#colorscheme)
    - [buftags](#buftags)
    - [buffers](#buffers)
    - [lines](#lines)
    - [help_tags](#help_tags)
    - [qflist](#qflist)
    - [loclist](#loclist)
    - [registers](#registers)
    - [jumps](#jumps)
    - [marks](#marks)
    - [lsp_document_symbols](#lsp_document_symbols)
    - [lsp_workspace_symbols](#lsp_workspace_symbols)
    - [lsp_references](#lsp_references)
- [Third party sources](#third-party-sources)
- [Custom source](#custom-source)
- [FAQ](#faq)
- [Self-Promotion](#self-promotion)
- [Feedback](#feedback)
- [Credits](#credits)

<!-- vim-markdown-toc -->

## Features

- 15+ builtin sources.
- simple, fast fuzzy match engine powered by fzy.
- simple API for creating custom source

## Installation

- use [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require("plug").add({
	{
		"wsdjeg/picker.nvim",
		config = function()
			require("picker").setup({
				filter = {
					ignorecase = false, -- ignorecase (boolean): defaults to false
				},
				window = {
					width = 0.8, -- set picker screen width, default is 0.8 * vim.o.columns
					height = 0.8,
					col = 0.1,
					row = 0.1,
					current_icon = ">",
					current_icon_hl = "CursorLine",
					enable_preview = false,
					preview_timeout = 500,
					show_score = true,
				},
				highlight = {
					matched = "Tag",
					score = "Comment",
				},
				prompt = {
					position = "bottom", -- set prompt position, bottom or top
					icon = ">",
					icon_hl = "Error",
					insert_timeout = 100,
					title = true, -- display/hide source name
				},
				mappings = {
					close = "<Esc>",
					next_item = "<Tab>",
					previous_item = "<S-Tab>",
					open_item = "<Enter>",
					toggle_preview = "<C-p>",
				},
			})
		end,
	},
})
```

## Usage

### Picker Command

1. fuzzy finder picker source.

run `:Picker` command without source name.

```
:Picker
```

2. open picker source.

run `:Picker` command with a name of source.

```
:Picker <name>
```

3. specific default input

with `--input` option, users also can specific default input text.

```
:Picker file --input=foo
```

or use `<cword>` for word under cursor.

```
:Picker help_tags --input=<cword>
```

### Key bindings

In picker prompt window, the these mappings are defined by default.

| key binding | description    |
| ----------- | -------------- |
| `Tab`       | next item      |
| `S-Tab`     | previous item  |
| `Enter`     | default action |
| `Esc`       | close picker   |

## Builtin sources

| source                | description                             |
| --------------------- | --------------------------------------- |
| buffers               | listed buffers                          |
| buftags               | ctags outline for current buffer        |
| cmd_history           | results from `:history :`               |
| colorscheme           | all colorschemes                        |
| files                 | files in current dir                    |
| help_tags             | neovim help tags source                 |
| highlights            | highlight group source                  |
| jumps                 | jump list                               |
| lines                 | lines in current buffer                 |
| loclist               | location list source                    |
| lsp_document_symbols  | document symbols result from lsp client |
| lsp_references        | lsp references                          |
| lsp_workspace_symbols | workspace symbols                       |
| marks                 | marks list                              |
| picker_config         | picker config source                    |
| qflist                | quickfix source                         |
| registers             | registers context                       |

### files

The default commands for listing files is `{'rg', '--files'}`. this can be changed via:

```lua
require("picker.sources.files").set({ cmd = { "rg", "--files" } })
```

| key binding | description                        |
| ----------- | ---------------------------------- |
| `<Enter>`   | open select file                   |
| `<C-v>`     | open select file in vertical split |
| `<C-t>`     | open select file in new tabpage    |

### cmd_history

| key binding | description                   |
| ----------- | ----------------------------- |
| `<Enter>`   | execute select command        |
| `<C-d>`     | delete select command history |

### picker_config

| key binding | description                |
| ----------- | -------------------------- |
| `<Enter>`   | set selected picker config |

### highlights

| key binding | description                        |
| ----------- | ---------------------------------- |
| `<Enter>`   | yank selected highlight group name |

### async_files

### colorscheme

| key binding | description                    |
| ----------- | ------------------------------ |
| `<Enter>`   | change to selected colorscheme |

### buftags

| key binding | description        |
| ----------- | ------------------ |
| `<Enter>`   | jump to select tag |

### buffers

| key binding | description             |
| ----------- | ----------------------- |
| `<Enter>`   | switch to select buffer |

### lines

| key binding | description           |
| ----------- | --------------------- |
| `<Enter>`   | jump to selected line |

### help_tags

| key binding | description            |
| ----------- | ---------------------- |
| `<Enter>`   | jump selected help tag |

### qflist

| key binding | description                      |
| ----------- | -------------------------------- |
| `<Enter>`   | jump selected quickfix list item |

### loclist

| key binding | description                |
| ----------- | -------------------------- |
| `<Enter>`   | jump selected loclist item |

### registers

| key binding | description            |
| ----------- | ---------------------- |
| `<Enter>`   | paste selected context |

### jumps

| key binding | description            |
| ----------- | ---------------------- |
| `<Enter>`   | jump selected position |

### marks

| key binding | description            |
| ----------- | ---------------------- |
| `<Enter>`   | jump selected position |

### lsp_document_symbols

| key binding | description          |
| ----------- | -------------------- |
| `<Enter>`   | jump selected symbol |

### lsp_workspace_symbols

| key binding | description          |
| ----------- | -------------------- |
| `<Enter>`   | jump selected symbol |

### lsp_references

| key binding | description             |
| ----------- | ----------------------- |
| `<Enter>`   | jump selected reference |

## Third party sources

| source            | description                                                                                     |
| ----------------- | ----------------------------------------------------------------------------------------------- |
| mru               | most recent used files, need [mru.nvim](https://github.com/wsdjeg/mru.nvim)                     |
| project           | project history, need [rooter.nvim](https://github.com/wsdjeg/rooter.nvim)                      |
| bookmarks         | all bookmarks, need [bookmarks.nvim](https://github.com/wsdjeg/bookmarks.nvim)                  |
| zettelkasten      | zettelkasten notes source from [zettelkasten.nvim](https://github.com/wsdjeg/zettelkasten.nvim) |
| zettelkasten_tags | zettelkasten tags source from [zettelkasten.nvim](https://github.com/wsdjeg/zettelkasten.nvim)  |
| git-branch        | git branch source from [git.nvim](https://github.com/wsdjeg/git.nvim)                           |
| music-player      | music-player source form [music-player.nvim](https://github.com/wsdjeg/music-player.nvim)       |
| plug              | plugins source for [nvim-plug](https://github.com/wsdjeg/nvim-plug)                             |
| async_files       | async files source, require [job.nvim](https://github.com/wsdjeg/job.nvim)                      |

## Custom source

a source main module should be `picker.sources.<name>`,
that means you can create a custom source in `lua/picker/sources/` directory in your plugin.

```lua
--- @class PickerSource
--- @field get function
--- @field default_action function
--- @field __results nil | table<string>
--- @field preview_win boolean
--- @field preview function
--- @field set function
--- @field actions? table
```

## FAQ

1. how to disable nvim-cmp in picker.nvim buffer?

```lua
require("cmp").setup({
	enabled = function()
		if vim.bo.filetype == "picker-prompt" then
			return false
		end
		return true
	end,
})
```

2. how to use picker.nvim as `vim.ui.select`?

```lua
vim.ui.select = function(items, opt, callback)
	local source = {}
	opt = opt or {}
	if opt.prompt then
		source.name = opt.prompt
	else
		source.name = "Select one of:"
	end

	source.get = function()
		local entrys = {}
		for idx, item in ipairs(items) do
			local entry = {
				value = item,
				idx = idx, -- this also can be nil
			}

			if opt.format_item then
				entry.str = opt.format_item(item)
			else
				entry.str = item
			end
			table.insert(entrys, entry)
		end
		return entrys
	end

	source.default_action = function(entry)
		if callback then
			callback(entry.value, entry.idx)
		end
	end

	require("picker.windows").open(source, {
		buf = vim.api.nvim_get_current_buf(),
	})
end
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/picker.nvim/issues)

## Credits

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
