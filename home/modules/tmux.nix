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

      # prefix + Tab: fuzzy window switcher popup (tmux 3.8 switch-mode).
      # Same as the default binding, but with -F so the session name comes first
      # on each window row (the default starts with the window name).
      bind Tab new-pane -E -X 0 -Y 0 -x "75%" -y "30%" \; move-pane -P bottom-centre \; switch-mode -kw -F '#{?window_format,#[bold]#{session_name}#[default]#[dim]:#{window_index}#{window_flags}#[default] #{window_name} #[dim]#{pane_current_command}#[default] #[dim]#{?#{!=:#{pane_title},#{host_short}},#{pane_title},}#[default],#{session_name} #[dim]#{session_windows} windows#[default] #{?session_attached,attached,#[dim]detached#[default]} #[dim]#{window_name}#[default]}'
    '';
  };
}
