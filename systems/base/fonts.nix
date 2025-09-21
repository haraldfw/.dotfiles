{ pkgs, ... }:

{

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code" ];
        # sansSerif = [  ]
      };
    };
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      font-awesome
    ];
  };
}
