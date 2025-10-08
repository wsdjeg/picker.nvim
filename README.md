# picker.nvim

_picker.nvim_ is a fuzzy finder for neovim. This plugin is WIP.

![](https://private-user-images.githubusercontent.com/13142418/497562552-7b31fcd7-6185-43cf-80be-147fb5ede58c.png)

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
				},
				highlight = {
					matched = "Search",
				},
				prompt = {
					position = "bottom", --- bottom or top
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
