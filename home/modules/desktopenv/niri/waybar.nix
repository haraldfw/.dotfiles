{ config, lib, ... }:
let
  base = config.programs.waybar.settings.mainBar;

  # Workspaces are named ws1..ws10 (see niri.nix); show just the number.
  numberIcons = builtins.listToAttrs (
    map (n: {
      name = "ws${toString n}";
      value = toString n;
    }) (lib.range 1 10)
  );
in
{
  # Separate waybar config for niri, reusing the module settings from ../waybar.nix.
  # Started from niri via `waybar -c ~/.config/waybar/niri.jsonc -s ~/.config/waybar/niri.css`.
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
        # Only names + a fallback: the active workspace is highlighted in niri.css instead.
        format-icons = numberIcons // {
          default = "·";
        };
      };
    }
  );

  # Passing -s replaces waybar's default stylesheet, so the basics are repeated here.
  xdg.configFile."waybar/niri.css".text = ''
    * {
      font-family: sans-serif;
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    window#waybar {
      background-color: rgba(43, 48, 59, 0.5);
      color: #ffffff;
    }

    #workspaces button {
      /* no min-width, so single digits and "10" are both centred */
      min-width: 0;
      padding: 0 10px;
      color: #ffffff;
      background: transparent;
      box-shadow: inset 0 -3px transparent;
    }

    /* visible on its monitor */
    #workspaces button.active {
      background-color: rgba(100, 114, 125, 0.5);
      box-shadow: inset 0 -3px #ffffff;
    }

    /* the workspace you are on */
    #workspaces button.focused {
      background-color: rgba(100, 114, 125, 0.8);
      box-shadow: inset 0 -3px #00ffff;
    }

    #workspaces button.urgent {
      background-color: #eb4d4b;
    }

    #clock, #battery, #cpu, #memory, #disk, #temperature, #backlight, #network,
    #pulseaudio, #wireplumber, #tray, #mode, #custom-media {
      padding: 0 10px;
      color: #ffffff;
    }
  '';
}
