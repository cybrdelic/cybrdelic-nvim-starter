-- ./lua/config/keymaps.lua

-- Require the utils module
local utils = require("utils")

-- Existing keymaps...
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)

-- Function to run commitaura in a floating terminal
vim.keymap.set("n", "<leader>gA", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local commitaura = Terminal:new({
    cmd = "commitaura",
    direction = "float",
    close_on_exit = false,
    float_opts = {
      border = "curved",
      width = function()
        return math.floor(vim.o.columns * 0.8)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.8)
      end,
      winblend = 0,
    },
  })
  commitaura:toggle()
end, { desc = "Commit with Commitaura" })

-- Keybinding to open GitHub PAT creation page
vim.keymap.set("n", "<leader>gP", function()
  utils.open_url("https://github.com/settings/tokens/new")
end, { noremap = true, silent = true, desc = "Create GitHub PAT" })

-- Function to prompt the user and add the input to .gitignore
local function prompt_and_add_to_gitignore()
  -- Get the Git root directory
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root == "" then
    vim.notify("Not inside a Git repository", vim.log.levels.ERROR)
    return
  end

  -- Prompt the user for the line to add
  vim.ui.input({ prompt = "Enter the pattern to add to .gitignore: " }, function(input)
    if input == nil or input == "" then
      vim.notify("No input provided", vim.log.levels.ERROR)
      return
    end

    -- Trim whitespace from the input
    input = vim.trim(input)

    -- Path to the .gitignore file
    local gitignore_path = git_root .. "/.gitignore"

    -- Read existing .gitignore entries
    local lines = {}
    if vim.fn.filereadable(gitignore_path) == 1 then
      lines = vim.fn.readfile(gitignore_path)
      -- Check if the input is already in .gitignore
      for _, line in ipairs(lines) do
        if line == input then
          vim.notify("Entry is already in .gitignore", vim.log.levels.INFO)
          return
        end
      end
    end

    -- Append the input to .gitignore
    table.insert(lines, input)
    local ok, err = pcall(vim.fn.writefile, lines, gitignore_path)
    if not ok then
      vim.notify("Error writing to .gitignore: " .. err, vim.log.levels.ERROR)
    else
      vim.notify('Added "' .. input .. '" to .gitignore', vim.log.levels.INFO)
    end
  end)
end

-- Keybinding to prompt and add to .gitignore
vim.keymap.set("n", "<leader>gI", prompt_and_add_to_gitignore, { desc = "Add to .gitignore" })

-- Function to run 'git add .'
local function git_add_all()
  -- Check if we're inside a Git repository
  local is_git_repo = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
  if is_git_repo ~= "true" then
    vim.notify("Not inside a Git repository", vim.log.levels.ERROR)
    return
  end

  -- Run 'git add .'
  local result = vim.fn.systemlist("git add . 2>&1")
  if vim.v.shell_error == 0 then
    vim.notify("All changes have been staged", vim.log.levels.INFO)
  else
    vim.notify("Error staging changes: " .. table.concat(result, "\n"), vim.log.levels.ERROR)
  end
end

-- Keybinding to run 'git add .'
vim.keymap.set("n", "<leader>ga", git_add_all, { desc = "Git Add All" })
