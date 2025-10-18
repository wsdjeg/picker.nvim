# picker.nvim

picker.nvim is a highly customizable and extensible Neovim fuzzy finder plugin

[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

![picker-neovim](https://wsdjeg.net/images/picker-neovim.png)

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Usage](#usage)
- [Key bindings](#key-bindings)
- [Available sources](#available-sources)
- [Custom source](#custom-source)
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
					width = 0.8,
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
					position = "bottom", --- bottom or top
					icon = ">",
					icon_hl = "Error",
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

| source      | description                                                                    |
| ----------- | ------------------------------------------------------------------------------ |
| files       | files in current dir                                                           |
| colorscheme | all colorschemes                                                               |
| mru         | most recent used files, need [mru.nvim](https://github.com/wsdjeg/mru.nvim)    |
| project     | project history, need [rooter.nvim](https://github.com/wsdjeg/rooter.nvim)     |
| buftags     | ctags outline for current buffer                                               |
| buffers     | listed buffers                                                                 |
| bookmarks   | all bookmarks, need [bookmarks.nvim](https://github.com/wsdjeg/bookmarks.nvim) |
| lines       | lines in current buffer                                                        |
| help_tags   | neovim help tags source                                                        |

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

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/picker.nvim/issues)

## Credits

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
