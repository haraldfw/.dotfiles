{ username, ... }:
{
  imports = [
    ./alacritty.nix
    ./base.nix
    ./development
    ./hyprland.nix
    ./librewolf.nix
    ./waybar.nix
    ./xdg.nix
    ./zsh
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
