#!/usr/bin/env bash
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

home-manager switch --flake $DOTFILES_DIR;
