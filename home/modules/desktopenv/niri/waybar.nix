{ config, ... }:
let
  base = config.programs.waybar.settings.mainBar;
in
{
  # Separate waybar config for niri, reusing the module settings from ../waybar.nix.
  # Started from niri via `waybar -c ~/.config/waybar/niri.jsonc`.
  xdg.configFile."waybar/niri.jsonc".text = builtins.toJSON (
    base
    // {
      modules-left = [
        "niri/workspaces"
        "custom/media"
        "niri/window"
      ];
      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "■";
          default = "□";
        };
      };
    }
  );
}
