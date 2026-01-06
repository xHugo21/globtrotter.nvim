---@class GlobtrotterIcons
local M = {}

---@type boolean|nil
local mini_icons_available = nil

---Check if mini.icons is available
---@return boolean
function M.is_available()
  if mini_icons_available == nil then
    local ok, _ = pcall(require, "mini.icons")
    mini_icons_available = ok
  end
  return mini_icons_available
end

---Get icon and highlight group for a file entry
---@param entry GlobtrotterFileEntry
---@return string icon, string hl_group
function M.get_icon(entry)
  if not M.is_available() then
    return "", ""
  end

  local mini_icons = require("mini.icons")

  if entry.is_dir then
    local icon, hl = mini_icons.get("directory", entry.path)
    return icon, hl
  end

  local icon, hl = mini_icons.get("file", entry.path)
  return icon, hl
end

return M
