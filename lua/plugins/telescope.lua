-- File: ~/.config/nvim/lua/plugins/telescope.lua

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function create_file(prompt_bufnr)
      local new_file = action_state.get_current_line()
      actions.close(prompt_bufnr)
      if new_file ~= "" then
        local dir = vim.fn.fnamemodify(new_file, ":h")
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, "p")
        end
        vim.cmd("edit " .. new_file)
        vim.notify("Created new file: " .. new_file, vim.log.levels.INFO)
      end
    end

    local function delete_file(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      if selection == nil then
        vim.notify("No file selected", vim.log.levels.WARN)
        return
      end
      local file = selection.value
      if file == "" then return end
      
      actions.close(prompt_bufnr)
      local choice = vim.fn.confirm("Delete file: " .. file .. "?", "&Yes\n&No", 2)
      if choice == 1 then
        os.remove(file)
        vim.notify("Deleted file: " .. file, vim.log.levels.INFO)
      end
    end

    local function create_branch(prompt_bufnr)
      local new_branch = action_state.get_current_line()
      actions.close(prompt_bufnr)
      vim.fn.system(string.format("git checkout -b %s", new_branch))
      vim.notify("Created and switched to branch: " .. new_branch, vim.log.levels.INFO)
    end

    local function delete_branch(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      if selection == nil then
        vim.notify("No branch selected", vim.log.levels.WARN)
        return
      end
      local branch = selection.value
      if branch == "" then return end
      
      actions.close(prompt_bufnr)
      local choice = vim.fn.confirm("Delete branch: " .. branch .. "?", "&Yes\n&No", 2)
      if choice == 1 then
        vim.fn.system(string.format("git branch -D %s", branch))
        vim.notify("Deleted branch: " .. branch, vim.log.levels.INFO)
      end
    end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        oldfiles = {
          mappings = {
            i = {
              ["<C-n>"] = create_file,
              ["<C-d>"] = delete_file,
            },
          },
        },
        find_files = {
          hidden = true,
          mappings = {
            i = {
              ["<C-n>"] = create_file,
              ["<C-d>"] = delete_file,
            },
          },
        },
        git_branches = {
          mappings = {
            i = {
              ["<C-n>"] = create_branch,
              ["<C-d>"] = delete_branch,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")
  end,
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
    { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  },
}
