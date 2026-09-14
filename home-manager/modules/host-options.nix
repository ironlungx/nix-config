{ lib, pkgs, ... }:
{
  options.myhm = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is this host is a laptop";
    };

    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "XKB keyboard layout";
    };

    terminal = lib.mkOption {
      type = lib.types.enum [
        "kitty"
        "wezterm"
        "alacritty"
        "footclient"
      ];
      default = "footclient";
      description = "Terminal to use";
    };

    wallpaper = lib.mkOption {
      default = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ironlungx/wallpapers/refs/heads/main/clouds-3.png";
        sha256 = "06jvwq4gfq542bn6m1k13yaxkdkkd27niiqm4b53d8nwnqj85qvq";
      };
    };

    browser = lib.mkOption {
      type = lib.types.enum [
        "helium"
        "firefox"
      ];
      default = "firefox";
      description = "Browser to use";
    };

    launcher = lib.mkOption {
      type = lib.types.enum [
        "tofi"
        "rofi"
      ];
      default = "tofi";
      description = "Application launcher to use";
    };
  };
}
