#!/usr/bin/env bash
set -euo pipefail

source "$REPO_ROOT/lib.sh"

echo "Installing Common Items..."

# Setup docker
# sudo systemctl enable --now docker
# enable_service docker
# sudo usermod -aG docker $USER

"$REPO_ROOT/common/remove-apps.sh"

WIREGUARD_PLUGIN_ID="glafeara.wireguard"
WIREGUARD_PLUGIN_URL="https://github.com/glafeara/omarchy-wireguard.git"
if omarchy plugin list --json | jq -e --arg id "$WIREGUARD_PLUGIN_ID" \
  'any(.[]; .id == $id)' >/dev/null; then
  omarchy plugin enable "$WIREGUARD_PLUGIN_ID" --section right
else
  omarchy plugin add "$WIREGUARD_PLUGIN_URL" --enable --yes
fi

"$REPO_ROOT/common/setup-nextcloud-home.sh"
# "$REPO_ROOT/common/install-claude.sh"
# "$REPO_ROOT/common/config-vscode.sh"
