{ pkgs, username, ... }:
{
  imports = [
    ./alacritty.nix
    ./development
    ./hyprland.nix
    ./librewolf.nix
    ./nixvim
    ./waybar.nix
    ./xdg.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    webcord
    steam
    rusty-path-of-building
    spotify

    imagemagick
    htop

    ungoogled-chromium
    libreoffice
    gimp
    vlc
    dunst
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
