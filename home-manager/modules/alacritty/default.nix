{ lib, config, ... }:
let
  cfg = config.myhm.alacritty;
in
{
  options.myhm.alacritty.enable = lib.mkEnableOption "alacritty";

  config.programs.alacritty = lib.mkIf cfg.enable {
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
