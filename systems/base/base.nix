{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # 5 gibibytes
  nix.settings.download-buffer-size = 5368709000;

  environment.systemPackages = with pkgs; [
    home-manager
    git
    nil
    nixfmt
    nix-search-cli

    gnumake
    busybox
    ripgrep
    tmux

    wget
    lshw
    htop
    iputils
    lm_sensors

    cargo
    rustc
    gcc
  ];

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
