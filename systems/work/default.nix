{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/additional-packages.nix
    ../modules/fonts.nix
    ../modules/hyprland.nix
    ../modules/linux-specific.nix
    ../modules/niri.nix
    ../modules/nix-settings.nix
    ../modules/pipewire.nix
    ../modules/steam.nix
    ../modules/user.nix
  ];

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Caps Lock -> Escape, same as tuxollini
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
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  boot.loader.systemd-boot.enable = true;

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "work";
    networkmanager.enable = true;
  };

  # TODO: fill in once the hardware is known (see tuxollini for an Intel example):
  #  - services.xserver.videoDrivers
  #  - hardware.graphics (extraPackages) and, for Intel, environment.sessionVariables.LIBVA_DRIVER_NAME
  #  - services.power-profiles-daemon.enable
  #  - swapDevices (tuxollini has a 32 GiB swap file)

  environment.systemPackages = with pkgs; [
    qemu_kvm
  ];

  # do not change after the first install; set it to the NixOS version you install with
  system.stateVersion = "26.05";
}
