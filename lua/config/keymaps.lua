-- File: ~/.config/nvim/lua/config/keymaps.lua

local wk = require("which-key")

-- Function to clear all keymaps except those starting with <leader>
local function clear_unwanted_keymaps()
  local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }
  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      if map.lhs and not map.lhs:match("^<leader>") then
        vim.api.nvim_del_keymap(mode, map.lhs)
      end
    end
  end
  vim.notify("Unwanted keymaps cleared.", vim.log.levels.INFO)
end

-- Clear keymaps after all plugins have loaded using the VeryLazy event
vim.api.nvim_create_autocmd("VeryLazy", {
  callback = clear_unwanted_keymaps,
})

-- Optionally, manually delete specific keymaps
vim.api.nvim_del_keymap("n", "<Space>gD")
vim.api.nvim_del_keymap("n", "<Space>gh")
-- Add more deletions as needed

-- Define your own keymaps
wk.register({
  -- File Operations
  f = {
    name = "File",
    s = { "<cmd>w<cr>", "Save File" },
    q = { "<cmd>q<cr>", "Quit" },
    a = { "<cmd>wa<cr>", "Save All" },
  },
  -- Git Operations
  g = {
    name = "Git",
    s = { "<cmd>Git status<cr>", "Git Status" },
    c = { "<cmd>Git commit<cr>", "Git Commit" },
    p = { "<cmd>Git push<cr>", "Git Push" },
    l = { "<cmd>Git pull<cr>", "Git Pull" },
  },
  -- Telescope
  t = {
    name = "Telescope",
    f = { "<cmd>Telescope find_files<cr>", "Find Files" },
    g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
  },
  -- Toggle Terminal
  T = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
  -- Others
  e = { "<cmd>NvimTreeToggle<cr>", "Toggle Explorer" },
}, { prefix = "<leader>" })
