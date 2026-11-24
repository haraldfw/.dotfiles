{ pkgs, ... }:
let
  # prefix + Space opens a menu of commands (tmux-which-key). The plugin normally
  # generates its menu at runtime, which can't work from the read-only nix store
  # (and its script needs GNU realpath, which macOS lacks). So we only use its
  # build script, run at build time, and source the generated file directly.
  #
  # Keys in the menu match the real prefix bindings where possible. Where they
  # don't, the real binding is written in the name, e.g. "(Ctrl+A ,)".
  whichKeyConfig = pkgs.writeText "tmux-which-key-config.yaml" (
    # JSON is valid YAML, so there's no need for a YAML generator
    builtins.toJSON {
      command_alias_start_index = 200;
      keybindings.prefix_table = "Space";
      title = {
        style = "align=centre,bold";
        prefix = "tmux";
        prefix_style = "fg=green,align=centre,bold";
      };
      position = {
        x = "C";
        y = "C";
      };
      custom_variables = [ ];
      macros = [ ];
      items = [
        {
          name = "+Windows";
          key = "w";
          menu = [
            {
              name = "New";
              key = "c";
              command = "new-window";
            }
            {
              name = "Next";
              key = "n";
              command = "next-window";
            }
            {
              name = "Previous";
              key = "p";
              command = "previous-window";
            }
            {
              name = "List all";
              key = "w";
              command = "choose-tree -Zw";
            }
            {
              name = "Last (no direct key)";
              key = "l";
              command = "last-window";
            }
            {
              name = "Rename (Ctrl+A ,)";
              key = "r";
              command = ''command-prompt -I "#W" { rename-window -- "%%" }'';
            }
            {
              name = "Kill";
              key = "&";
              command = ''confirm-before -p "Kill window #W? (y/n)" kill-window'';
            }
          ];
        }
        {
          name = "+Panes";
          key = "p";
          menu = [
            {
              name = "Left";
              key = "h";
              command = "select-pane -L";
            }
            {
              name = "Down";
              key = "j";
              command = "select-pane -D";
            }
            {
              name = "Up";
              key = "k";
              command = "select-pane -U";
            }
            {
              name = "Right";
              key = "l";
              command = "select-pane -R";
            }
            { separator = true; }
            {
              name = "Split side by side";
              key = "%";
              command = "split-window -h";
            }
            {
              name = ''Split stacked (Ctrl+A ")'';
              key = "-";
              command = "split-window -v";
            }
            {
              name = "Zoom";
              key = "z";
              command = "resize-pane -Z";
            }
            {
              name = "Show numbers";
              key = "q";
              command = "display-panes";
            }
            {
              name = "Move to own window";
              key = "!";
              command = "break-pane";
            }
            {
              name = "Close";
              key = "x";
              command = ''confirm-before -p "Kill pane #P? (y/n)" kill-pane'';
            }
          ];
        }
        {
          name = "+Sessions";
          key = "s";
          menu = [
            {
              name = "List all";
              key = "s";
              command = "choose-tree -Zs";
            }
            {
              name = "New (asks for a name)";
              key = "n";
              command = ''command-prompt -p "New session name:" { new-session -s "%%" }'';
            }
            {
              name = "Last";
              key = "L";
              command = "switch-client -l";
            }
            {
              name = "Rename (Ctrl+A $)";
              key = "r";
              command = ''command-prompt -I "#S" { rename-session -- "%%" }'';
            }
          ];
        }
        {
          name = "+Layout";
          key = "l";
          menu = [
            {
              name = "Next";
              key = "n";
              command = "next-layout";
            }
            {
              name = "Tiled";
              key = "t";
              command = "select-layout tiled";
            }
            {
              name = "Side by side";
              key = "h";
              command = "select-layout even-horizontal";
            }
            {
              name = "Stacked";
              key = "v";
              command = "select-layout even-vertical";
            }
          ];
        }
        { separator = true; }
        {
          name = "Detach";
          key = "d";
          command = "detach-client";
        }
        {
          name = "Command prompt";
          key = ":";
          command = "command-prompt";
        }
        {
          name = "Copy mode";
          key = "[";
          command = "copy-mode";
        }
        {
          name = "Paste";
          key = "]";
          command = "paste-buffer";
        }
        {
          name = "All keybindings";
          key = "?";
          command = "list-keys -N";
        }
        {
          name = "Reload config";
          key = "R";
          command = "source-file ~/.config/tmux/tmux.conf";
        }
      ];
    }
  );

  whichKeyInit = pkgs.runCommand "tmux-which-key-init.tmux" { } ''
    ${pkgs.tmuxPlugins.tmux-which-key}/share/tmux-plugins/tmux-which-key/plugin/build.py \
      ${whichKeyConfig} init.tmux
    # drop the plugin's "display -p ..." progress messages, they would be printed on every tmux start
    grep -v '^display -p ' init.tmux > $out
  '';
in
{
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

      # prefix + Space: menu of commands (replaces the default next-layout on Space)
      source-file ${whichKeyInit}

      # prefix + Tab: fuzzy window switcher popup (tmux 3.8 switch-mode).
      # Same as the default binding, but with -F so the session name comes first
      # on each window row (the default starts with the window name).
      bind Tab new-pane -E -X 0 -Y 0 -x "75%" -y "30%" \; move-pane -P bottom-centre \; switch-mode -kw -F '#{?window_format,#[bold]#{session_name}#[default]#[dim]:#{window_index}#{window_flags}#[default] #{window_name} #[dim]#{pane_current_command}#[default] #[dim]#{?#{!=:#{pane_title},#{host_short}},#{pane_title},}#[default],#{session_name} #[dim]#{session_windows} windows#[default] #{?session_attached,attached,#[dim]detached#[default]} #[dim]#{window_name}#[default]}'
    '';
  };
}
