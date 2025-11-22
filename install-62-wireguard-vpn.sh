#!/bin/bash

NAME="WireGuard VPN"
SCRIPT_URL="https://raw.githubusercontent.com/JacobusXIII/omarchy-wireguard-vpn-toggle/main/install.sh"
INSTALL_CMD="curl -fsSL $SCRIPT_URL | bash"
DIRECTORY="/etc/wireguard"
COMMAND="resolvconf"
LOCAL_BIN="/usr/local/bin/$COMMAND"
LINK_TO="/usr/bin/resolvectl"

# Install 
echo "Installing $NAME..."
($INSTALL_CMD)

if [ ! -d "$DIRECTORY" ]; then
    echo "$DIRECTORY does not exist, creating..."
    sudo mkdir -p "$DIRECTORY"
fi
echo "$NAME config files need to be placed in $DIRECTORY"
echo "$NAME installation complete!"

# Check for command
if ! command -v $COMMAND &> /dev/null; then
    echo "$COMMAND command not found, linking to $LINK_TO..."
    sudo ln -s $LINK_TO $LOCAL_BIN
else
    echo "$COMMAND command found."
fi
