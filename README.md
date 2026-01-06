# globtrotter.nvim

A Neovim plugin that detects glob patterns under your cursor and shows matching files in an LSP-style floating window.

<img width="969" height="353" alt="image" src="https://github.com/user-attachments/assets/21bd08dc-1755-43bd-92e5-3aabfb6d8c13" />

## Installation

lazy:

```lua
{
  "xhugo21/globtrotter.nvim",
  opts = {
    max_results = 50,      -- Maximum number of files to show
    include_hidden = true, -- Include hidden files in search
    border = "rounded",    -- "none", "single", "double", "rounded", "solid", "shadow"
    override_lsp_hover = true, -- Globally override LSP hover handler
    trigger_key = "K",     -- Key to trigger the preview
  },
}
```

## Usage

### Keymap (Manual vs Automatic)

You can let the plugin handle the keymap for you by setting `trigger_key` in the configuration (defaults to `K`):

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

### Advanced: Trigger vs. Override

| Option | What it does | Use Case |
| :--- | :--- | :--- |
| **`trigger_key`** | Automatically maps a key (default `K`) to the glob preview. If no glob is found, it calls the standard LSP hover. | You want a single key to "just work" for both globs and LSP documentation. |
| **`override_lsp_hover`** | Globally hijacks Neovim's internal LSP hover handler. | You use other plugins (like LspSaga or Noice) and want them to also show glob matches automatically. |

**Example: Pure Manual Mode**

If you want to keep your LSP hover completely untouched and use a different key for globs:

```lua
{
  "xhugo21/globtrotter.nvim",
  opts = {
    override_lsp_hover = false, -- Don't touch the global LSP handler
    trigger_key = "<leader>g",  -- Use a dedicated key for glob previews
  }
}
```

### Commands

- `:GlobtrotterTrigger`: Manually trigger the glob matches preview at the current cursor position.
- `:GlobtrotterToggle`: Toggle the LSP hover override.

## Configuration

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `max_results` | `number` | `50` | Limits the number of files displayed in the floating window. |
| `include_hidden` | `boolean` | `true` | Whether to include dotfiles in the results. |
| `border` | `string` | `winborder` or `"single"` | Border style for the floating window. |
| `override_lsp_hover` | `boolean` | `true` | Whether to globally hijack `vim.lsp.handlers["textDocument/hover"]`. |
| `trigger_key` | `string` | `"K"` | Key to automatically map to the trigger function. |

## Dependencies

- **Neovim >= 0.8.0**
- **[mini.icons](https://github.com/echasnovski/mini.icons)** (Optional): To display icons next to file matches.

## License

MIT
