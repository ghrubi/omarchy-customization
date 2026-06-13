#!/usr/bin/env bash
set -euo pipefail

source "$REPO_ROOT/lib.sh"

echo "Installing MBA 2017 Items..."

"$REPO_ROOT/hosts/$HOST_PROFILE/setup-megacmd.sh"
