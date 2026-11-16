_: {
  programs.tmux = {
    enable = true;
    # home-manager also binds C-a to send-prefix, so pressing C-a twice
    # sends a literal C-a (e.g. zsh beginning-of-line)
    prefix = "C-a";

    terminal = "tmux-256color";

    extraConfig = ''
      # advertise truecolor (RGB) support for the outer terminal (alacritty)
      set -as terminal-features ",xterm-256color:RGB"

      # vim-style pane navigation: prefix + h/j/k/l
      # (overrides the default prefix + l = last-window)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };
}
