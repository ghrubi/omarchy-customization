#!/bin/bash

# Configure
USERNAME="ghrubi@yahoo.com"
MEGA_DIR="/home/gene/MEGA"
LOCAL_DIR="/projects"

# Prompt user to login to their MEGA account
echo "Logging into Mega:"
read -s -p "Enter your password for the next step: " user_password
mega-login $USERNAME $user_password

# Set up synchronization between local MEGA folder and local directory
echo "Setting up synchronization between $MEGA_DIR and $LOCAL_DIR"
mkdir $MEGA_DIR
mega-sync $MEGA_DIR $LOCAL_DIR

# MEGA Symlink
ln -s $MEGA_DIR "$HOME/$LOCAL_DIR"
