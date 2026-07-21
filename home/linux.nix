{ pkgs, username, ... }:
{
  imports = [
    ./modules/desktopenv
    ./modules/gaming

    ./modules/additional-packages.nix
    ./modules/development
    ./modules/neovim
    ./modules/zsh
    ./modules/alacritty.nix
    ./modules/librewolf.nix
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
