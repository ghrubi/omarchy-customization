#!/bin/bash
# This script removes unwanted applications from a Linux system.

# List of applications to remove
APPS_TO_REMOVE=(
    "1password-beta"
    "1password-cli"
    "kdenlive"
    "obs-studio"
    "obsidian"
    "signal-desktop"
    "spotify"
)

WEBAPPS_TO_REMOVE=(
    "HEY"
    "Basecamp"
    "Fizzy"
    "WhatsApp"
    "Google Photos"
    "Google Contacts"
    "Google Messages"
    "Google Maps"
    "X"
    "Figma"
    "Discord"
    "Zoom"
)

echo "Starting removal of unwanted applications..."
# Loop through each application and remove it
for APP in "${APPS_TO_REMOVE[@]}"; do
    echo "Removing $APP..."
    sudo pacman -Rns --noconfirm "$APP" >/dev/null 2>&1
done

echo "Starting removal of unwanted web applications..."
# Loop through each web application and remove it
for WEBAPP in "${WEBAPPS_TO_REMOVE[@]}"; do
    echo "Removing web application $WEBAPP..."
    omarchy-webapp-remove "$WEBAPP"
    sleep 2 # slow down for elephant to keep up
done

