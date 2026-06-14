#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO_NAME="dotfiles"
DOTFILES_REPO_URL="https://github.com/ghrubi/$DOTFILES_REPO_NAME.git"
STOW_DIR="$HOME/dotfiles"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

HOST_PROFILE="${1:-$(detect_host_profile || true)}"
[[ -n "$HOST_PROFILE" ]] || die "Usage: $0 mba-2017|mbp-2019"

backup_stow_targets "$STOW_DIR/common"
backup_stow_targets "$STOW_DIR/hosts/$HOST_PROFILE"
stow_all_packages "$STOW_DIR/common"
stow_all_packages "$STOW_DIR/hosts/$HOST_PROFILE"

