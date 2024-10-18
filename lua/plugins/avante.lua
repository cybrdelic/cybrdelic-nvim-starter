-- File: ~/.config/nvim/lua/plugins/avante.lua

return {
  {
    "yetone/avante.nvim",
    lazy = false,
    event = "VeryLazy",
    version = false, -- Always pull the latest changes
    build = "make",
    opts = {
      provider = "claude", -- Use Claude as the provider
      claude = {
        model = "claude-3-5-sonnet-20240620", -- Specify the model if needed
        temperature = 0,
        max_tokens = 8192,
      },
      behaviour = {
        auto_suggestions = true,
        -- Additional behavior configurations...
      },
      mappings = {
        -- Existing custom keybindings...
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      -- Other configurations...
    },
    keys = {
      -- Add the keybinding to toggle the Avante sidebar
      {
        "<leader>aa",
        function()
          require("avante").toggle()
        end,
        desc = "Toggle Avante Sidebar",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Optional dependencies:
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
