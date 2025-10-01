{ username, ... }:
{
  imports = [
    ./alacritty.nix
    ./base.nix
    ./hyprland.nix
    ./librewolf.nix
    ./vscodium.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
}
