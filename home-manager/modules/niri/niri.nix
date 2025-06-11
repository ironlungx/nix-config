{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
  ];

  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard = {
          repeat-delay = 600;
          repeat-rate = 25;
        };

        mouse = {
          accel-profile = "flat";
          natural-scroll = false;
        };
      };

      environment.DISPLAY = ":0";
      prefer-no-csd = true;

      layout = {
        border = {
          enable = true;
          width = 2;
        };

        preset-column-widths = [
          {proportion = 0.25;}
          {proportion = 0.5;}
          {proportion = 0.75;}
        ];

        default-column-width.proportion = 1.0;

        gaps = 16;

        center-focused-column = "never";
      };

      binds = {
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;

        "Mod+Shift+0".action.move-column-to-workspace = 10;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+Shift+Return".action.spawn = ["foot"];
        "Mod+p".action.spawn = ["rofi -show drun"];
        "Mod+Control+Escape".action.spawn = ["pkill niri"];

        "Mod+N".action.focus-column-left = {};
        "Mod+M".action.focus-column-right = {};

        "Mod+Shift+N".action.move-column-left = {};
        "Mod+Shift+M".action.move-column-right = {};

        "Mod+Shift+Q".action.close-window = { };

        
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+F".action.maximize-column = { };
        "Mod+C".action.center-column = { };
      };

      animations = {
        enable = true;
        window-open = {
          easing = {
            curve = "ease-out-expo";
            duration-ms = 800;
          };
        };
        window-close = {
          easing = {
            curve = "ease-out-quad";
            duration-ms = 800;
          };
        };
      };
    };
  };
}
