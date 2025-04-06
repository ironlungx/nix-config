{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ bibata-cursors ];

  stylix = {
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-catppuccin-mocha.png";
      sha256 = "ce562a4a27794352f9b14ac072f47eeda3768c89a2ba847d832801464f31f56a";
    }; 

    fonts = {
      sizes = {
        terminal = 9;
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      serif = {
        package = pkgs.aleo-fonts;
        name = "Aleo";
      };

      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK JP";
      }; 
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
}
