{
  lib,
  pkgs,
  ...
}:
{
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  services.kanata = {
    enable = true;
    keyboards = {
      "internal".config = ''
        ;; defsrc is still necessary
        (defsrc)
        (deflayermap (base-layer)
          caps esc)
      '';
    };
  };

  hardware.uinput.enable = true;
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
    videoDrivers = [ "modesetting" ];
  };

  boot.loader.systemd-boot.enable = true;

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "tuxollini";
    networkmanager.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt

      intel-compute-runtime
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.power-profiles-daemon.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
}
