{ pkgs, inputs, ... }:

{

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = "fira-code";
      };
    };
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.symbols-only
    ];
  };
}
