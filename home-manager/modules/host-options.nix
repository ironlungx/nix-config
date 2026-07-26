{ lib, ... }:
{
  options.myhm = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this host is a laptop";
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
