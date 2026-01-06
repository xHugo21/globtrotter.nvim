---@class GlobtrotterExpander
local M = {}

---@class GlobtrotterFileEntry
---@field path string Relative file path
---@field is_dir boolean Whether the entry is a directory

---Convert a glob pattern to a Lua pattern for vim.fn.glob
---Handles glob-only patterns (leading /, negation, etc.)
---@param pattern string
---@return string|nil normalized_pattern
local function normalize_pattern(pattern)
  if pattern:sub(1, 1) == "!" then
    return nil
  end

  local p = pattern
  if p:sub(1, 1) == "/" then
    p = p:sub(2)
  end

  return p
end

---Expand a glob pattern and return matching files
---@param pattern string The glob pattern
---@param opts? {max_results?: number, cwd?: string, include_hidden?: boolean}
---@return GlobtrotterFileEntry[] files List of matching file entries (relative to cwd)
---@return boolean truncated Whether the results were truncated
function M.expand(pattern, opts)
  opts = opts or {}
  local max_results = opts.max_results or 50
  local cwd = opts.cwd or vim.fn.getcwd()
  local include_hidden = opts.include_hidden ~= false

  local normalized = normalize_pattern(pattern)
  if not normalized then
    return {}, false
  end

  local glob_pattern = cwd .. "/" .. normalized

  local raw_files = vim.fn.glob(glob_pattern, include_hidden, true)

  local files = {}
  local cwd_len = #cwd + 2

  for i, file in ipairs(raw_files) do
    if i > max_results then
      break
    end
    local relative = file:sub(cwd_len)
    local is_dir = vim.fn.isdirectory(file) == 1
    table.insert(files, { path = relative, is_dir = is_dir })
  end

  return files, #raw_files > max_results
end

return M
