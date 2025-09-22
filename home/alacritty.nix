{ pkgs, ... }:
{
  imports = [ "./config.nix" ];

  home.packages = with pkgs; [
    alacritty
  ];

  programs.alacritty.settings = {
    font.size = 14;
  };
}
