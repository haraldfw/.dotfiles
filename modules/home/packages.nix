{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    steam
    path-of-building
  ];
}
