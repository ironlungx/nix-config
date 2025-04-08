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

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
