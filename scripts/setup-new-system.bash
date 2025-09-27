#!/usr/bin/env bash
# This script runs system and user sync
set -euo pipefail

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

read -p 'Enter hostname you want this system to sync to: ' SYNC_HOSTNAME

sudo nixos-rebuild switch --flake $DOTFILES_DIR#$SYNC_HOSTNAME;

echo System partially synced to new config, to complete sync reboot and then run scripts/sync.bash
read -p "Do you want to reboot now? (Y/n)? " yesno
case $yesno in
    [Nn]* ) 
        echo "Exiting without rebooting. Please reboot manually and run scripts/sync.bash"
        exit
    ;;
    * ) shutdown -r now;;
esac

