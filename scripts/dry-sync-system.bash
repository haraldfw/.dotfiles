#!/usr/bin/env bash
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

sudo nixos-rebuild dry-activate --flake $DOTFILES_DIR;
