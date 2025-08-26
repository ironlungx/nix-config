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
          x = 10;
          y = 10;
        };
      };
    };
  };
}
