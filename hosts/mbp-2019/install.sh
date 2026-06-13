#!/usr/bin/env bash
set -euo pipefail

source "$REPO_ROOT/lib.sh"

echo "Installing MBP 2019 Items..."

# Fix fan
install_file "$REPO_ROOT/hosts/$HOST_PROFILE/MBP-Omarchy-Hardware/etc-tiny-dfr/config.toml" \
             /etc/tiny-dfr/config.toml

# Fix trackpad so DWT works
install_file "$REPO_ROOT/hosts/$HOST_PROFILE/MBP-Omarchy-Hardware/etc-udev-hwdb.d/90-apple-internal.hwdb" \
             /etc/udev/hwdb.d/90-apple-internal.hwdb
install_file "$REPO_ROOT/hosts/$HOST_PROFILE/MBP-Omarchy-Hardware/etc-udev-rules.d/99-apple-internal-touchpad.rules." \
             /etc/udev/rules.d/99-apple-internal-touchpad.rules

# Restart services
sudo systemd-hwdb update
sudo udevadm control --reload
sudo udevadm trigger

# might be helpful agaist the jumping cursor
sudo sysctl vm.swappiness=10

# Install helm
tar -xzf "$REPO_ROOT/hosts/$HOST_PROFILE/helm-v3.15.4-linux-amd64.tar.gz"
sudo mv "$REPO_ROOT/hosts/$HOST_PROFILE/linux-amd64/helm" /usr/local/bin/helm
sudo chmod +x /usr/local/bin/helm
