{ ... }:
{
  config.programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      font = {
        size = 12;
        normal.family = "FiraCode Nerd Font";
      };

      window = {
        padding.x = 10;
        padding.y = 10;
        opacity = 0.9;
        blur = true;
        option_as_alt = "Both";
      };

      keyboard.bindings = [
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
      ];
    };
  };
}
