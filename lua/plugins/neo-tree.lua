return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- This makes the filtered items (hidden files) visible
        hide_dotfiles = false, -- Show dotfiles
        hide_gitignored = false, -- Show gitignored files
        hide_by_name = {
          -- you can remove filenames from here that you don't want to be hidden
        },
        never_show = {
          -- ".DS_Store",
          -- "thumbs.db"
        },
      },
    },
  },
}
