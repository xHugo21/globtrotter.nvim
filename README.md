# globtrotter.nvim

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A Neovim plugin that detects glob patterns under your cursor and shows matching files in an LSP-style floating window.

## Features

- **Smart Detection**: Automatically identifies glob characters (`*`, `?`, `**`, `[...]`, `{...}`) in the word under the cursor.
- **Ignore File Support**: Full support for `.gitignore`, `.dockerignore`, and other ignore-style files. Every line is treated as a potential glob.
- **LSP Integration**: Seamlessly injects glob matching into your existing workflow by augmenting the LSP hover mechanism.
- **Native UI**: Uses Neovim's built-in floating window API for a consistent look and feel.
- **Configurable**: Limit result counts, toggle hidden files, and customize window borders.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "xhugo21/globtrotter.nvim",
  opts = {
    max_results = 50,      -- Maximum number of files to show
    include_hidden = true, -- Include hidden files in search
    border = "rounded",    -- "none", "single", "double", "rounded", "solid", "shadow"
    auto_enable = true,    -- Automatically enable LSP hover override
    trigger_key = "K",     -- Optional: Automatically set a keymap to trigger the preview
  },
}
```

## Usage

### Keymap (Manual vs Automatic)

You can let the plugin handle the keymap for you by setting `trigger_key` in the configuration:

```lua
require("globtrotter").setup({
  trigger_key = "K" -- This sets the mapping automatically
})
```

Or you can map it yourself to the Globtrotter trigger function. It will fall back to `vim.lsp.buf.hover()` if no glob is detected.

```lua
vim.keymap.set("n", "K", function()
  require("globtrotter").trigger()
end, { desc = "Trigger (Globtrotter / LSP)" })
```

### Commands

- `:GlobtrotterTrigger`: Manually trigger the glob matches preview at the current cursor position.
- `:GlobtrotterToggle`: Toggle the LSP hover override.
- `:GlobtrotterEnable`: Enable the LSP hover override.
- `:GlobtrotterDisable`: Disable the LSP hover override.

## Configuration

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `max_results` | `number` | `50` | Limits the number of files displayed in the floating window. |
| `include_hidden` | `boolean` | `true` | Whether to include dotfiles in the results. |
| `border` | `string` | `winborder` or `"rounded"` | Border style for the floating window. |
| `auto_enable` | `boolean` | `true` | Whether to automatically hijack `vim.lsp.handlers["textDocument/hover"]`. |
| `trigger_key` | `string` | `nil` | Optional: Key to automatically map to the trigger function. |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT
