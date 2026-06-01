#!/bin/bash

# Install docker and docker-compose
yay -S  --noconfirm --needed docker docker-compose

# Setup docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
