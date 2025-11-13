{ pkgs, ... }:
{
  home.packages = with pkgs; [
    webcord
    steam
    rusty-path-of-building
    spotify

    neovim
    htop

    ungoogled-chromium
    libreoffice
    gimp
    vlc
    dunst

    go
    bun
    biome

    godot
    aseprite
  ];
}
