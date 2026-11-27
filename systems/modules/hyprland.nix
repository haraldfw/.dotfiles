{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    hyprland

    waybar
    hyprshot
    hypridle
    hyprlock

    brightnessctl
    dunst
    nordzy-cursor-theme
    rofi
    pavucontrol

    eog
    kdePackages.dolphin
  ];

  # Needed for home-manager's dconf settings (dark mode preference) to take effect
  programs.dconf.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";  };

  # systemd.user.targets.hyprland-session.Unit.Wants = [
  #	"xdg-desktop-autostart.target"
  # ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # systemd.enable = true;
  };
}
