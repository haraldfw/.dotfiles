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

    shellAliases = {
      t = "tmux";
    };

    initContent = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^R" history-incremental-search-backward
      bindkey "^H" backward-kill-word # Ctrl+Backspace (alacritty sends ^H)

      # mac stuff
      # Home/End: alacritty sends ^[[H/^[[F, tmux sends ^[[1~/^[[4~,
      # some terminals use ^[OH/^[OF or ^[[7~/^[[8~
      for seq in "^[[H" "^[OH" "^[[1~" "^[[7~"; do bindkey "$seq" beginning-of-line; done
      for seq in "^[[F" "^[OF" "^[[4~" "^[[8~"; do bindkey "$seq" end-of-line; done
      bindkey "^[[3~" delete-char
      bindkey "^[[3;5~" delete-word

      source ~/.p10k.zsh
    '';

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];
  };
}
