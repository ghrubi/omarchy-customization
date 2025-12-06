#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PACKAGES=("bash" "hypr" "nvim" "ghostty" "starship" "bin")

REPO_NAME="dotfiles"
REPO_URL="https://github.com/ghrubi/$REPO_NAME.git"
DEFAULT_STOW_DIR="$HOME/dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

# Determine the stow directory
if [ -z "${STOW_DIR:-}" ]; then
  export STOW_DIR="$DEFAULT_STOW_DIR"
fi

# Home for the repo check and, possible, clone
cd "$HOME"

# Clone the repository if it doesn't exist
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  echo "Cloning repository '$REPO_NAME'..."
  git clone "$REPO_URL"
fi

# Back to this directory
cd "$SCRIPT_DIR"

for PACKAGE in "${PACKAGES[@]}"; do
  SOURCE="$STOW_DIR/$PACKAGE" bash -c '
  set -euo pipefail

  # --- Helpers ---
  timestamp() { date +"%Y%m%d-%H%M%S"; }
  backup_path() { echo "${1}.bak.$(timestamp)"; }

  while IFS= read -r -d "" file; do
    rp=$(command -v realpath > /dev/null 2>&1 && realpath --relative-to="$SOURCE" "$file" || echo "${file#$SOURCE/}")
    dst="$HOME/$rp"
    if [[ -L "$dst" ]]; then
      echo "Skipping $dst (already a symlink by stow)"
      continue
    fi

    if [ -e "$dst" ]; then
      #echo "TARGET: $dst (exists)"
      bak=$(backup_path $dst)
      #echo "$dst -> $bak"
      mv -f -- $dst $bak
    # else
    #   echo "TARGET: $dst (does not exist)"
    fi
  done < <(find "$SOURCE" -type f -print0 | sort -z)'

  stow -t "$HOME" $PACKAGE
done

