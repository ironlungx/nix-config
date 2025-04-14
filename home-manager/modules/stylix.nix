{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/landscapes/evening-sky.png";
      sha256 = "0kb87w736abdf794dk9fvqln56axzskxia1g6zdjrqzl7v539035";
    };
    fonts = {
      sizes = {
        terminal = 9;
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
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

    targets = {
      neovim.enable = false;
      nixcord.enable = false;
      kitty.variant256Colors = true;
      fish.enable = false;
      tmux.enable = false;
      rofi.enable = false;
      waybar.enable = false;

      firefox.profileNames = ["ironlung"];
      hyprlock = {
        enable = true;
        useWallpaper = true;
      };
    };
  };
}
