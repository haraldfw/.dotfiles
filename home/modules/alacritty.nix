{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      # needs to be set as the default differs on linux and mac,
      # and this config is shared between both platforms
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-i" ];
      };

      font = {
        size = if pkgs.stdenv.isDarwin then 14 else 12;
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
