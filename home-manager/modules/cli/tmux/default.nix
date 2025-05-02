{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-s";
    keyMode = "vi";

    baseIndex = 1;
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
      tmux-fzf
      vim-tmux-navigator
      cpu
      {
        plugin = catppuccin;
        extraConfig = builtins.readFile ./catppuccin.conf;
      }
    ];

    extraConfig = ''
      set -g status-bg default
      set -g status-style bg=default
      set -g default-terminal "tmux-256color"
      set -as terminal-features ",*:RGB"

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      set-option -sa terminal-overrides ',xterm*:Tc'

      # Vim-style pane navigation with Alt + h/j/k/l
      bind -n C-M-h select-pane -L
      bind -n C-M-j select-pane -D
      bind -n C-M-k select-pane -U
      bind -n C-M-l select-pane -R
    '';
  };
}
