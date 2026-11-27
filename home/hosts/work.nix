{ pkgs, ... }:
{
  imports = [ ../linux-common.nix ];

  # Packages and programs that should only exist on the work laptop go here.
  home.packages = with pkgs; [
    teams-for-linux
  ];
}
