#!/usr/bin/env bash
# This script runs system and user sync

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

$DOTFILES_DIR/scripts/sync-system.bash;
$DOTFILES_DIR/scripts/sync-user.bash;
