-- File: ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim and load core configurations
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- Clone lazy.nvim if not present
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configurations
require("config.lazy")
require("config.keymaps")
