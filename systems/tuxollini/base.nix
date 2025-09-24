{
  config,
  lib,
  ...
}:
{
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  boot.loader.systemd-boot.enable = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "tuxollini";
  networking.networkmanager.enable = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  powerManagement.cpuFreqGovernor = "performance";

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
