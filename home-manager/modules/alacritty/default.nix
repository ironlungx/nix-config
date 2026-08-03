{ lib, config, ... }:
{
  config.programs.alacritty = lib.mkIf (config.myhm.terminal == "alacritty") {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      cursor.style.shape = "Underline";
      window.padding = {
        x = 10;
        y = 10;
      };
    };
  };
}
