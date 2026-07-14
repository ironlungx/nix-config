{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myhm.wl-kbptr;
  wl-kbptr-config = ''
    # wl-kbptr can be configured with a configuration file.
    # The file location can be passed with the -c parameter.
    # Otherwise the `$XDG_CONFIG_HOME/wl-kbptr/config` file will
    # be loaded if it exists. Below is the default configuration.
    [general]
    home_row_keys=
    modes=tile,bisect,click
    cancellation_status_code=0
    [mode_tile]
    label_color=${config.lib.stylix.colors.withHashtag.base05}
    label_select_color=${config.lib.stylix.colors.withHashtag.base0A}
    unselectable_bg_color=${config.lib.stylix.colors.withHashtag.base00}B0
    selectable_bg_color=${config.lib.stylix.colors.withHashtag.base00}50
    selectable_border_color=${config.lib.stylix.colors.withHashtag.base02}
    label_font_family=sans-serif
    label_font_size=8 50% 100
    label_symbols=abcdefghijklmnopqrstuvwxyz
    [mode_bisect]
    label_color=${config.lib.stylix.colors.withHashtag.base05}
    label_font_size=20
    label_font_family=sans-serif
    label_padding=12
    pointer_size=20
    pointer_color=${config.lib.stylix.colors.withHashtag.base08}
    unselectable_bg_color=${config.lib.stylix.colors.withHashtag.base00}B0
    even_area_bg_color=${config.lib.stylix.colors.withHashtag.base00}00
    even_area_border_color=${config.lib.stylix.colors.withHashtag.base02}
    odd_area_bg_color=${config.lib.stylix.colors.withHashtag.base00}00
    odd_area_border_color=${config.lib.stylix.colors.withHashtag.base02}
    history_border_color=#3339
    [mode_click]
    button=left
  '';
  wl-kbptr-file = pkgs.writeText "wl-kbptr-file" wl-kbptr-config;
in
{
  options.myhm.wl-kbptr.enable = lib.mkEnableOption "wl-kbptr";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wl-kbptr ];
    home.file.".config/wl-kbptr/config".source = wl-kbptr-file;
  };
}
