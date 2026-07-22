{ pkgs, username, ... }:
{
  imports = [
    ./modules/desktopenv
    ./modules/gaming
    ./modules/gamedev

    ./modules/additional-packages.nix
    ./modules/development/additional-packages.nix
    ./modules/development/neovim
    ./modules/development/vscodium
    ./modules/zsh
    ./modules/alacritty.nix
    ./modules/librewolf.nix
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
