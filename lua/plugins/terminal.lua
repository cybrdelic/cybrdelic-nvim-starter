-- File: ~/.config/nvim/lua/plugins/terminal.lua

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      -- Set the terminal to open in floating mode
      direction = "float",
      float_opts = {
        border = "curved",
        -- Set the width and height to 80% of the editor size
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 0, -- Set transparency if needed
      },
    },
    keys = {
      -- Toggle the active terminal
      { "<leader>t<space>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },

      -- Create a new terminal with a user-provided name
      {
        "<leader>tn",
        function()
          vim.ui.input({ prompt = "Enter terminal name: " }, function(input)
            if input then
              require("toggleterm.terminal").Terminal:new({ cmd = "", direction = "float", name = input }):toggle()
            end
          end)
        end,
        desc = "New Named Terminal",
      },

      -- Switch between terminals using Telescope
      {
        "<leader>ts",
        function()
          local terms = require("toggleterm.terminal").get_all()
          local term_list = {}
          for _, term in pairs(terms) do
            table.insert(term_list, {
              display = term.name or ("Terminal " .. term.id),
              id = term.id,
            })
          end
          if vim.tbl_isempty(term_list) then
            vim.notify("No active terminals", vim.log.levels.INFO)
            return
          end
          require("telescope.pickers")
            .new({}, {
              prompt_title = "Select Terminal",
              finder = require("telescope.finders").new_table({
                results = term_list,
                entry_maker = function(entry)
                  return {
                    value = entry.id,
                    display = entry.display,
                    ordinal = entry.display,
                  }
                end,
              }),
              sorter = require("telescope.config").values.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, _)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  local term = require("toggleterm.terminal").get(selection.value)
                  if term then
                    term:toggle()
                  end
                end)
                return true
              end,
            })
            :find()
        end,
        desc = "Switch Terminal",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
