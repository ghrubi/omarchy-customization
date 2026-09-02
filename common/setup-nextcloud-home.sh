#!/usr/bin/env bash
set -euo pipefail

source "${REPO_ROOT:?REPO_ROOT must point to the omarchy-customization checkout}/lib.sh"

NEXTCLOUD_DIR="$HOME/Nextcloud"
NEXTCLOUD_CONFIG="$HOME/.config/Nextcloud/nextcloud.cfg"
REMOTE_HOME="/Home"
STANDARD_DIRS=(Documents Music Pictures Videos)

has_desired_sync() {
  [[ -f "$NEXTCLOUD_CONFIG" ]] || return 1

  local line prefix local_path
  while IFS= read -r line; do
    [[ "$line" == *'\localPath='* ]] || continue
    prefix="${line%localPath=*}"
    local_path="${line#*=}"

    if [[ "${local_path%/}" == "$NEXTCLOUD_DIR" ]] &&
       grep -qxF "${prefix}targetPath=$REMOTE_HOME" "$NEXTCLOUD_CONFIG"; then
      return 0
    fi
  done < "$NEXTCLOUD_CONFIG"

  return 1
}

preflight_home_links() {
  local name link target

  for name in "${STANDARD_DIRS[@]}"; do
    link="$HOME/$name"
    target="Nextcloud/$name"

    if [[ -L "$link" ]]; then
      case "$(readlink "$link")" in
        "$target"|"$NEXTCLOUD_DIR/$name") ;;
        *) die "$link is an unrelated symlink; refusing to replace it." ;;
      esac
    elif [[ -d "$link" ]]; then
      [[ -z "$(find "$link" -mindepth 1 -maxdepth 1 -print -quit)" ]] ||
        die "$link contains data; move it deliberately before rerunning this setup."
    elif [[ -e "$link" ]]; then
      die "$link exists and is not a directory; refusing to replace it."
    fi
  done
}

ensure_home_links() {
  local name link target

  preflight_home_links
  mkdir -p "$NEXTCLOUD_DIR"

  for name in "${STANDARD_DIRS[@]}"; do
    link="$HOME/$name"
    target="Nextcloud/$name"
    mkdir -p "$NEXTCLOUD_DIR/$name"

    if [[ -L "$link" ]]; then
      log "$link already points into Nextcloud"
      continue
    fi

    [[ ! -d "$link" ]] || rmdir -- "$link"
    ln -s -- "$target" "$link"
    log "Linked $link -> $target"
  done
}

provision_with_app_password() {
  need_cmd nextcloud

  if [[ -d "$NEXTCLOUD_DIR" ]] &&
     [[ -n "$(find "$NEXTCLOUD_DIR" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
    die "$NEXTCLOUD_DIR is not empty. The Nextcloud client refuses automated provisioning into a non-empty folder."
  fi

  local server_url user_id app_password
  read -r -p "Nextcloud server URL: " server_url
  read -r -p "Nextcloud user ID: " user_id
  read -r -s -p "Nextcloud app password (not your normal password): " app_password
  echo

  [[ -n "$server_url" ]] || die "A Nextcloud server URL is required."
  [[ -n "$user_id" ]] || die "A Nextcloud user ID is required."
  [[ -n "$app_password" ]] || die "A Nextcloud app password is required."

  nextcloud \
    --userid "$user_id" \
    --apppassword "$app_password" \
    --serverurl "$server_url" \
    --localdirpath "$NEXTCLOUD_DIR" \
    --remotedirpath "$REMOTE_HOME" \
    --isvfsenabled 0
  unset app_password

  has_desired_sync || die "Nextcloud provisioning returned without creating $REMOTE_HOME -> $NEXTCLOUD_DIR."
}

if ! has_desired_sync; then
  if [[ "${1:-}" == "--provision" ]]; then
    provision_with_app_password
  else
    cat <<EOF
==> Nextcloud needs one-time account authorization.

Open Nextcloud, sign in through the browser, and create one folder sync:
  remote folder: $REMOTE_HOME
  local folder:  $NEXTCLOUD_DIR
  virtual files: off

Then rerun this installer, or run:
  $REPO_ROOT/common/setup-nextcloud-home.sh

For fully automated provisioning with a one-time app password, run:
  $REPO_ROOT/common/setup-nextcloud-home.sh --provision
EOF
    exit 0
  fi
fi

ensure_home_links
log "Nextcloud ephemeral-home layout is configured."
