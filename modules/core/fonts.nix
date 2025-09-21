{ pkgs, inputs, ... }:

{

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "" ];
        monospace = [ "Fira Code" ];
      };
    };
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
    ];
  };
}
