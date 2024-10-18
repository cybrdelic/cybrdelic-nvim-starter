-- File: ~/.config/nvim/lua/config/autocmds.lua

-- Create a new augroup
local augroup = vim.api.nvim_create_augroup("MyCustomAutocmds", { clear = true })

-- Example: Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Example: Automatically close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "help", "man", "lspinfo", "qf" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})
