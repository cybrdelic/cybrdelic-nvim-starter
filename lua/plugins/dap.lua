-- File: ./lua/plugins/dap.lua

return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "rcarriga/nvim-dap-ui", -- UI for DAP
      "theHamsta/nvim-dap-virtual-text", -- Show variables in-line during debugging
      "nvim-telescope/telescope-dap.nvim", -- Telescope integration
    },
    config = function()
      local dap = require("dap")
      local dap_ui = require("dapui")
      local dap_virtual_text = require("nvim-dap-virtual-text")
      local telescope = require("telescope")
      telescope.load_extension("dap")

      -- Load the DAP UI and virtual text
      dap_ui.setup()
      dap_virtual_text.setup()

      -- Function to load configurations from launch.json
      local function load_launch_json()
        local launch_json_path = vim.fn.getcwd() .. "/.vscode/launch.json"
        if vim.fn.filereadable(launch_json_path) == 1 then
          require("dap.ext.vscode").load_launchjs(launch_json_path)
          vim.notify("Loaded launch.json from .vscode folder", vim.log.levels.INFO)
        else
          vim.notify("No launch.json found in .vscode folder", vim.log.levels.WARN)
        end
      end

      -- Automatically load launch.json on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = load_launch_json,
      })

      -- Keybinding to allow interactive selection of debugger configurations
      vim.keymap.set("n", "<leader>ds", function()
        -- Check if DAP configurations are loaded
        if #dap.configurations == 0 then
          vim.notify("No DAP configurations loaded. Make sure launch.json is loaded.", vim.log.levels.ERROR)
          return
        end

        -- Use Telescope to pick the configuration
        require("telescope.pickers")
          .new({}, {
            prompt_title = "Select Debugger Configuration",
            finder = require("telescope.finders").new_table({
              results = dap.configurations,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.name,
                  ordinal = entry.name,
                }
              end,
            }),
            sorter = require("telescope.config").values.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                dap.run(selection.value) -- Start the debugger with the selected configuration
              end)
              return true
            end,
          })
          :find()
      end, { desc = "Select Debugger Configuration" })
    end,
  },
}
