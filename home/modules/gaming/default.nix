{ pkgs, ... }:
{
  home.packages = with pkgs; [
    webcord
    rusty-path-of-building
  ];
}
