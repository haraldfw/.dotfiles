
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    godot
    aseprite
  ];
}
