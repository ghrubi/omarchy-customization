#!/bin/bash

RESOLVCONF="/etc/resolv.conf"
SYSTEMD_RESOLVCONF="/run/systemd/resolve/resolv.conf"

# Configure DNS settings
echo "Configuring DNS settings..."
omarchy-setup-dns DHCP

# /etc/resolv.conf needs to point to systemd-resolved's resolver
# if [[ -L "$RESOLVCONF" ]]; then
#     echo "$RESOLVCONF is already a link."
# else
    echo "Linking $RESOLVCONF to $SYSTEMD_RESOLVCONF"
    sudo rm "$RESOLVCONF"
    sudo ln -s "$SYSTEMD_RESOLVCONF" "$RESOLVCONF"
# fi
