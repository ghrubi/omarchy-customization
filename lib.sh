#!/usr/bin/env bash

# Shared helpers for Omarchy customization scripts.
# Source this file; do not execute it directly.

set -euo pipefail

log() {
  echo "==> $*"
}

warn() {
  echo "WARN: $*" >&2
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

script_dir() {
  cd "$(dirname "${BASH_SOURCE[1]}")" >/dev/null 2>&1 && pwd
}

start_sudo_keepalive() {
  log "Requesting sudo access..."
  sudo -v

  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
}

install_packages() {
  local package_file="$1"

  [[ -f "$package_file" ]] || {
    warn "Package file not found: $package_file"
    return 0
  }

  mapfile -t packages < <(
    grep -v '^\s*#' "$package_file" |
      grep -v '^\s*$'
  )

  (( ${#packages[@]} )) || {
    warn "No packages found in: $package_file"
    return 0
  }

  log "Installing packages from: $package_file"
  log "Packages: ${packages[@]}"
  # yay -S --noconfirm --needed "${packages[@]}"
}

clone_or_pull() {
  local repo_url="$1"
  local target_dir="$2"

  if [[ -d "$target_dir/.git" ]]; then
    log "Updating repo: $target_dir"
    # git -C "$target_dir" pull --ff-only
  else
    log "Cloning repo: $repo_url -> $target_dir"
    # git clone "$repo_url" "$target_dir"
  fi
}

ensure_dir() {
  mkdir -p "$1"
}

ensure_sudo_dir() {
  sudo mkdir -p "$1"
}

ensure_line() {
  local line="$1"
  local file="$2"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  grep -qxF "$line" "$file" || {
    log "Adding line to: $file"
    echo "$line" >> "$file"
  }
}

ensure_block() {
  local file="$1"
  local marker="$2"
  local content="$3"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  if ! grep -q "BEGIN $marker" "$file"; then
    log "Adding block to: $file"

    cat >> "$file" <<EOF

# BEGIN $marker
$content
# END $marker
EOF
  fi
}

install_file() {
  local src="$1"
  local dst="$2"
  local mode="${3:-644}"

  log "Installing file: $src -> $dst"
  # sudo install -Dm"$mode" "$src" "$dst"
}

enable_service() {
  local service="$1"

  log "Enabling system service: $service"
  sudo systemctl enable --now "$service"
}

enable_user_service() {
  local service="$1"

  log "Enabling user service: $service"
  systemctl --user enable --now "$service"
}

backup_path_in_place() {
  local target="$1"
  local ts
  ts="$(date +"%Y%m%d-%H%M%S")"
  echo "${target}.omarchy-original.${ts}.bak"
}

backup_stow_targets() {
  local stow_root="$1"

  [[ -d "$stow_root" ]] || return 0

  log "Checking stow targets in: $stow_root"

  while IFS= read -r -d '' file; do
    local rel dst bak parent

    rel="${file#$stow_root/}"
    rel="${rel#*/}"
    dst="$HOME/$rel"

    # Skip if the target itself is a symlink
    [[ -L "$dst" ]] && continue

    # Skip if any parent directory is a symlink
    parent="$(dirname "$dst")"
    while [[ "$parent" != "$HOME" && "$parent" != "/" ]]; do
      if [[ -L "$parent" ]]; then
        log "Skipping $dst; parent is symlink: $parent"
        continue 2
      fi
      parent="$(dirname "$parent")"
    done

    [[ ! -e "$dst" ]] && continue
    [[ "$dst" == *.bak || "$dst" == *.omarchy-original.*.bak ]] && continue

    bak="$(backup_path_in_place "$dst")"
    log "Backing up: $dst -> $bak"
    # mv -f -- "$dst" "$bak"
  done < <(find "$stow_root" -mindepth 2 -type f -print0 | sort -z)
}

stow_all_packages() {
  local stow_root="$1"

  [[ -d "$stow_root" ]] || return 0

  log "Stowing packages from: $stow_root"

  while IFS= read -r -d '' pkg; do
    local package_name
    package_name="$(basename "$pkg")"

    log "Stowing: $package_name"
    # stow -R -d "$stow_root" -t "$HOME" "$package_name"
    stow -nvR -d "$stow_root" -t "$HOME" "$package_name"
  done < <(find "$stow_root" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

detect_host_profile() {
  local model
  model="$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || true)"

  case "$model" in
    *MacBookAir*) echo "mba-2017" ;;
    *MacBookPro*) echo "mbp-2019" ;;
    *) return 1 ;;
  esac
}

