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
    brews = [
      "showkey"
    ];
    casks = [
      "dbeaver-community"
      "obsidian"
      "font-fira-code-nerd-font"
    ];
  };

  services.jankyborders = {
    enable = true;
    active_color = "0xee00ff99";
    inactive_color = "0xaa595959";
    width = 7.0;
    style = "round";
  };
}
