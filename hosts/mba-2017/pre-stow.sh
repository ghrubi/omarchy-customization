#!/usr/bin/env bash
set -euo pipefail

source "$REPO_ROOT/lib.sh"

log "Applying MBA 2017 font and text density..."
omarchy font set "JetBrainsMono Nerd Font"
omarchy display text size 10
