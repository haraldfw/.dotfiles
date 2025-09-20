{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    wayland
    waybar
    rofi
    hyprshot
    pavucontrol
    nordzy-cursor-theme
    eog
    kdePackages.dolphin
  ];

  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
}
