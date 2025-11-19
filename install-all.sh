#!/bin/bash

set -e  # Exit immediately on error
set -u  # Treat unset variables as errors
set -o pipefail  # Catch errors in pipes

# Get the name of this script
SELF=$(basename "$0")

# Loop through all install-*.sh files
for script in install-*.sh; do
  # Skip if this file
  if [[ "$script" == "$SELF" ]]; then
    continue
  fi

  # Check if it's a regular file and executable
  if [[ -f "$script" && -x "$script" ]]; then
    echo "Executing $script..."
    ./"$script"
  else
    echo "Skipping $script (not executable or not a regular file)"
  fi
done

echo "All install scripts executed."

