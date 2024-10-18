-- File: ~/.config/nvim/lua/plugins/neoscroll.lua

return {
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>",
                    "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at the end/beginning of the file
        respect_scrolloff = false, -- Ignore `scrolloff` and `sidescrolloff`
        cursor_scrolls_alone = true, -- Scroll the cursor even if the window cannot scroll
        easing_function = "quadratic", -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      })
    end,
  },
}
