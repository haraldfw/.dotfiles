{ pkgs, username, ... }:
{
  imports = [
    ./hyprland
    ./niri
    ./waybar.nix
    ./xdg.nix
  ];
}
