{ pkgs, username, ... }:
{
  imports = [
    # ./modules/additional-packages.nix
    # ./modules/development
    # ./modules/neovim
    ./modules/zsh
    ./modules/alacritty.nix
    # ./modules/librewolf
  ];

  # until we have completely replaced all packages maintained by homebrew we have to reference them.
  # This adds them to path
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  home.stateVersion = "25.11";
  home.username = "${username}";
  home.homeDirectory = "/Users/${username}";
  programs.home-manager.enable = true;
}
