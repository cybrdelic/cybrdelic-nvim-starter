#!/bin/bash

# Check if xclip or pbcopy (depending on OS) is installed
if ! command -v xclip &>/dev/null && ! command -v pbcopy &>/dev/null; then
    echo "Please install xclip (for Linux) or pbcopy (for macOS) to use the clipboard feature."
    exit 1
fi

# Create a temporary file to store the lua file paths and their content
temp_file=$(mktemp)

# Find all .lua files recursively and write their paths into the temporary file
find . -name "*.lua" | while read -r lua_file; do
    echo "File: $lua_file" >> "$temp_file"
    echo "" >> "$temp_file"
    cat "$lua_file" >> "$temp_file"
    echo "" >> "$temp_file"
done

# Check if we're on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Use pbcopy to copy to the clipboard
    cat "$temp_file" | pbcopy
else
    # Linux: Use xclip to copy to the clipboard
    cat "$temp_file" | xclip -selection clipboard
fi

# Cleanup
rm "$temp_file"

echo "All Lua file names and their contents have been copied to the clipboard!"
