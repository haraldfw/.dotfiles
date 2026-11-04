{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  q = builtins.toJSON; # Nix string -> quoted Lua string literal

  exec = cmd: "hl.dsp.exec_cmd(${q cmd})";

  # bind "SUPER + Q" "<lua dispatcher expr>" { optional flags }
  bind =
    keys: dsp: opts:
    {
      _args = [
        keys
        (lua dsp)
      ]
      ++ lib.optional (opts != { }) opts;
    };

  dirs = {
    left = "left";
    right = "right";
    up = "up";
    down = "down";
  };

  # workspace keys: 1..9 -> 1..9, 0 -> 10
  wsKeys = map (n: {
    key = toString (lib.mod n 10);
    ws = n;
  }) (lib.range 1 10);

  screenshot = exec "hyprshot --output-folder ~/pictures/screenshots/ --freeze --mode region";
in
{
  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        # NOTE: legacy `hyprctl dispatch dpms on` is not valid under the Lua config.
        after_sleep_cmd = ''hyprctl dispatch 'hl.dsp.dpms({ action = "on" })' '';
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = ''hyprctl dispatch 'hl.dsp.dpms({ action = "off" })' '';
          on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "on" })' && brightnessctl -r'';
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      # ---------------------------------------------------------------- autostart
      on = {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("waybar")
              hl.exec_cmd("hyprpaper")
              hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            end
          '')
        ];
      };

      # ---------------------------------------------------------------- env
      env = [
        { _args = [ "HYPRCURSOR_THEME" "Nordzy-catppuccin-mocha-dark" ]; }
        { _args = [ "XCURSOR_SIZE" "28" ]; }
        { _args = [ "HYPRCURSOR_SIZE" "28" ]; }
        { _args = [ "QT_QPA_PLATFORM" "xcb" ]; }
      ];

      # ---------------------------------------------------------------- monitors
      # Fallback rule; hyprdynamicmonitors' generated file is loaded in extraConfig.
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };

      # ---------------------------------------------------------------- config
      config = {
        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          repeat_delay = 300;
          repeat_rate = 50;
          follow_mouse = 2;
          sensitivity = -0.3; # -1.0 to 1.0
          accel_profile = "flat";
          touchpad = {
            natural_scroll = false;
            clickfinger_behavior = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          col = {
            active_border = {
              colors = [ "rgba(33ccffee)" "rgba(00ff99ee)" ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        misc = {
          disable_autoreload = true;
          disable_hyprland_logo = true;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = false;
          enable_swallow = true;
          focus_on_activate = true;
          on_focus_under_fullscreen = 2;
          middle_click_paste = false;
        };

        dwindle = {
          force_split = 2;
          special_scale_factor = 1.0;
          split_width_multiplier = 1.0;
          use_active_for_splits = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
          special_scale_factor = 1;
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations.enabled = false;
        ecosystem.no_update_news = true;
        binds.movefocus_cycles_fullscreen = true;
      };

      # ---------------------------------------------------------------- workspace rules
      workspace_rule = [
        { workspace = "w[t1]";  gaps_out = 0; gaps_in = 0; }
        { workspace = "w[tg1]"; gaps_out = 0; gaps_in = 0; }
        { workspace = "f[1]";   gaps_out = 0; gaps_in = 0; }
      ];

      # ---------------------------------------------------------------- binds
      bind =
        [
          (bind "SUPER + F1" (exec "show-keybinds") { })
          (bind "SUPER + RETURN" (exec "alacritty") { })
          (bind "SUPER + W" "hl.dsp.window.close()" { })
          (bind "SUPER + E" (exec "dolphin") { })
          (bind "SUPER + S" ''hl.dsp.window.float({ action = "toggle" })'' { })
          (bind "SUPER + SPACE" (exec "rofi -theme gruvbox-dark.rasi -show combi -modes combi") { })
          (bind "SUPER + R" ''hl.dsp.layout("togglesplit")'' { })
          (bind "SUPER + ALT + ESCAPE" "hl.dsp.exit()" { })
          (bind "SUPER + F" "hl.dsp.window.fullscreen()" { })

          (bind "SUPER + TAB" ''hl.dsp.focus({ direction = "right" })'' { })

          (bind "SUPER + V" ''hl.dsp.workspace.toggle_special("magic")'' { })
          (bind "SUPER + SHIFT + V" ''hl.dsp.window.move({ workspace = "special:magic" })'' { })

          (bind "SUPER + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'' { })
          (bind "SUPER + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'' { })

          (bind "SUPER + SHIFT + S" screenshot { })
          (bind "PRINT" screenshot { })
          (bind "SUPER + L" (exec "pactl set-sink-mute @DEFAULT_SINK@ 1 && hyprlock") { })

          # media keys (work on lockscreen)
          (bind "XF86AudioNext" (exec "playerctl next") { locked = true; })
          (bind "XF86AudioPause" (exec "playerctl play-pause") { locked = true; })
          (bind "XF86AudioPlay" (exec "playerctl play-pause") { locked = true; })
          (bind "XF86AudioPrev" (exec "playerctl previous") { locked = true; })

          # locked + repeating
          (bind "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
            locked = true;
            repeating = true;
          })
          (bind "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
            locked = true;
            repeating = true;
          })
          (bind "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n2 set 5%+") {
            locked = true;
            repeating = true;
          })
          (bind "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n2 set 5%-") {
            locked = true;
            repeating = true;
          })

          # repeating
          (bind "XF86AudioRaiseVolume" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") {
            repeating = true;
          })
          (bind "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
            repeating = true;
          })

          # mouse
          (bind "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
          (bind "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
        ]
        # arrow-key focus
        ++ lib.mapAttrsToList (
          key: dir: bind "SUPER + ${key}" ''hl.dsp.focus({ direction = "${dir}" })'' { }
        ) dirs
        # workspace switch + silent move
        ++ lib.concatMap (w: [
          (bind "SUPER + ${w.key}" "hl.dsp.focus({ workspace = ${toString w.ws} })" { })
          (bind "SUPER + SHIFT + ${w.key}" "hl.dsp.window.move({ workspace = ${toString w.ws}, follow = false })" { })
        ]) wsKeys;
    };

    # Generated by hyprdynamicmonitors (needs Lua-capable build).
    extraConfig = ''
      pcall(require, "hyprdynamicmonitors")
    '';
  };
}
