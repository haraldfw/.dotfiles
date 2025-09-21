{ username, ... }:
{
  imports = [
    ./alacritty
    ./wm
    ./zsh
    ./librewolf.nix
    ./packages.nix
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
