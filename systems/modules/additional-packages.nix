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
    # also add the following if the hostPlatform is linux
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      busybox
      lshw
      iputils
      lm_sensors
      linuxKernel.packages.linux_6_18.cpupower
    ];
}
