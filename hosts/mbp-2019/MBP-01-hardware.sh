#!/bin/bash

# Installs MBP hardware-specific files

# udev Hardware files
HARDWARE_DB_DIR=/etc/udev/hwdb.d
HARDWARE_FILE_DIR=./MBP-Omarchy-Hardware/etc-udev-hwdb.d
HARDWARE_FILE_NAME=90-apple-internal.hwdb
HARDWARE_FILE=$HARDWARE_FILE_DIR/$HARDWARE_FILE_NAME
HADEWARE_DB_FILE=$HARDWARE_DB_DIR/$HARDWARE_FILE_NAME

# udev rules
RULES_DIR=/etc/udev/rules.d
RULES_FILE_DIR=./MBP-Omarchy-Hardware/etc-udev-rules.d
RULES_FILE_TOUCHPAD_NAME=99-apple-internal-touchpad.rules
RULES_FILE_TOUCHBAR_NAME=99-apple-touetcchbar-power.rules
TOUCHPAD_FILE=$RULES_FILE_DIR/$RULES_FILE_TOUCHPAD_NAME
TOUCHBAR_FILE=$RULES_FILE_DIR/$RULES_FILE_TOUCHBAR_NAME
RULES_TOUCHPAD_FILE=$RULES_DIR/$RULES_FILE_TOUCHPAD_NAME
RULES_TOUCHBAR_FILE=$RULES_DIR/$RULES_FILE_TOUCHBAR_NAME

# tiny-dfr fan config
TINY_DFR_DIR=/etc/tiny-dfr
FAN_FILE_DIR=./MBP-Omarchy-Hardware/etc-tiny-dfr
FAN_FILE_NAME=config.toml
FAN_FILE=$FAN_FILE_DIR/$FAN_FILE_NAME
TINY_DFR_FILE=$TINY_DFR_DIR/$FAN_FILE_NAME

# Put MBP hardware-specific files in place
echo "copying MBP hardware-specific files..."

# Hardware files
echo "copying $HARDWARE_FILE to $HADEWARE_DB_FILE"
sudo cp $HARDWARE_FILE $HADEWARE_DB_FILE

# Rules files
echo "copying $TOUCHPAD_FILE to $RULES_TOUCHPAD_FILE"
sudo cp $TOUCHPAD_FILE $RULES_TOUCHPAD_FILE
echo "copying $TOUCHBAR_FILE to $RULES_TOUCHBAR_FILE"
sudo cp $TOUCHBAR_FILE $RULES_TOUCHBAR_FILE

# Fan files
echo "copying $FAN_FILE to $TINY_DFR_FILE"
sudo cp $FAN_FILE $TINY_DFR_FILE

# Restart hardware services
echo "restarting MBP hardware-specific services..."
sudo systemd-hwdb update
sudo udevadm control --reload
sudo udevadm trigger
