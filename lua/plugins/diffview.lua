return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      -- Open Diffview
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diffview Open" },
            
                  -- Close Diffview
                        { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Git Diffview Close" },
                        
                              -- Toggle the files panel
                                    { "<leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Git Diffview Toggle Files" },
                                    
                                          -- Focus on the files panel
      { "<leader>gf", "<cmd>DiffviewFocusFiles<cr>", desc = "Git Diffview Focus Files" },
      
            -- View file history
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git File History" },

      -- View branch history
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git Branch History" },

      -- Refresh Diffview
      { "<leader>gr", "<cmd>DiffviewRefresh<cr>", desc = "Git Diffview Refresh" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = "diff2_horizontal",
          },
        },
        keymaps = {
          view = {
            -- Customize keybindings within Diffview
          },
        },
      })
    end,
  },
}
