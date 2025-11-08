{
  pkgs,
  inputs,
  config,
  ...
}:
let
  terminal = pkgs.ghostty;
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    swayosd
    flameshot
    libnotify
    pamixer
    hyprpaper
    xwayland-satellite
  ];

  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard = {
          repeat-delay = 200;
          repeat-rate = 50;
        };

        mouse = {
          accel-profile = "flat";
          natural-scroll = false;
        };
      };

      gestures = {
        hot-corners.enable = false;
      };

      overview = {
        backdrop-color = config.lib.stylix.colors.withHashtag.base00;
      };

      window-rules = [
        {
          geometry-corner-radius =
            let
              radius = 10.0;
            in
            {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
      ];

      environment = {
        DISPLAY = ":0";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      prefer-no-csd = true;

      spawn-at-startup = [
        {
          command = [ "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY" ];
        }
        {
          command = [ "${pkgs.swaybg}" ];
        }
        {
          command = [ "${pkgs.dunst}/bin/dunst" ];
        }
        {
          command = [ "swayosd-server" ];
        }
        {
          command = [ "waybar" ];
        }
        {
          command = [ "blueman" ];
        }
        {
          command = [ "${pkgs.hyprpaper}/bin/hyprpaper" ];
        }
        {
          command = [ "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store" ];
        }
        {
          command = [ "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store" ];
        }

        {
          command = [
            "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
          ];
        }
      ];

      layout = {
        border = {
          enable = true;
          width = 2;
        };

        preset-column-widths = [
          { proportion = 0.25; }
          { proportion = 0.5; }
          { proportion = 0.75; }
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

        "Mod+Return".action.spawn = [ "${pkgs.ghostty}/bin/ghostty" ];
        "Mod+Control+Return".action.spawn = [
          "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/.zen-wrapped"
        ];
        "Mod+P".action.spawn = [
          "rofi"
          "-show"
          "drun"
        ];
        "Mod+Control+Escape".action.spawn = [ "pkill niri" ];

        "Mod+Shift+Q".action.close-window = { };

        "Mod+R".action.switch-preset-column-width = { };
        "Mod+F".action.maximize-column = { };
        "Mod+C".action.center-column = { };

        "Mod+H".action.focus-column-left = { };
        "Mod+J".action.focus-window-or-monitor-down = { };
        "Mod+K".action.focus-window-or-monitor-up = { };
        "Mod+L".action.focus-column-right = { };

        "Mod+O".action.toggle-overview = { };
        "Mod+V".action.spawn-sh = [
          "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
        ];

        "Mod+Shift+H".action.move-column-left = { };
        "Mod+Shift+J".action.move-window-to-monitor-down = { };
        "Mod+Shift+K".action.move-window-to-monitor-up = { };
        "Mod+Shift+L".action.move-column-right = { };

        "Mod+Control+H".action.set-column-width = "-10%";
        "Mod+Control+L".action.set-column-width = "+10%";

        "Mod+Comma".action.consume-or-expel-window-left = { };
        "Mod+Period".action.consume-or-expel-window-right = { };

        "Mod+T".action.toggle-window-floating = { };
        "Mod+Shift+T".action.switch-focus-between-floating-and-tiling = { };

        "Mod+M".action.screenshot = { };

        "XF86AudioRaiseVolume".action.spawn-sh = [
          "${pkgs.swayosd}/bin/swayosd-client --output-volume=+5"
        ];
        "XF86AudioLowerVolume".action.spawn-sh = [
          "${pkgs.swayosd}/bin/swayosd-client --output-volume=-5"
        ];

        "XF86AudioNext".action.spawn-sh = [ "playerctl next" ];
        "XF86AudioPrev".action.spawn-sh = [ "playerctl previous" ];

        "XF86AudioPause".action.spawn-sh = [ "playerctl play-pause" ];
        "XF86AudioPlay".action.spawn-sh = [ "playerctl play-pause" ];

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
