-- ./lua/plugins/neoscroll.lua

return {
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup()
    end,
  },
}
