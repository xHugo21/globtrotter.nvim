if vim.g.loaded_globtrotter then
  return
end
vim.g.loaded_globtrotter = true

vim.api.nvim_create_user_command("GlobtrotterToggle", function()
  require("globtrotter").toggle()
end, { desc = "Toggle globtrotter trigger override" })

vim.api.nvim_create_user_command("GlobtrotterTrigger", function()
  require("globtrotter").trigger()
end, { desc = "Show glob matches at cursor" })
