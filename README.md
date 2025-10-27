# picker.nvim

picker.nvim is a highly customizable and extensible Neovim fuzzy finder plugin

[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

![picker-neovim](https://wsdjeg.net/images/picker-neovim.png)

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Usage](#usage)
- [Key bindings](#key-bindings)
- [Available sources](#available-sources)
    - [files](#files)
    - [cmd_history](#cmd_history)
- [Custom source](#custom-source)
- [FAQ](#faq)
- [Self-Promotion](#self-promotion)
- [Feedback](#feedback)
- [Credits](#credits)

<!-- vim-markdown-toc -->

## Installation

- use [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require("plug").add({
	{
		"wsdjeg/picker.nvim",
		config = function()
			require("picker").setup({
				window = {
					width = 0.8, -- set picker screen width, default is 0.8 * vim.o.columns
					height = 0.8,
					col = 0.1,
					row = 0.1,
					current_icon = ">",
					current_icon_hl = "CursorLine",
					enable_preview = false,
					preview_timeout = 500,
				},
				highlight = {
					matched = "Tag",
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

## Key bindings

| key binding | description    |
| ----------- | -------------- |
| `Tab`       | next item      |
| `S-Tab`     | previous item  |
| `Enter`     | default action |
| `Esc`       | close picker   |

## Available sources

builtin sources:

| source                | description                                                                |
| --------------------- | -------------------------------------------------------------------------- |
| files                 | files in current dir                                                       |
| async_files           | async files source, require [job.nvim](https://github.com/wsdjeg/job.nvim) |
| colorscheme           | all colorschemes                                                           |
| buftags               | ctags outline for current buffer                                           |
| buffers               | listed buffers                                                             |
| lines                 | lines in current buffer                                                    |
| help_tags             | neovim help tags source                                                    |
| qflist                | quickfix source                                                            |
| loclist               | location list source                                                       |
| registers             | registers context                                                          |
| jumps                 | jump list                                                                  |
| marks                 | marks list                                                                 |
| lsp_document_symbols  | document symbols result from lsp client                                    |
| lsp_workspace_symbols | workspace symbols                                                          |
| lsp_references        | lsp references                                                             |
| cmd_history           | results from `:history :`                                                  |

### files

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

third party sources:

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

how to disable nvim-cmp in picker.nvim buffer?

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

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/picker.nvim/issues)

## Credits

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
