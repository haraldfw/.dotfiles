{ pkgs, username, ... }:
{
  imports = [
    ./alacritty.nix
    ./development
    ./hyprland.nix
    ./librewolf.nix
    ./neovim
    ./waybar.nix
    ./xdg.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    webcord
    steam
    rusty-path-of-building
    spotify

    htop

    ungoogled-chromium
    libreoffice
    gimp
    vlc
    dunst

    brightnessctl
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
