-- ./lua/config/keymaps.lua

-- Require necessary modules
local utils = require("utils")
local telescope_builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local wk = require("which-key")

-- Function to copy all keymaps to the clipboard
local function copy_all_keymaps()
  local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }
  local keymaps = {}
  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      -- Format the keymap information
      local line =
        string.format("Mode: %s | LHS: %s | RHS: %s | Desc: %s", mode, map.lhs, map.rhs or "", map.desc or "")
      table.insert(keymaps, line)
    end
  end
  local output = table.concat(keymaps, "\n")
  vim.fn.setreg("+", output) -- Copy to the system clipboard
  vim.notify("All keymaps copied to clipboard", vim.log.levels.INFO)
end

-- Function to create a new note
local function create_new_note()
  local notes_dir = vim.fn.expand("~/notes")

  -- Prompt for the note title
  vim.ui.input({ prompt = "New note title: " }, function(input)
    if input == nil or input == "" then
      vim.notify("Note creation cancelled", vim.log.levels.INFO)
      return
    end

    -- Replace spaces with underscores and remove special characters
    local filename = input:gsub("%s+", "_"):gsub("[^%w_]", "") .. ".md"
    local filepath = notes_dir .. "/" .. filename

    -- Check if the file already exists
    if vim.fn.filereadable(filepath) == 1 then
      vim.notify("A note with that name already exists", vim.log.levels.ERROR)
      return
    end

    -- Create the new note file
    vim.fn.writefile({}, filepath)
    vim.cmd("edit " .. vim.fn.fnameescape(filepath))

    -- Insert the title into the file
    vim.api.nvim_put({ "# " .. input, "" }, "l", true, true)
  end)
end

-- Function to manage notes in ~/notes directory
local function manage_notes()
  local notes_dir = vim.fn.expand("~/notes")

  -- Check if the notes directory exists
  if vim.fn.isdirectory(notes_dir) == 0 then
    vim.notify("Notes directory does not exist: " .. notes_dir, vim.log.levels.ERROR)
    return
  end

  -- Use Telescope to browse and manage notes
  telescope_builtin.find_files({
    prompt_title = "Notes",
    cwd = notes_dir,
    attach_mappings = function(prompt_bufnr, map)
      -- Open the selected note
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local filename = selection.path
        vim.cmd("edit " .. vim.fn.fnameescape(filename))
      end)

      -- Add a keybinding to create a new note
      map("i", "<C-n>", function()
        actions.close(prompt_bufnr)
        vim.schedule(create_new_note)
      end)

      map("n", "<C-n>", function()
        actions.close(prompt_bufnr)
        vim.schedule(create_new_note)
      end)

      return true
    end,
  })
end

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

-- Function to run './copy.sh' script
local function run_copy_sh()
  -- Get the current working directory
  local cwd = vim.fn.getcwd()

  -- Construct the full path to the script
  local script_path = cwd .. "/copy.sh"

  -- Check if the script exists
  if vim.fn.filereadable(script_path) == 0 then
    vim.notify("Script not found: " .. script_path, vim.log.levels.ERROR)
    return
  end

  -- Run the script asynchronously
  vim.fn.jobstart({ "bash", script_path }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Script executed successfully", vim.log.levels.INFO)
      else
        vim.notify("Script exited with code " .. code, vim.log.levels.ERROR)
      end
    end,
  })
end

-- Function to run commitaura in a floating terminal
local function run_commitaura()
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
end

-- Overpowered Keybindings
-- These keybindings aim to enhance productivity and provide quick access to common actions.

