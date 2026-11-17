{
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/additional-packages.nix
    ../modules/fonts.nix
    ../modules/hyprland.nix
    ../modules/linux-specific.nix
    ../modules/nix-settings.nix
    ../modules/pipewire.nix
    ../modules/steam.nix
    ../modules/user.nix
  ];

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
    videoDrivers = [ "nvidia" ];
  };

  boot.loader.systemd-boot.enable = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "tux";
  networking.networkmanager.enable = true;

  hardware.graphics = {
    enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Only let Hyprland drive the NVIDIA card (the monitor is on it). Keeps the Intel iGPU
  # out of aquamarine's seat/hotplug restore path (KVM monitor power-cycle crashed Hyprland).
  # AQ_DRM_DEVICES is colon-separated, so the by-path name (contains ':') can't be used;
  # make a colon-free stable symlink for the NVIDIA card instead.
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", SUBSYSTEMS=="pci", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-card"
  '';
  environment.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/nvidia-card";

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # do not change
  system.stateVersion = "25.05";
}
