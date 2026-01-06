---@class GlobtrotterUI
local M = {}

local detector = require("globtrotter.detector")
local expander = require("globtrotter.expander")

---@type function|nil
local original_trigger_handler = nil

---Format the preview content for display
---@param pattern string
---@param files string[]
---@param truncated boolean
---@param config table
---@return string[]
local function format_preview_content(pattern, files, truncated, config)
  local lines = {}

  table.insert(lines, "**Glob Pattern:** `" .. pattern .. "`")
  table.insert(lines, "")

  if #files == 0 then
    table.insert(lines, "_No matching files_")
  else
    table.insert(lines, string.format("**Matches:** %d file(s)%s", #files, truncated and "+" or ""))
    table.insert(lines, "")
    for _, file in ipairs(files) do
      table.insert(lines, "- " .. file)
    end
    if truncated then
      table.insert(lines, "")
      table.insert(lines, string.format("_...truncated to %d results_", config.max_results))
    end
  end

  return lines
end

---Show the glob preview popup
---@param pattern string
---@param config table
local function show_glob_preview(pattern, config)
  local files, truncated = expander.expand(pattern, {
    max_results = config.max_results,
    include_hidden = config.include_hidden,
  })

  local lines = format_preview_content(pattern, files, truncated, config)

  local bufnr, winnr = vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = config.border,
    focusable = true,
    focus = false,
  })

  if bufnr then
    vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
  end

  return bufnr, winnr
end

---Custom trigger handler that checks for glob patterns first
---@param config table
---@return function
function M.create_trigger_handler(config)
  return function(err, result, ctx, trigger_config)
    local pattern = detector.get_pattern_at_cursor()

    if pattern then
      show_glob_preview(pattern, config)
      return
    end

    if original_trigger_handler then
      return original_trigger_handler(err, result, ctx, trigger_config)
    end
  end
end

---Enable the glob trigger override
---@param config table
function M.enable(config)
  original_trigger_handler = vim.lsp.handlers["textDocument/hover"]
  vim.lsp.handlers["textDocument/hover"] = M.create_trigger_handler(config)
end

---Disable the glob trigger override and restore original handler
function M.disable()
  if original_trigger_handler then
    vim.lsp.handlers["textDocument/hover"] = original_trigger_handler
    original_trigger_handler = nil
  end
end

---Manually trigger glob preview (for use without LSP)
---@param config table
---@return boolean success Whether a glob pattern was found and displayed
function M.trigger(config)
  local pattern = detector.get_pattern_at_cursor()

  if not pattern then
    return false
  end

  show_glob_preview(pattern, config)
  return true
end

return M
