{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    steam
    path-of-building

    neovim
    busybox
    htop

    librewolf
    ungoogled-chromium
    libreoffice
    nixd
    gimp
    vlc
    dunst

    go
    vscodium
    nixfmt
    bun
    biome
  ];
}
