---@class GlobtrotterDetector
local M = {}

local GLOB_CHARS_PATTERN = "[%*%?%[%]{}]"

local GLOB_ONLY_FILETYPES = {
  gitignore = true,
  ["ignore"] = true,
}

local GLOB_ONLY_FILENAMES = {
  [".gitignore"] = true,
  [".dockerignore"] = true,
  [".prettierignore"] = true,
  [".eslintignore"] = true,
  [".npmignore"] = true,
  [".hgignore"] = true,
  [".stylelintignore"] = true,
  [".markdownlintignore"] = true,
  [".vscodeignore"] = true,
}

---Check if the current buffer is a glob-only file
---@return boolean
function M.is_glob_only_file()
  local ft = vim.bo.filetype
  if GLOB_ONLY_FILETYPES[ft] then
    return true
  end

  local filename = vim.fn.expand("%:t")
  return GLOB_ONLY_FILENAMES[filename] or false
end

---Check if a string contains glob characters
---@param str string
---@return boolean
function M.has_glob_chars(str)
  return str:match(GLOB_CHARS_PATTERN) ~= nil
end

---Extract the pattern from the current cursor position
---For glob-only files, returns the entire line (stripped)
---For other files, returns the WORD under cursor if it contains glob chars
---@return string|nil pattern The glob pattern, or nil if not found
function M.get_pattern_at_cursor()
  local line = vim.api.nvim_get_current_line()

  if M.is_glob_only_file() then
    local pattern = vim.trim(line)
    if pattern == "" or pattern:sub(1, 1) == "#" then
      return nil
    end
    return pattern
  end

  local word = vim.fn.expand("<cWORD>")
  if word == "" then
    return nil
  end

  local unquoted = word:match("^[\"'](.+)[\"']$") or word
  if M.has_glob_chars(unquoted) then
    return unquoted
  end

  return nil
end

return M
