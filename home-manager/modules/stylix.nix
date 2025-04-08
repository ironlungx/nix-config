{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ bibata-cursors ];
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://i.redd.it/4yiwgcddr8hb1.jpg";
      sha256 = "1b1hl9s4b0lpqr29vpwanq4qj6g1vv5269wlasd0dg3kypn2ng1a";
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

    targets = {
      neovim.enable = false;
      nixcord.enable = false;
      kitty.variant256Colors = true;
      fish.enable = false;

      firefox.profileNames = ["ironlung"];
      hyprlock = {
        enable = true;
        useWallpaper = true;
      };
    };
  };
}
