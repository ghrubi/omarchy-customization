#!/bin/bash

set -e

CONFIG_NAME="Hyprland"
CONFIG="$HOME/.config/hypr/hyprland.conf"
OVERRIDES_CONFIG="$HOME/.config/hypr/custom.conf"
SOURCE_LINE="source = $OVERRIDES_CONFIG"

echo "Setting up $CONFIG_NAME overrides..."
# echo "$CONFIG_NAME config path: $CONFIG"
# echo "Overrides config path: $OVERRIDES_CONFIG"

# Check if hyprland config exists
if [ ! -f "$CONFIG" ]; then
    echo "$CONFIG_NAME config not found at $CONFIG"
    echo "Please install $CONFIG_NAME first"
    exit 1
fi

# Check if overrides config exists
if [ ! -f "$OVERRIDES_CONFIG" ]; then
    echo "Overrides config not found at $OVERRIDES_CONFIG"
    exit 1
fi

# Check if source line already exists in hyprland.conf
if grep -Fxq "$SOURCE_LINE" "$CONFIG"; then
    echo "Source line already exists in $CONFIG"
else
    echo "Adding source line to $CONFIG"
    echo "" >> "$CONFIG"
    echo "$SOURCE_LINE" >> "$CONFIG"
    echo "Source line added successfully"
fi

echo "$CONFIG_NAME overrides setup complete!"
