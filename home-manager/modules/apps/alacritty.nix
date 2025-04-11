{
  lib,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      cursor = {
        style = {
          shape = "Underline";
        };
      };
      window = {
        padding = {
          x = 20;
          y = 20;
        };
      };
    };
  };
}
