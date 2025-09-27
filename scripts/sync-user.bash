#!/usr/bin/env bash
# This script syncs user-level config, everything managed by home-manager
set -euo pipefail

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);


home-manager switch --flake $DOTFILES_DIR;
