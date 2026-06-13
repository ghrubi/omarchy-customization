#!/bin/bash
set -eEo pipefail
# Waybar MPRIS module configuration snippet

WAYBAR_CONFIG_DIR="${HOME}/.config/waybar"

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

  # Check if mpris already exists
  if jq -e '.["mpris"]' "${config_file}" &>/dev/null; then
    echo "mpris already present in Waybar config"
    return 0
  fi

  # Add mpris to modules-left after hyprland/workspaces
  if jq -e '.["modules-left"]' "${config_file}" &>/dev/null; then
    # Find hyprland/workspaces and insert mpris right after it, preserving order
    jq '.["modules-left"] = (
      .["modules-left"] | 
      to_entries | 
      map(
        if .value == "hyprland/workspaces" then 
          [., {"key": (.key + 0.5), "value": "mpris"}]
        else 
          .
        end
      ) | 
      flatten | 
      sort_by(.key) | 
      map(.value)
    )' "${config_file}" > "${config_file}.tmp"
    mv "${config_file}.tmp" "${config_file}"
    echo "Added mpris to modules-left after hyprland/workspaces"
  else
    echo "Could not find modules-left in config"
  fi

  # Add mpris module definition
  jq '. += {
    "mpris": {
      "format": "   {player_icon} {status_icon} <i>{artist} - {title}</i>",
      "player": "playerctld",
      "max-length": 50,
      "on-click": "playerctl play-pause",
      "format-paused": "   {player_icon} {status_icon} {artist} - {title}",
      "player-icons": {
        "default": " ",
        "spotify": " ",
        "mpv": " "
      },
      "status-icons": {
        "paused": "⏸",
        "playing": "▶"
      }
    }
  }' "${config_file}" > "${config_file}.tmp"
  
  mv "${config_file}.tmp" "${config_file}"
  echo "Added mpris module definition"
}

update_waybar_config
omarchy-restart-waybar
