{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ bibata-cursors ];

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/zhichaoh/catppuccin-wallpapers/blob/main/landscapes/evening-sky.png?raw=true";
      sha256 = "0kb87w736abdf794dk9fvqln56axzskxia1g6zdjrqzl7v539035";
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
    targets.neovim.enable = false;
    targets.nixcord.enable = false;
  };
}
