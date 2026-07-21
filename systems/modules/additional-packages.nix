{ pkgs, ... }:
{
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
    linuxKernel.packages.linux_6_18.cpupower

    cargo
    rustc
    gcc
  ];

  services.openssh.enable = true;
  services.upower.enable = true;
}
