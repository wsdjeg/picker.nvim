# picker.nvim

_picker.nvim_ is a fuzzy finder for neovim.

![picker-neovim](https://wsdjeg.net/images/picker-neovim.png)

## Install

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
					matched = "Search",
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

## Key bindings

| key binding | description    |
| ----------- | -------------- |
| `Tab`       | next item      |
| `S-Tab`     | previous item  |
| `Enter`     | default action |
| `Esc`       | close picker   |

## Default Sources

| source      | description                                           |
| ----------- | ----------------------------------------------------- |
| files       | files in current dir                                  |
| colorscheme | all colorschemes                                      |
| mru         | [mru.nvim](https://github.com/wsdjeg/mru.nvim) source |
