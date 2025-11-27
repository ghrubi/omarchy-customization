#!/bin/bash

# Install telegram-desktop from AUR
# Hack due to telegram-desktop 404 in omarchy repo
omarchy-refresh-pacman edge
yay -S --noconfirm --needed telegram-desktop
omarchy-refresh-pacman

