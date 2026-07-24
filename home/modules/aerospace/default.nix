{ ... }:
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      config-version = 2;

      start-at-login = true;
      accordion-padding = 15;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      automatically-unhide-macos-hidden-apps = true;

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };

      key-mapping.preset = "qwerty";

      mode.main.binding = {
        "alt-w" = "close";

        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";

        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        "alt-minus" = "resize smart -50";
        "alt-equal" = "resize smart +50";

        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";
        "alt-f" = "fullscreen";
        "alt-shift-space" = "layout floating tiling";

        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";
        "alt-6" = "workspace 6";
        "alt-7" = "workspace 7";
        "alt-8" = "workspace 8";
        "alt-9" = "workspace 9";
        "alt-0" = "workspace 10";

        "alt-shift-1" = "move-node-to-workspace 1";
        "alt-shift-2" = "move-node-to-workspace 2";
        "alt-shift-3" = "move-node-to-workspace 3";
        "alt-shift-4" = "move-node-to-workspace 4";
        "alt-shift-5" = "move-node-to-workspace 5";
        "alt-shift-6" = "move-node-to-workspace 6";
        "alt-shift-7" = "move-node-to-workspace 7";
        "alt-shift-8" = "move-node-to-workspace 8";
        "alt-shift-9" = "move-node-to-workspace 9";
        "alt-shift-0" = "move-node-to-workspace 10";

        "alt-tab" = "focus dfs-next --boundaries workspace --boundaries-action wrap-around-the-workspace";
        "alt-shift-tab" =
          "focus dfs-prev --boundaries workspace --boundaries-action wrap-around-the-workspace";

        "alt-shift-semicolon" = "mode service";
        "alt-shift-r" = "reload-config";

        "alt-enter" = "exec-and-forget open -a Alacritty";
      };

      mode.service.binding = {
        "esc" = [
          "reload-config"
          "mode main"
        ];
        "r" = [
          "flatten-workspace-tree"
          "mode main"
        ];
        "f" = [
          "layout floating tiling"
          "mode main"
        ];
        "backspace" = [
          "close-all-windows-but-current"
          "mode main"
        ];
      };

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "secondary";
        "4" = "secondary";
        "5" = "secondary";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
        "10" = "secondary";
      };
    };
  };
}
