-- validate_launch.lua-- validate_launch.lua
local json = require("dkjson")
local f = io.open(".vscode/launch.json", "r")
if not f then
  print("Failed to open launch.json")
  return
end
local content = f:read("*all")
f:close()

local obj, pos, err = json.decode(content, 1, nil)
if err then
  print("Error parsing JSON:", err, "at position", pos)
else
  print("launch.json parsed successfully!")
  print("Loaded configurations:")
  for _, config in ipairs(obj.configurations) do
    print(" - " .. config.name .. " [" .. config.type .. "]")
  end
end
