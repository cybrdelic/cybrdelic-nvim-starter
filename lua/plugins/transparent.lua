return {
  {
    "xiyaowong/nvim-transparent",
    keys = {
      { "<leader>uT", "<cmd>TransparentToggle<cr>", desc = "Toggle Transparency" },
    },
    lazy = false,
    opts = {
      enable = true,
      -- Optional configurations
      extra_groups = {
        -- Add any highlight groups you want to clear
        -- Example: "NormalFloat", "NvimTreeNormal"
      },
      exclude = {}, -- Exclude certain highlight groups
    },
  },
}
