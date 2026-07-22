{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools

    go
    bun
    biome
  ];
}
