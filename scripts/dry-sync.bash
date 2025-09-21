#!/usr/bin/env bash
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

$DOTFILES_DIR/scripts/dry-sync-system.bash;

$DOTFILES_DIR/scripts/dry-sync-user.bash;
