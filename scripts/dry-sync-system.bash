#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

sudo nixos-rebuild dry-activate --flake $DOTFILES_DIR;
