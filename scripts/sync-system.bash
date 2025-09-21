#!/usr/bin/env bash
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

sudo nixos-rebuild switch --flake $DOTFILES_DIR;
