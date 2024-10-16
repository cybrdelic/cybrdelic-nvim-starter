-- ./lua/utils.lua
local M = {}

function M.open_url(url)
  local cmd
  if vim.fn.has("mac") == 1 then
    cmd = { "open", url }
  elseif vim.fn.has("unix") == 1 then
    cmd = { "xdg-open", url }
  elseif vim.fn.has("win32") == 1 then
    cmd = { "cmd.exe", "/C", "start", url }
  else
    vim.notify("Unsupported OS for opening URLs", vim.log.levels.ERROR)
    return
  end
  vim.fn.jobstart(cmd, { detach = true })
end

return M
