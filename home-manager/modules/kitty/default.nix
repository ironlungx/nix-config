{
  lib,
  config,
  ...
}:
let
  cfg = config.myhm.kitty;
in
{
  options.myhm.kitty.enable = lib.mkEnableOption "kitty";

  config.programs.kitty = lib.mkIf cfg.enable {
    enable = true;
    # font = {
    #   name = config.stylix.fonts.monospace.name;
    #   size = config.stylix.fonts.sizes.terminal;
    # };
    settings = {
      term = "xterm-256color";
      cursor_shape = "underline";
      cursor_underline_thickness = 1.0;
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
  };
}
