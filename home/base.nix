{ pkgs, ... }:
{
  home.packages = with pkgs; [
    webcord-vencord
    steam
    path-of-building

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
  ];
}
