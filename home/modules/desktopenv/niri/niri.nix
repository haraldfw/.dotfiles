{ config, pkgs, ... }:
let
  spawn = args: { action.spawn = args; };

  workspaces = [ 1 2 3 4 5 6 7 8 9 10 ];
  key = n: toString (if n == 10 then 0 else n);

  workspaceBinds = builtins.listToAttrs (
    builtins.concatMap (n: [
      {
        name = "Mod+${key n}";
        value.action.focus-workspace = n;
      }
      {
        name = "Mod+Shift+${key n}";
        value.action.move-column-to-workspace = n;
      }
    ]) workspaces
  );

  volume = delta: [ "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" delta ];
in
{
  programs.niri.settings = {
    prefer-no-csd = true;

    input = {
      keyboard = {
        xkb = {
          layout = "us";
          variant = "altgr-intl";
        };
        repeat-delay = 300;
        repeat-rate = 50;
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        click-method = "clickfinger";
        accel-profile = "flat";
        accel-speed = -0.3;
      };
      mouse = {
        accel-profile = "flat";
        accel-speed = -0.3;
      };
      focus-follows-mouse.enable = true;
    };

    # Mirrors the monitors in hyprland.nix. Keys are output names/descriptions.
    outputs = {
      "AOC CU34G4ZCA" = {
        mode = { width = 3440; height = 1440; refresh = 239.991; };
        focus-at-startup = true;
      };
      "AOC AG352UCG" = {
        mode = { width = 3440; height = 1440; refresh = 50.0; };
        position = { x = -3440; y = 0; };
      };
      "LG Display 0x0778" = {
        mode = { width = 2880; height = 1800; refresh = 60.0; };
        scale = 2;
      };
    };

    layout = {
      gaps = 10;
      border = {
        enable = true;
        width = 2;
        active.gradient = { from = "#00ffff"; to = "#00ff7f"; angle = 45; };
        inactive.color = "#595959";
      };
      focus-ring.enable = false;
    };

    cursor = {
      theme = "Nordzy-cursors";
      size = 28;
    };

    environment = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
    };

    spawn-at-startup = [
      { argv = [ "${pkgs.waybar}/bin/waybar" "-c" "${config.xdg.configHome}/waybar/niri.jsonc" ]; }
      { argv = [ "${pkgs.dunst}/bin/dunst" ]; }
      { argv = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; }
      { argv = [ "${pkgs.swayidle}/bin/swayidle" "-w"
          "timeout" "300" "${pkgs.hyprlock}/bin/hyprlock"
          "timeout" "330" "niri msg action power-off-monitors"
          "resume" "niri msg action power-on-monitors"
          "before-sleep" "${pkgs.hyprlock}/bin/hyprlock" ]; }
    ];

    binds = {
      "Mod+Return".action = spawn [ "alacritty" ];
      "Mod+W".action.close-window = [ ];
      "Mod+E".action = spawn [ "dolphin" ];
      "Mod+Space".action = spawn [ "rofi" "-theme" "gruvbox-dark.rasi" "-show" "combi" "-modes" "combi" ];
      "Mod+S".action.toggle-window-floating = [ ];
      "Mod+F".action.fullscreen-window = [ ];
      "Mod+R".action.switch-preset-column-width = [ ];

      "Mod+Left".action.focus-column-left = [ ];
      "Mod+Right".action.focus-column-right = [ ];
      "Mod+Up".action.focus-window-up = [ ];
      "Mod+Down".action.focus-window-down = [ ];
      "Mod+Tab".action.focus-column-right = [ ];
      "Mod+Shift+Left".action.move-column-left = [ ];
      "Mod+Shift+Right".action.move-column-right = [ ];

      "Mod+WheelScrollDown" = { action.focus-workspace-down = [ ]; cooldown-ms = 150; };
      "Mod+WheelScrollUp" = { action.focus-workspace-up = [ ]; cooldown-ms = 150; };

      "Mod+Shift+S".action.screenshot = [ ];
      "Print".action.screenshot = [ ];

      "Mod+L".action = spawn [ "sh" "-c" "pactl set-sink-mute @DEFAULT_SINK@ 1 && hyprlock" ];
      "Mod+Alt+Escape".action.quit = [ ];

      "XF86AudioRaiseVolume" = { action = spawn (volume "5%+"); allow-when-locked = true; };
      "XF86AudioLowerVolume" = { action = spawn (volume "5%-"); allow-when-locked = true; };
      "XF86AudioMute" = { action = spawn [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; allow-when-locked = true; };
      "XF86AudioPlay".action = spawn [ "playerctl" "play-pause" ];
      "XF86AudioNext".action = spawn [ "playerctl" "next" ];
      "XF86AudioPrev".action = spawn [ "playerctl" "previous" ];
      "XF86MonBrightnessUp" = { action = spawn [ "brightnessctl" "set" "5%+" ]; allow-when-locked = true; };
      "XF86MonBrightnessDown" = { action = spawn [ "brightnessctl" "set" "5%-" ]; allow-when-locked = true; };
    } // workspaceBinds;
  };
}
