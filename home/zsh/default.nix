{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ./p10k.zsh;

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    completionInit = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';

    initExtra = "source ~/.p10k.zsh";

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];
  };
}
