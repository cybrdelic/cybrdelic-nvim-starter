-- File: ~/.config/nvim/lua/plugins/neo-tree.lua

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Show filtered items (e.g., hidden files)
          hide_dotfiles = false, -- Do not hide dotfiles
          hide_gitignored = false, -- Do not hide gitignored files
          never_show = {
            -- Add files or directories you never want to show
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
      window = {
        position = "left",
        width = 40,
        mappings = {
          ["<CR>"] = "open",
          ["<C-v>"] = "open_vsplit",
          ["<C-s>"] = "open_split",
          ["<C-t>"] = "open_tabnew",
          ["<C-c>"] = "close_node",
          ["<Tab>"] = "toggle_preview",
          ["h"] = "close_node",
          ["l"] = "open",
        },
      },
      -- Additional configurations can be added here
    },
  },
}
