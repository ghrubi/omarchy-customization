#!/usr/bin/env bash
set -euo pipefail

source "$REPO_ROOT/lib.sh"

echo "Installing Common Items..."

# Set theme
omarchy theme set "Hallow Gene"

# Setup docker
# sudo systemctl enable --now docker
enable_service docker
sudo usermod -aG docker $USER

"$REPO_ROOT/common/hyprland-custom.sh"
"$REPO_ROOT/common/remove-apps.sh"
"$REPO_ROOT/common/setup-wireguard-vpn.sh"
"$REPO_ROOT/common/waybar-add-mpris.sh"
"$REPO_ROOT/common/waybar-add-powerprofiles.sh"
"$REPO_ROOT/common/install-claude.sh"
"$REPO_ROOT/common/config-vscode.sh"

