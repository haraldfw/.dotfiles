#!/usr/bin/env bash
# This script syncs system-level config, everything not managed by home-manager.
set -euo pipefail

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

sudo nixos-rebuild switch --flake $DOTFILES_DIR;
