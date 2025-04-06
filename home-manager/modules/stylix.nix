{ config, lib, pkgs, ... }:
{

  home.packages = with pkgs; [ bibata-cursors ];

  stylix = {
    image = /home/ironlung/.wall/rocket-launch.jpg;
    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    
    targets = {
      alacritty.enable = true;

      gtk.enable = true;
      
      firefox.enable = true;
      wofi.enable = true;
    };
  };
}
