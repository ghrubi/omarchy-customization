#!/bin/bash
set -eEo pipefail
# Waybar power-profiles-daemon module configuration snippet

WAYBAR_CONFIG_DIR="${HOME}/.config/waybar"
MODULE_NAME="power-profiles-daemon"

update_waybar_config() {
  echo "Updating Waybar configuration..."

  local config_file="${WAYBAR_CONFIG_DIR}/config.jsonc"
  if [[ ! -f "${config_file}" ]]; then
    config_file="${WAYBAR_CONFIG_DIR}/config"
  fi

  if [[ ! -f "${config_file}" ]]; then
    echo "Waybar config file not found at ${config_file}"
    return 0
  fi

  local backup_file="${config_file}.backup.$(date +%Y%m%d-%H%M%S)"
  cp "${config_file}" "${backup_file}"
  echo "Backed up existing config to ${backup_file}"

  # Check if module already exists
  if jq -e --arg module "${MODULE_NAME}" '.[$module]' "${config_file}" &>/dev/null; then
    echo "${MODULE_NAME} already present in Waybar config"
    return 0
  fi

  # Add module to modules-right after custom/vpn
  if jq -e '.["modules-right"]' "${config_file}" &>/dev/null; then
    # Find custom/vpn and insert module right after it, preserving order
    jq --arg module "${MODULE_NAME}" '.["modules-right"] = (
      .["modules-right"] | 
      to_entries | 
      map(
        if .value == "custom/vpn" then 
          [., {"key": (.key + 0.5), "value": $module}]
        else 
          .
        end
      ) | 
      flatten | 
      sort_by(.key) | 
      map(.value)
    )' "${config_file}" > "${config_file}.tmp"
    mv "${config_file}.tmp" "${config_file}"
    echo "Added ${MODULE_NAME} to modules-right after custom/vpn"
  else
    echo "Could not find modules-right in config"
  fi

  # Add module definition
  jq '. += {
    "power-profiles-daemon": {
      "format": " {icon} ",
      "tooltip-format": "Power profile: {profile}nDriver: {driver}",
      "tooltip": true,
      "format-icons": {
        "default": "",
        "performance": "",
        "balanced": "",
        "power-saver": ""
      }
    }
  }' "${config_file}" > "${config_file}.tmp"
  
  mv "${config_file}.tmp" "${config_file}"
  echo "Added ${MODULE_NAME} module definition"
}

update_waybar_config
omarchy-restart-waybar