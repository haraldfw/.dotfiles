{ inputs, ... }:
{
  imports = [
    ./config.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
