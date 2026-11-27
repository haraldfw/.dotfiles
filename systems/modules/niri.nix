{ pkgs, ... }:
{
  # Provided by sodiboo/niri-flake (nixosModules.niri, imported in flake.nix).
  # Start from a TTY with `niri-session`.
  programs.niri.enable = true;
  # niri-flake's own package needs a removed libdisplay-info; use nixpkgs' niri.
  programs.niri.package = pkgs.niri;

  # Binary cache for niri-flake's niri builds.
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
  };

  # hyprlock authenticates through this PAM service. Without it the lockscreen can't verify the password.
  security.pam.services.hyprlock = { };

  # Needed for home-manager's dconf settings (dark mode preference) to take effect
  programs.dconf.enable = true;

  # Everything the niri session (home/modules/desktopenv/niri) launches or binds.
  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 apps; niri spawns it on demand when it's in PATH

    waybar
    dunst
    rofi
    hyprlock
    swayidle
    brightnessctl
    playerctl
    wireplumber # wpctl
    polkit_gnome
    nordzy-cursor-theme
    pavucontrol

    eog
    kdePackages.dolphin
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
