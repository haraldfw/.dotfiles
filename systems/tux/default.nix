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
