-- File: ~/.config/nvim/lua/config/lazy.lua

require("lazy").setup({
  spec = {
    -- Import all plugin specifications
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "gruvbox" } }, -- Set your preferred colorscheme
  checker = { enabled = true }, -- Automatically check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
