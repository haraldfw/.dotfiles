{
  config,
  lib,
  ...
}:
{
  imports = [
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
}
