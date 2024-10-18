-- File: ~/.config/nvim/lua/plugins/dap.lua

return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "jbyuki/one-small-step-for-vimkind",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dap_ui = require("dapui")
      local dap_virtual_text = require("nvim-dap-virtual-text")

      -- Setup DAP UI
      dap_ui.setup()
      dap_virtual_text.setup()

      -- Automatically open and close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dap_ui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap_ui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap_ui.close()
      end

      -- Define Lua Adapter using one-small-step-for-vimkind
      dap.adapters.vim = {
        type = "server",
        host = "127.0.0.1",
        port = 38888, -- Ensure this port is free or change as needed
      }

      -- Lua Configurations
      dap.configurations.lua = {
        {
          type = "vim", -- Must match the adapter defined above
          request = "attach",
          name = "Attach to Neovim",
          program = "${file}", -- This can be adjusted based on your needs
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
        },
      }

      -- Python Configurations (ensure debugpy is installed via mason or pip)
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter", -- Adjust if installed elsewhere
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch Python Script",
          program = "${file}",
          console = "integratedTerminal",
          cwd = "${workspaceFolder}",
          env = {},
          args = {},
        },
        {
          type = "python",
          request = "attach",
          name = "Attach to Running Python Process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          env = {},
        },
      }

      -- Function to find and load launch.json
      local function find_launch_json()
        local filepath = vim.fn.expand("%:p") -- Current file path
        local dir = vim.fn.fnamemodify(filepath, ":h") -- Directory of current file

        while dir ~= "/" do
          local potential_path = dir .. "/.vscode/launch.json"
          if vim.fn.filereadable(potential_path) == 1 then
            return potential_path
          end
          dir = vim.fn.fnamemodify(dir, ":h") -- Move up one directory
        end

        return nil
      end

      -- Function to load launch.json
      local function load_launch_json()
        local launch_json_path = find_launch_json()
        if launch_json_path then
          require("dap.ext.vscode").load_launchjs(launch_json_path)
          vim.notify("Loaded launch.json from " .. launch_json_path, vim.log.levels.INFO)
        else
          vim.notify("No launch.json found in .vscode folder", vim.log.levels.WARN)
        end
      end

      -- Load launch.json immediately during setup
      load_launch_json()

      -- Also load launch.json on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          load_launch_json()
        end,
      })

      -- Keybinding to select debugger configuration with Telescope
      vim.keymap.set("n", "<leader>ds", function()
        if #dap.configurations == 0 then
          vim.notify("No DAP configurations loaded. Make sure launch.json is loaded.", vim.log.levels.ERROR)
          return
        end

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
                dap.run(selection.value)
              end)
              return true
            end,
          })
          :find()
      end, { desc = "Select Debugger Configuration" })
    end,
  },
}
