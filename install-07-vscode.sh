#!/bin/bash

# Install visual-studio-code-bin from AUR
yay -S --noconfirm --needed visual-studio-code-bin

# Configuration
set -e

WAIT_TIME=5
CONFIG_NAME="VSCode"
CONFIG="$HOME/.vscode/argv.json"
CONFIG_ENTRY=',"password-store": "gnome-libsecret"'
CONFIG_LINE="\n\t// Add support for keyring\n\t$CONFIG_ENTRY"

echo "Setting up $CONFIG_NAME config..."
echo "Starting up $CONFIG_NAME and waiting for $WAIT_TIME seconds ..."
 
code &
sleep $WAIT_TIME

# Check if config exists
if [ ! -f "$CONFIG" ]; then
    echo "$CONFIG_NAME config not found at $CONFIG"
    echo "Please install $CONFIG_NAME first"
    exit 0
fi

# Check if config line already exists in hyprland.conf
if grep -Fq "$CONFIG_ENTRY" "$CONFIG"; then
    echo "Config line already exists in $CONFIG"
else
    echo "Adding config line to $CONFIG"
    # echo "" >> "$CONFIG"
    # echo "$CONFIG_LINE" >> "$CONFIG"
    # echo "Config line added successfully"
    awk -v line="$CONFIG_LINE" '
        BEGIN {count=0}
        {
            if ($0 ~ /^}/) {
                print line
            }
            print
        }
    ' "$CONFIG" > "${CONFIG}.tmp" && cp "${CONFIG}.tmp" "$CONFIG"
    echo "Config line added successfully"
fi

echo "$CONFIG_NAME config setup complete!"
