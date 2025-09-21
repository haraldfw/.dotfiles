{ pkgs, ... }:

{

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
    ];
  };
}