-- General Keybindings
vim.keymap.set("n", "<leader>uK", copy_all_keymaps, { desc = "Copy All Keymaps" })
vim.keymap.set("n", "<leader>tN", manage_notes, { desc = "Manage Notes" })
vim.keymap.set("n", "<leader>sx", telescope_builtin.resume, { desc = "Resume Telescope" })
vim.keymap.set("n", "<leader>gI", prompt_and_add_to_gitignore, { desc = "Add to .gitignore" })
vim.keymap.set("n", "<leader>ga", git_add_all, { desc = "Git Add All" })
vim.keymap.set("n", "<leader>cs", run_copy_sh, { desc = "Run copy.sh" })
vim.keymap.set("n", "<leader>gA", run_commitaura, { desc = "Commit with Commitaura" })

-- Advanced Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Buffer Navigation
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })

-- Quick Save and Quit
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save Buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit All" })

-- Resize Splits
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Width" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-k>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- Quickfix and Location Lists
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open Quickfix List" })

-- Toggle Settings
vim.keymap.set("n", "<leader>tn", "<cmd>set number!<cr>", { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>tr", "<cmd>set relativenumber!<cr>", { desc = "Toggle Relative Numbers" })
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle Word Wrap" })
vim.keymap.set("n", "<leader>ts", "<cmd>set spell!<cr>", { desc = "Toggle Spelling" })

-- Search and Replace
vim.keymap.set("n", "<leader>sr", ":%s//g<Left><Left>", { desc = "Search and Replace" })

-- Clear Search Highlighting
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlighting" })

-- Git Integration
vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git Status" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git Commit" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git Push" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git pull<cr>", { desc = "Git Pull" })
vim.keymap.set("n", "<leader>gP", function()
  utils.open_url("https://github.com/settings/tokens/new")
end, { desc = "Create GitHub PAT" })

-- Terminal Toggle
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- Rename File Function
local function rename_file()
  local old_name = vim.fn.expand("%")
  vim.ui.input({ prompt = "New filename: ", default = vim.fn.fnamemodify(old_name, ":t") }, function(input)
    if input and input ~= "" and input ~= old_name then
      local new_name = vim.fn.fnamemodify(old_name, ":h") .. "/" .. input
      local ok, err = os.rename(old_name, new_name)
      if not ok then
        vim.notify("Error renaming file: " .. err, vim.log.levels.ERROR)
      else
        vim.cmd("edit " .. new_name)
        vim.notify("File renamed to " .. new_name, vim.log.levels.INFO)
      end
    else
      vim.notify("Rename cancelled", vim.log.levels.INFO)
    end
  end)
end

vim.keymap.set("n", "<leader>fr", rename_file, { desc = "Rename Current File" })

-- Overpowered Which-Key Registrations
wk.register({
  u = {
    name = "Utilities",
    K = { copy_all_keymaps, "Copy All Keymaps" },
  },
  t = {
    name = "Tools",
    N = { manage_notes, "Manage Notes" },
  },
  f = {
    name = "Files",
    r = { rename_file, "Rename Current File" },
  },
  g = {
    name = "Git",
    s = { "<cmd>Git<cr>", "Git Status" },
    c = { "<cmd>Git commit<cr>", "Git Commit" },
    p = { "<cmd>Git push<cr>", "Git Push" },
    l = { "<cmd>Git pull<cr>", "Git Pull" },
    I = { prompt_and_add_to_gitignore, "Add to .gitignore" },
    a = { git_add_all, "Git Add All" },
    A = { run_commitaura, "Commit with Commitaura" },
    P = {
      function()
        utils.open_url("https://github.com/settings/tokens/new")
      end,
      "Create GitHub PAT",
    },
  },
  c = {
    name = "Custom",
    s = { run_copy_sh, "Run copy.sh" },
  },
  s = {
    name = "Search",
    r = { ":%s//g<Left><Left>", "Search and Replace" },
    x = { telescope_builtin.resume, "Resume Telescope" },
  },
  h = { "<cmd>nohlsearch<cr>", "Clear Search Highlighting" },
  w = { "<cmd>w<cr>", "Save Buffer" },
  q = { "<cmd>q<cr>", "Quit" },
  Q = { "<cmd>qa!<cr>", "Quit All" },
  ["tt"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
}, { prefix = "<leader>" })
