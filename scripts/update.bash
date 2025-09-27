#!/usr/bin/env bash
# This script updates flake and channels.
set -euo pipefail

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

pushd $SCRIPT_DIR &> /dev/null;
echo Updating flake...
sudo nix flake update;
echo Updating nix-channel as root...
sudo nix-channel --update;
echo Updating nix-channel as user...
nix-channel --update;
popd &> /dev/null;
