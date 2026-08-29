#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO_NAME="dotfiles"
DOTFILES_REPO_URL="https://github.com/ghrubi/$DOTFILES_REPO_NAME.git"
DOTFILES_REPO_BRANCH="quattro"
STOW_DIR="$HOME/dotfiles"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

HOST_PROFILE="${1:-$(detect_host_profile || true)}"
[[ -n "$HOST_PROFILE" ]] || die "Usage: $0 mba-2017|mbp-2019"

export REPO_ROOT="$SCRIPT_DIR"
export HOST_PROFILE

start_sudo_keepalive

clone_or_pull "$DOTFILES_REPO_URL" "$STOW_DIR" "$DOTFILES_REPO_BRANCH"

install_packages "$SCRIPT_DIR/common/packages.txt"
install_packages "$SCRIPT_DIR/hosts/$HOST_PROFILE/packages.txt"

HOST_PRE_STOW="$SCRIPT_DIR/hosts/$HOST_PROFILE/pre-stow.sh"
if [[ -x "$HOST_PRE_STOW" ]]; then
  "$HOST_PRE_STOW"
fi

backup_stow_targets "$STOW_DIR/common"
backup_stow_targets "$STOW_DIR/hosts/$HOST_PROFILE"
stow_all_packages "$STOW_DIR/common"
stow_all_packages "$STOW_DIR/hosts/$HOST_PROFILE"

"$REPO_ROOT/common/install.sh"
"$REPO_ROOT/hosts/$HOST_PROFILE/install.sh"
