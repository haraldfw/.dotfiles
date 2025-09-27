#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

home-manager -n switch --flake $DOTFILES_DIR;
