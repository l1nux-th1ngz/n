#!/bin/bash

# Loop through all .sh files in the current directory
for file in *.sh; do
  # Ensure the file exists and is a regular file
  if [ -f "$file" ]; then
    # Convert all types of line endings to LF
    dos2unix "$file"
  fi
done

echo "All files in the current directory have been fixed."
