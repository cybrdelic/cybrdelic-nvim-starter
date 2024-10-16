-- ./lua/config/keymaps.lua

-- Require the utils module
local utils = require("utils")

-- Existing keymaps...
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)

-- Keybinding to open GitHub PAT creation page
vim.keymap.set("n", "<leader>gP", function()
  utils.open_url("https://github.com/settings/tokens/new")
end, { noremap = true, silent = true, desc = "Create GitHub PAT" })
