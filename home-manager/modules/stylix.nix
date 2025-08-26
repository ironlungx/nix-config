{ inputs, config, pkgs, ... }:
{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ironlungx/wallpapers/refs/heads/main/in%20rainbows_themed_catppuccin-frappe.jpg";
      sha256 = "0hkrb2973ms6qy099i5d8kb9fbxqpl5vh1clf2735jwjzmlvn6sf";
    };
    fonts = {
      sizes = {
        terminal = 10;
      };
      monospace = {
        package = pkgs.aporetic;
        name = "Aporetic Sans Mono";
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
