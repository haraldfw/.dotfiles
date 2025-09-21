{ pkgs, inputs, ... }:

{

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code" ];
      };
    };
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.symbols-only
    ];
  };
}
