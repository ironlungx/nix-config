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
        "foot"
      ];
      default = "foot";
      description = "Application launcher to use";
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
