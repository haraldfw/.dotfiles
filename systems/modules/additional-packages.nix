{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
    busybox
    ripgrep
    tmux

    wget
    lshw
    htop
    iputils

    cargo
    rustc
    gcc
  ];
}
