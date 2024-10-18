-- File: ~/.config/nvim/lua/config/options.lua

-- General Neovim Options
local opt = vim.opt

-- Set leader key to space
vim.g.mapleader = " "

-- Appearance
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Other Options
opt.splitbelow = true
opt.splitright = true
opt.updatetime = 300
opt.scrolloff = 8
opt.sidescrolloff = 8
