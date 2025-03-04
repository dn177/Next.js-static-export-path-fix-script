#\!/bin/bash

# Path to the index.html file
FILE_PATH="/your/nextjsproject/path/here/out/index.html"

# Restore from backup if it exists
if [ -f "${FILE_PATH}.bak" ]; then
  cp "${FILE_PATH}.bak" "$FILE_PATH"
  echo "Restored from backup for a clean run"
else
  # Create a backup of the original file
  cp "$FILE_PATH" "${FILE_PATH}.bak"
  echo "Created backup as ${FILE_PATH}.bak"
fi

# Use sed to replace all src, poster, and href attributes
# This adds a period before any path that starts with a slash
sed -i.tmp -E 's/(src=["'"'"'])\/([^/])/\1.\/\2/g; s/(poster=["'"'"'])\/([^/])/\1.\/\2/g; s/(href=["'"'"'])\/([^/])/\1.\/\2/g' "$FILE_PATH"

# Remove the temporary file created by sed
rm -f "${FILE_PATH}.tmp"

echo "Replaced src, poster and href attributes in $FILE_PATH"

# Validate the file by checking a few examples
echo "Checking a few examples from the processed file:"
grep -o 'src="[^"]*"' "$FILE_PATH" | grep -v "http" | head -5
grep -o 'poster="[^"]*"' "$FILE_PATH" | head -5
