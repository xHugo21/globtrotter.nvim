---@class GlobtrotterConfig
---@field max_results? number Maximum number of files to show (default: 50)
---@field include_hidden? boolean Include hidden files in results (default: true)
---@field border? string|table Border style for floating window (default: "single")
---@field override_lsp_hover? boolean Globally override LSP hover handler (default: true)
---@field trigger_key string Key to trigger the glob preview (default: "K")

local ui = require("globtrotter.ui")

---@class Globtrotter
local M = {}

---@type GlobtrotterConfig
local default_config = {
  max_results = 50,
  include_hidden = true,
  border = (vim.o.winborder and vim.o.winborder ~= "") and vim.o.winborder or "single",
  override_lsp_hover = true,
  trigger_key = "K",
}

---@type GlobtrotterConfig
M.config = vim.deepcopy(default_config)

---@type boolean
local _enabled = false

---Enable the glob override for LSP trigger
local function enable(config)
  if _enabled then
    return
  end
  ui.enable(config)
  _enabled = true
end

---Disable the glob override for LSP trigger
local function disable()
  if not _enabled then
    return
  end
  ui.disable()
  _enabled = false
end

---Toggle the glob override for LSP trigger
function M.toggle()
  if _enabled then
    disable()
  else
    enable(M.config)
  end
end

---Manually trigger glob preview at cursor position
---Falls back to LSP trigger if no glob pattern detected
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

  if M.config.override_lsp_hover then
    enable(M.config)
  end

  if M.config.trigger_key then
    vim.keymap.set("n", M.config.trigger_key, M.trigger, { desc = "Globtrotter / LSP Trigger" })
  end
end

return M
