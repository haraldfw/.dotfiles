{ pkgs, username, ... }:
{
  imports = [
    # ./modules/additional-packages.nix
    ./modules/alacritty.nix
    ./modules/development/additional-packages.nix
    ./modules/development/neovim
    ./modules/glide-browser
    ./modules/keyboard-layout-mac
    # ./modules/librewolf
    ./modules/zsh
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
