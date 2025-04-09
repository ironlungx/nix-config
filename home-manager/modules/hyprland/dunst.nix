{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    oranchelo-icon-theme
  ];
  services.dunst = {
    enable = true;
    settings = {
      font = "${config.stylix.fonts.monospace.name} 8"; ####
      frame_width = 2;
      separator_height = 2;
      padding = 10;
      horizontal_padding = 20;
      line_height = 0;
      transparency = 5;
      corner_radius = 6;
      dmenu = "${pkgs.wofi}/bin/wofi -dmenu"; 
      origin = "bottom-center";
      icon_theme = "Oranchelo";
      enable_recursive_icon_lookup = true;

      # Background color
      background = "#${config.lib.stylix.colors.base00}";
      # Foreground color;
      foreground = "#${config.lib.stylix.colors.base05}";
      # Frame color;
      frame_color = "#${config.lib.stylix.colors.base0D}";
      # Separator color;
      separator_color = "#${config.lib.stylix.colors.base07}";
      # Highlight color (for URLs and actions);
      highlight = "#${config.lib.stylix.colors.base0E}";
    };
  };
}
