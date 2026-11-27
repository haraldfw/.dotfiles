{ config, pkgs, ... }:
let
  spawn = args: { spawn = args; };

  workspaces = [ 1 2 3 4 5 6 7 8 9 10 ];
  key = n: toString (if n == 10 then 0 else n);
  # Not purely numeric: niri's CLI treats an all-digit workspace reference as an index, not a name.
  wsName = n: "ws${toString n}";

  # Fixed, global workspaces (bspwm-style). Named workspaces always exist, and
  # are targeted by name, so Mod+N goes to workspace N on whichever monitor holds it.
  # Keys are zero-padded so declaration order is numeric.
  namedWorkspaces = builtins.listToAttrs (
    map (n: {
      name = (if n < 10 then "0" else "") + toString n;
      value.name = wsName n;
    }) workspaces
  );

  workspaceBinds = builtins.listToAttrs (
    builtins.concatMap (n: [
      {
        name = "Mod+${key n}";
        value.action.focus-workspace = wsName n;
      }
      {
        name = "Mod+Shift+${key n}";
        value.action.move-column-to-workspace = wsName n;
      }
    ]) workspaces
  );

  # Monitors, leftmost first. Each entry is a case-insensitive substring matched against
  # "<make> <model> <serial> <connector>" (see `niri msg outputs`), so "eDP" is any laptop panel.
  # Monitors not listed here (meeting rooms, etc.) go after all listed ones, ordered by connector name.
  monitorOrder = [
    "eDP"
    "AG352UCG"
    "CU34G4ZCA"
    "PHL 346B1C"
    "P27h-20"
  ];

  # Lays monitors out left to right in `monitorOrder` (positions are derived from each monitor's
  # logical width, so nothing hardcodes coordinates), then places workspaces by that order:
  # 1-2 -> leftmost, 3-4 -> next, 5-10 -> next; with fewer monitors the missing slots bubble left
  # onto the last available monitor. Works with unknown monitors, so hotplugging is fine.
  workspaceLayout = pkgs.writeShellApplication {
    name = "niri-workspace-layout";
    runtimeInputs = [ pkgs.niri pkgs.jq pkgs.coreutils ];
    text = ''
      priority=${pkgs.lib.escapeShellArg (builtins.toJSON monitorOrder)}

      apply() {
        local layout outs desired ws out idx i x

        # Outputs in left-to-right order with their target x (cx/cy = current position).
        layout=$(niri msg --json outputs | jq -c --argjson pri "$priority" '
          [.[] | select(.logical != null)
            | ("\(.make) \(.model) \(.serial // "") \(.name)" | ascii_downcase) as $id
            | { name, cx: .logical.x, cy: .logical.y, w: .logical.width,
                rank: ([$pri | to_entries[] | . as $e | select($id | contains($e.value | ascii_downcase)) | $e.key] | first // 1000) }]
          | sort_by(.rank, .name)
          | reduce .[] as $m ({x: 0, out: []}; .out += [$m + {x: .x}] | .x += $m.w)
          | .out')
        [ "$(jq 'length' <<<"$layout")" -gt 0 ] || return 0

        while read -r out x; do
          niri msg output "$out" position set "$x" 0 || true
        done < <(jq -r '.[] | select(.cx != .x or .cy != 0) | "\(.name) \(.x)"' <<<"$layout")

        outs=$(jq -c 'map(.name)' <<<"$layout")

        # "<workspace> <output>" for workspaces 1..10
        desired=$(jq -r -n --argjson o "$outs" '
          range(1; 11) as $w
          | (if $w <= 2 then 0 elif $w <= 4 then 1 else 2 end) as $s
          | "ws\($w) \($o[[$s, ($o | length) - 1] | min])"')

        declare -A cur_out=()
        while read -r ws out; do cur_out[$ws]=$out; done < <(
          niri msg --json workspaces | jq -r '.[] | select(.name != null) | "\(.name) \(.output)"')

        while read -r ws out; do
          if [ "''${cur_out[$ws]:-}" != "$out" ]; then
            niri msg action move-workspace-to-monitor --reference "$ws" "$out" || true
          fi
        done <<<"$desired"

        # Keep each monitor's workspaces in numeric order.
        declare -A cur_idx=()
        while read -r ws idx; do cur_idx[$ws]=$idx; done < <(
          niri msg --json workspaces | jq -r '.[] | select(.name != null) | "\(.name) \(.idx)"')

        while read -r out; do
          i=0
          while read -r ws; do
            i=$((i + 1))
            if [ "''${cur_idx[$ws]:-}" != "$i" ]; then
              niri msg action move-workspace-to-index --reference "$ws" "$i" || true
            fi
          done < <(awk -v o="$out" '$2 == o { print $1 }' <<<"$desired")
        done < <(jq -r '.[]' <<<"$outs")
      }

      apply
      # Re-apply on workspace/monitor changes. apply is idempotent, so its own moves settle quickly.
      niri msg --json event-stream | while read -r line; do
        case $line in
          *WorkspacesChanged*)
            while read -r -t 0.5 _; do :; done
            apply
            ;;
        esac
      done
    '';
  };

  # Don't stack lockers if idle/sleep/keybind fire together.
  lock = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";

  volume = delta: [ "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" delta ];
in
{
  programs.niri.package = pkgs.niri;

  programs.hyprlock.enable = true;

  programs.niri.settings = {
    prefer-no-csd = true;

    workspaces = namedWorkspaces;

    screenshot-path = "~/pictures/screenshots/%Y-%m-%d %H-%M-%S.png";

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
      { argv = [ "${workspaceLayout}/bin/niri-workspace-layout" ]; }
      { argv = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; }
      { argv = [ "${pkgs.swayidle}/bin/swayidle" "-w"
          "timeout" "150" "brightnessctl -s set 10" "resume" "brightnessctl -r"
          "timeout" "300" lock
          "timeout" "330" "niri msg action power-off-monitors"
          "resume" "niri msg action power-on-monitors"
          "before-sleep" lock ]; }
    ];

    binds = {
      "Mod+F1" = { action.show-hotkey-overlay = [ ]; hotkey-overlay.title = "Show important hotkeys"; };
      "Mod+Return" = { action = spawn [ "alacritty" ]; hotkey-overlay.title = "Open terminal"; };
      "Mod+W" = { action.close-window = [ ]; hotkey-overlay.title = "Close window"; };
      "Mod+E" = { action = spawn [ "dolphin" ]; hotkey-overlay.title = "File manager"; };
      "Mod+Space" = { action = spawn [ "rofi" "-theme" "gruvbox-dark.rasi" "-show" "combi" "-modes" "combi" ]; hotkey-overlay.title = "App launcher"; };
      "Mod+S".action.toggle-window-floating = [ ];
      "Mod+F".action.fullscreen-window = [ ];
      "Mod+R".action.switch-preset-column-width = [ ];

      "Mod+Left".action.focus-column-left = [ ];
      "Mod+Right".action.focus-column-right = [ ];
      "Mod+Up".action.focus-window-up = [ ];
      "Mod+Down".action.focus-window-down = [ ];
      "Mod+Tab".action.focus-column-right = [ ];

      # vim-style focus, alongside the arrow keys
      "Mod+H".action.focus-column-left = [ ];
      "Mod+J".action.focus-window-down = [ ];
      "Mod+K".action.focus-window-up = [ ];
      "Mod+L".action.focus-column-right = [ ];
      "Mod+Shift+H".action.move-column-left = [ ];
      "Mod+Shift+L".action.move-column-right = [ ];

      "Mod+Shift+Left".action.move-column-left = [ ];
      "Mod+Shift+Right".action.move-column-right = [ ];

      "Mod+WheelScrollDown" = { action.focus-workspace-down = [ ]; cooldown-ms = 150; };
      "Mod+WheelScrollUp" = { action.focus-workspace-up = [ ]; cooldown-ms = 150; };

      "Mod+Shift+S".action.screenshot = [ ];
      "Print".action.screenshot = [ ];

      "Mod+Alt+L" = { action = spawn [ "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1; ${lock}" ]; hotkey-overlay.title = "Lock screen"; };
      "Mod+Alt+Escape" = { action.quit = [ ]; hotkey-overlay.title = "Quit niri"; };

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
