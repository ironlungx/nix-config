{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_width = 2;
        separator_height = 2;
        padding = 10;
        horizontal_padding = 20;
        line_height = 0;
        transparency = 5;
        corner_radius = 6;
        dmenu = "${pkgs.wofi}/bin/wofi -dmenu";
        origin = "bottom-center";
        icon_theme = "Adwaita";
        enable_recursive_icon_lookup = true;

        # # Background color
        # background = config.lib.stylix.colors.withHashtag.base00;
        #
        # # Foreground color;
        # foreground = config.lib.stylix.colors.withHashtag.base05;
        #
        # # Frame color;
        # frame_color = config.lib.stylix.colors.withHashtag.base0D;
        #
        # # Separator color;
        # separator_color = config.lib.stylix.colors.withHashtag.base07;
        #
        # # Highlight color (for URLs and actions);
        # highlight = config.lib.stylix.colors.base0E;
      };
    };
  };
}
