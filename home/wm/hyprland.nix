{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wayland
    xwayland
    hyprland
    waybar
    hyprshot
    rofi
    pavucontrol
    nordzy-cursor-theme
    eog
    kdePackages.dolphin
  ];

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
}
