{
  lib,
  ...
}:
{
  imports = [
    ../modules/additional-packages.nix
    ../modules/nix-settings.nix
  ];

  time.timeZone = "Europe/Oslo";
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  system.stateVersion = 7;
  system.primaryUser = "harald.wilhelmsen";

  users.users."harald.wilhelmsen" = {
    name = "harald.wilhelmsen";
    home = "/Users/harald.wilhelmsen";
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # do not remove non-nix-managed homebrew-packages
      cleanup = "none";
    };

    taps = [ ];
    brews = [ ];
    casks = [
      "dbeaver-community"
      "obsidian"
      "font-fira-code-nerd-font"
    ];
  };
}
