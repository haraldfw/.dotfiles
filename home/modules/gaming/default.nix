{ pkgs, ... }:
{
  imports = [
    ./lutris.nix
    ./wowup.nix
  ];

  home.packages = with pkgs; [
    webcord
    rusty-path-of-building
    wowup-cf
  ];
}
