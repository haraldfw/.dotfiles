{ pkgs, ... }:
{
  home.packages = with pkgs; [
    webcord-vencord
    steam
    path-of-building

    neovim
    busybox
    htop

    ungoogled-chromium
    libreoffice
    nixd
    gimp
    vlc
    dunst

    go
    vscodium
    bun
    biome
  ];
}
