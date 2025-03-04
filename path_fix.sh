#\!/bin/bash

# Base path to look for index.html files
BASE_PATH="/nextjs/path/here/out"

# Find all index.html files (including in subdirectories)
find "$BASE_PATH" -type f -name "index.html" | while read -r FILE_PATH; do
  echo "Processing $FILE_PATH"
  
  # Create a backup of the original file if it doesn't exist
  if [ \! -f "${FILE_PATH}.bak" ]; then
    cp "$FILE_PATH" "${FILE_PATH}.bak"
    echo "  Created backup as ${FILE_PATH}.bak"
  else
    # For testing: restore from backup to ensure clean state
    cp "${FILE_PATH}.bak" "$FILE_PATH"
    echo "  Restored from backup for clean run"
  fi

  # Calculate relative path depth
  # Remove the base path and count the number of directories
  REL_PATH=${FILE_PATH#$BASE_PATH/}
  DIRECTORY=$(dirname "$REL_PATH")
  
  # Set the appropriate prefix based on directory depth
  if [ "$DIRECTORY" == "." ]; then
    # For root index.html, use "./" prefix
    REL_PREFIX="./"
    echo "  Root index.html, using prefix: $REL_PREFIX"
  else
    # Count number of directory levels by counting slashes
    DEPTH=$(echo "$DIRECTORY" | tr -cd '/' | wc -c)
    DEPTH=$((DEPTH + 1))
    
    # Create the relative path prefix (../ for each level)
    REL_PREFIX=""
    for ((i=1; i<=DEPTH; i++)); do
      REL_PREFIX="../$REL_PREFIX"
    done
    
    echo "  Directory: $DIRECTORY, Depth: $DEPTH, Prefix: $REL_PREFIX"
  fi
  
  # Use sed to replace all src, poster, and href attributes
  # This adds the calculated relative path prefix to paths that start with a slash
  sed -i.tmp -E "s@(src=[\"'])/@\1$REL_PREFIX@g; s@(poster=[\"'])/@\1$REL_PREFIX@g; s@(href=[\"'])/@\1$REL_PREFIX@g" "$FILE_PATH"
  
  # Remove the temporary file created by sed
  rm -f "${FILE_PATH}.tmp"

  # Count modified attributes
  MODIFIED_SRC=$(grep -o "src=\"$REL_PREFIX" "$FILE_PATH" 2>/dev/null | wc -l)
  MODIFIED_POSTER=$(grep -o "poster=\"$REL_PREFIX" "$FILE_PATH" 2>/dev/null | wc -l)
  MODIFIED_HREF=$(grep -o "href=\"$REL_PREFIX" "$FILE_PATH" 2>/dev/null | wc -l)
  TOTAL_MODIFIED=$((MODIFIED_SRC + MODIFIED_POSTER + MODIFIED_HREF))
  
  echo "  Modified attributes: $TOTAL_MODIFIED (src: $MODIFIED_SRC, poster: $MODIFIED_POSTER, href: $MODIFIED_HREF)"
  
  # Show some examples of the modified paths
  echo "  Examples of modified paths:"
  grep -o "src=\"$REL_PREFIX[^\"]*\"" "$FILE_PATH" | head -3
done

echo "All index.html files processed\!"
