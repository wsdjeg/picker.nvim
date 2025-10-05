# picker.nvim

_picker.nvim_ is a fuzzy finder for neovim. This plugin is WIP.

![](https://private-user-images.githubusercontent.com/13142418/497562552-7b31fcd7-6185-43cf-80be-147fb5ede58c.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTk2NzgyMjUsIm5iZiI6MTc1OTY3NzkyNSwicGF0aCI6Ii8xMzE0MjQxOC80OTc1NjI1NTItN2IzMWZjZDctNjE4NS00M2NmLTgwYmUtMTQ3ZmI1ZWRlNThjLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTEwMDUlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUxMDA1VDE1MjUyNVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTcyMzkzNTMzOGZkMDRhOWIyNjAwZmVjYTAzNjFiYmQzMmVlZTNiMDFkNzVlMjViZWM2NjMyMDNmMjNmOTMxYWYmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.QYUwcZtrYBbfuNofQPsHju1XB8avlNUQ8QlRdPJnht4)

## Install

- use [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    {
        'wsdjeg/picker.nvim',
        config = function()
            require('picker').setup({

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
