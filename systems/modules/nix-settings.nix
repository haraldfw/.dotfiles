{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # 5 gibibytes
  nix.settings.download-buffer-size = 5368709000;
}
