{ pkgs, ... }:
{
  imports = [
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    clang-tools

    go
    bun
    biome

    # gamedev
    godot
    aseprite
  ];
}
