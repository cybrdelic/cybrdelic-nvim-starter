-- ./lua/plugins/aerial.lua

return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Configure layout and appearance
      layout = {
        default_direction = "prefer_right", -- Open aerial to the right
        width = 40, -- Set width to 40 columns
      },
      -- Enable highlight on jump
      highlight_on_jump = true,
      -- Sort symbols alphabetically
      sort = "alphabetical",
      -- Define backends: prefer treesitter, fallback to LSP
      backends = { "treesitter", "lsp" },
      -- Keymaps specific to aerial window
      keymaps = {
        ["<CR>"] = "jump",
        ["<C-v>"] = "jump_vsplit",
        ["<C-s>"] = "jump_split",
        ["p"] = "scroll",
        ["<C-j>"] = "down_and_scroll",
        ["<C-k>"] = "up_and_scroll",
        ["{"] = "prev",
        ["}"] = "next",
        ["q"] = "close",
      },
      -- Optional: Show icons
      icons = {
        class = " ",
        method = " ",
        variable = " ",
        interface = "ﰮ ",
        module = " ",
        property = " ",
        struct = " ",
        enum = " ",
        enum_member = " ",
        constant = " ",
        field = " ",
        constructor = " ",
        file = " ",
        folder = " ",
        -- Add more symbol kinds if desired
      },
      -- Optional: Customize floating window
      float = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.5,
      },
      -- Additional configurations can be added here
    },
    keys = {
      -- Toggle aerial window
      {
        "<leader>a",
        "<cmd>AerialToggle!<CR>",
        desc = "Toggle Aerial",
      },
      -- Jump to next symbol
      {
        "}",
        "<cmd>AerialNext<CR>",
        mode = "n",
        desc = "Jump to Next Symbol",
      },
      -- Jump to previous symbol
      {
        "{",
        "<cmd>AerialPrev<CR>",
        mode = "n",
        desc = "Jump to Previous Symbol",
      },
      -- Open aerial in floating window
      {
        "<leader>af",
        function()
          require("aerial").open({ layout = { default_direction = "float" } })
        end,
        desc = "Open Aerial (Float)",
      },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
    end,
  },
}
