-- ./lua/plugins/comment.lua

return {
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb" },
    config = function()
      require("Comment").setup()
    end,
  },
}
