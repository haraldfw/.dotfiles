{ username, ... }:
{
  imports = [
    ./wm
    ./zsh
    ./alacritty.nix
    ./base.nix
    ./librewolf.nix
    ./xdg.nix
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
