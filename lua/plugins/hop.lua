-- File: ~/.config/nvim/lua/plugins/hop.lua

return {
  {
    "phaazon/hop.nvim",
    branch = "v2", -- Optional but recommended
    keys = { "s", "S" },
    config = function()
      require("hop").setup()
    end,
  },
}
