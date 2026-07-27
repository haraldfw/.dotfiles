{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      gnumake
      ripgrep
      tmux

      wget
      htop

      cargo
      rustc
      gcc
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      busybox
      lshw
      iputils
      lm_sensors
      linuxKernel.packages.linux_6_18.cpupower
    ];
}
