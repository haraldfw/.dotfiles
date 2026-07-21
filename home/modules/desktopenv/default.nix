{ pkgs, username, ... }:
{
  imports = [
    ./hyprland
    ./waybar.nix
    ./xdg.nix
  ];
}
