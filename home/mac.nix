{ pkgs, username, ... }:
{
  imports = [
    # ./modules/additional-packages.nix
    # ./modules/development
    # ./modules/neovim
    ./modules/zsh
    ./modules/alacritty.nix
    # ./modules/librewolf
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/Users/${username}";
  programs.home-manager.enable = true;
}
