_: {
  programs.tmux = {
    enable = true;
    # home-manager also binds C-a to send-prefix, so pressing C-a twice
    # sends a literal C-a (e.g. zsh beginning-of-line)
    prefix = "C-a";
  };
}
