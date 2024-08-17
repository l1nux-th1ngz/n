#!/bin/bash

# First, ensure all .sh files have the correct line endings
echo "Converting line endings to LF for all .sh files..."
for file in *.sh; do
  if [ -f "$file" ]; then
    dos2unix "$file"
  fi
done

echo "All files in the current directory have been fixed."

# Change permissions of all files and directories in the current directory to 777
echo "Changing permissions to 777 for all files and directories..."
chmod -R 777 ./*

# Move everything to the user's home directory
echo "Moving all files and directories to the home directory..."
mv ./* "$HOME/"

# Execute the scripts in the specified order with delays

# 1. Run fix.sh first
echo "Running fix.sh..."
bash "$HOME/fix.sh"

# 2. Run one.sh second
echo "Running one.sh..."
bash "$HOME/one.sh"

# 3. Run all other .sh files with a 3-second sleep in between
for script in "$HOME"/*.sh; do
  if [[ "$script" != "$HOME/fix.sh" && "$script" != "$HOME/one.sh" && "$script" != "$HOME/bports.sh" ]]; then
    echo "Running $script..."
    bash "$script"
    sleep 3
  fi
done

# 4. Run bports.sh last
echo "Running bports.sh..."
bash "$HOME/bports.sh"
