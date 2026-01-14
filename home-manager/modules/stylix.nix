{
  inputs,
  config,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ironlungx/wallpapers/refs/heads/main/flowers.jpeg";
      sha256 = "1xj6gw4zz644xdp2pa0sphm66a4ib3d5snb1lj2iy8bvwhpby8iz";
    };
    fonts = {
      sizes = {
        terminal = 10.25;
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

      firefox.profileNames = [ "ironlung" ];
      hyprlock = {
        enable = true;
        useWallpaper = true;
      };
    };
  };
}
