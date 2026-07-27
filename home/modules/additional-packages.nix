{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imagemagick

    gimp
    libreoffice
    spotify
    ungoogled-chromium
    vlc
  ];
}
