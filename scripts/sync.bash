#!/usr/bin/env bash
# This script runs system and user sync
set -euo pipefail

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

$DOTFILES_DIR/scripts/sync-system.bash;

while ! ping -c 4 1.1.1.1 > /dev/null;
do
	echo "Waiting for network before continuing..."
	sleep 1
done

echo "The network is back"

$DOTFILES_DIR/scripts/sync-user.bash;
