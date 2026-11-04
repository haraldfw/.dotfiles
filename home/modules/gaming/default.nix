{ pkgs, ... }:
{
  imports = [ ./lutris.nix ];

  home.packages = with pkgs; [
    webcord
    rusty-path-of-building
  ];
}
