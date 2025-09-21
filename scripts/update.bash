#!/usr/bin/env bash
# This script updates flake and channels.

DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd);

pushd $SCRIPT_DIR &> /dev/null;
sudo nix flake update;
sudo nix-channel --update;
nix-channel --update;
popd &> /dev/null;
