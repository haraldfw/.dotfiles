#!/usr/bin/env bash
# Format all nix files in the repo

shopt -s globstar
nixfmt ./**/*.nix
