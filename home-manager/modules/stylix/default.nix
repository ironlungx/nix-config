{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myhm.stylix;
in
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  options.myhm.stylix.enable = lib.mkEnableOption "stylix";
  config.stylix = lib.mkIf cfg.enable {
    enable = true;
    image = pkgs.fetchurl {
      # url = "https://raw.githubusercontent.com/ironlungx/wallpapers/refs/heads/main/clouds-3.png";
      # sha256 = "06jvwq4gfq542bn6m1k13yaxkdkkd27niiqm4b53d8nwnqj85qvq";
      url = "https://raw.githubusercontent.com/ironlungx/wallpapers/refs/heads/main/kittensgame_themed_catppuccin-frappe.jpg";
      sha256 = "07hq49kxg67g0d4fq7g0krm9v2y4hqd8i86bhqsahg1lmwxpj478";
    };
    fonts = {
      sizes = {
        terminal = 10.25;
      };
      monospace = {
        package = pkgs.iosevka;
        name = "Iosevka";
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

      firefox.profileNames = [ "ironlung" ];
      hyprlock = {
        enable = true;
        useWallpaper = true;
      };
    };
  };
}
