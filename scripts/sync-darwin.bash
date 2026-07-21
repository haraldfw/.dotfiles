#!/usr/bin/env bash
# This script syncs user-level config on darwin-systems, everything managed by home-manager on macs
set -euo pipefail

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

sudo darwin-rebuild switch --flake $DOTFILES_DIR;
