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


-- File: ~/.config/nvim/init.lua

-- Add this near the end of the file
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Start Alpha when vim is opened with no arguments",
  group = vim.api.nvim_create_augroup("alpha_autostart", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
      require("alpha").start()
    end
  end,
})
