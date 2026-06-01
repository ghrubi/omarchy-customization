#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
THEME_DIR="$HOME/.config/omarchy/themes"
CURRENT_THEME_BACKGROUNDS_DIR="$HOME/.config/omarchy/current/theme/backgrounds"
THEME_NAME="all-hallows-eve"
THEME_PATH="$THEME_DIR/$THEME_NAME"
THEME_URL="https://github.com/guilhermetk/omarchy-all-hallows-eve-theme"

# Install theme
echo "Installing $THEME_NAME theme..."
omarchy-theme-install $THEME_URL >/dev/null 2>&1

# Create symbolic link for the background image
# ln -s $SCRIPT_DIR/arch-wallpaper-long-logo.jpg $THEME_PATH/backgrounds/
ln -s $SCRIPT_DIR/arch-wallpaper-long-logo.jpg $CURRENT_THEME_BACKGROUNDS_DIR

# Set the new background image
omarchy-theme-bg-next

