{ username, ... }:
{
  imports = [
    ./alacritty
    ./fonts.nix
    ./packages.nix
    ./wm
    ./zsh
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
