{ inputs, system, ... }:
{
  home.packages = [
    inputs.hyprdynamicmonitors.packages.${system}.default
  ];

  home.hyprdynamicmonitors = {
    enable = true;

    configFile = ./config.toml;
    extraFiles = {
      "hyprdynamicmonitors/hyprconfigs" = ./hyprconfigs;
    };

    # Optional: customize systemd target
    # Defaults to config.wayland.systemd.target if set
    systemdTarget = "graphical-session.target";

    # Optional: customize prepare service systemd targets (default: both default.target and graphical-session-pre.target)
    prepareSystemdTarget = [
      "default.target"
      "graphical-session-pre.target"
    ];

    # Optional: customize what the prepare service runs before
    prepareSystemdBefore = [ "graphical-session-pre.target" ];

    # Optional: pass extra flags to the binary
    extraFlags = [ "--debug" ];
  };
}
