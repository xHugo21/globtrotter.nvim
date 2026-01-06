---@class GlobtrotterConfig
---@field max_results number Maximum number of files to show (default: 50)
---@field include_hidden boolean Include hidden files in results (default: true)
---@field border string|table Border style for floating window (default: "rounded")
---@field auto_enable boolean Automatically enable LSP hover override on setup (default: true)
---@field trigger_key string? Key to trigger the glob preview (default: nil)

local ui = require("globtrotter.ui")

---@class Globtrotter
local M = {}

---@type GlobtrotterConfig
local default_config = {
  max_results = 50,
  include_hidden = true,
  border = "rounded",
  auto_enable = true,
  trigger_key = nil,
}

---@type GlobtrotterConfig
M.config = vim.deepcopy(default_config)

---@type boolean
M._enabled = false

---Enable the glob override for LSP hover
function M.enable()
  if M._enabled then
    return
  end
  ui.enable(M.config)
  M._enabled = true
end

---Disable the glob override for LSP hover
function M.disable()
  if not M._enabled then
    return
  end
  ui.disable()
  M._enabled = false
end

---Toggle the glob override for LSP hover
function M.toggle()
  if M._enabled then
    M.disable()
  else
    M.enable()
  end
end

---Manually trigger glob preview at cursor position
---Falls back to LSP hover if no glob pattern detected
function M.trigger()
  local shown = ui.trigger(M.config)
  if not shown then
    vim.lsp.buf.hover()
  end
end

---Setup globtrotter with user configuration
---@param opts? GlobtrotterConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", default_config, opts or {})

  if M.config.auto_enable then
    M.enable()
  end

  if M.config.trigger_key then
    vim.keymap.set("n", M.config.trigger_key, M.trigger, { desc = "Globtrotter / LSP Trigger" })
  end
end

return M
