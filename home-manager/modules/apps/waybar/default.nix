{
  config,
  pkgs,
  ...
}:
let
  waybar_config = {
    mainBar = {
      "layer" = "top";
      "position" = "bottom";
      "modules-left" = [
        "custom/nix"
        # "niri/workspaces"
        "hyprland/workspaces"
        "custom/sep"
        "cpu"
        "memory"
        "disk"
      ];
      "modules-center" = [
        "clock"
      ];
      "modules-right" = [
        "mpris"
        "custom/sep"
        "custom/weather"
        "network"
        "bluetooth"
        "custom/sep"
        "custom/dunst"
        "custom/focus"
        "tray"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        sort-by-name = true;
        format = "{icon}";
        format-icons = {
          empty = "";
          active = "";
          default = "";
        };
        icon-size = 9;
        persistent-workspaces = {
          "*" = 6;
        };
      };

      "niri/workspaces" = {
        format = "{icon}";
        disable-click = true;
        format-icons = {
          # empty = "";
          active = "";
          default = "";
        };
      };

      cpu = {
        interval = 1;
        format = "  {usage}%";
        max-length = 10;
      };
      disk = {
        interval = 30;
        format = "  {specific_free:0.1f}G";
        unit = "GB";
      };
      memory = {
        interval = 2;
        format = "  {used:0.1f}G";
      };
      network = {
        format-wifi = "  {bandwidthTotalBytes}";
        format-ethernet = "󰈀  {bandwidthTotalBytes}";
        format-disconnected = "net none";
        tooltip-format = "{ifname} via {gwaddr}";
        tooltip-format-wifi = "Connected to: {essid} {frequency} - ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname} via {gwaddr}";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
        interval = 5;
      };

      "custom/weather" = {
        interval = 60 * 20;
        exec = "weather \"{icon}  {temp}{unit}\"";
      };

      hyprland.window.format = "{class}";
      tray = {
        icon-size = 18;
        spacing = 10;
      };
      "custom/sep".format = "|";

      mpris = {
        format = "  {title}";
        max-length = 30;
      };

      clock = {
        format = "  {:%I:%M %p}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='${config.lib.stylix.colors.withHashtag.base0A}'><b>{}</b></span>"; # yellowish
            days = "<span color='${config.lib.stylix.colors.withHashtag.base08}'><b>{}</b></span>"; # red/pink
            weeks = "<span color='${config.lib.stylix.colors.withHashtag.base0C}'><b>W{}</b></span>"; # cyan
            weekdays = "<span color='${config.lib.stylix.colors.withHashtag.base0E}'><b>{}</b></span>"; # orange/violet
            today = "<span color='${config.lib.stylix.colors.withHashtag.base09}'><b><u>{}</u></b></span>"; # bright highlight
          };
        };

        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up"; # or "tz_up"
          on-scroll-down = "shift_down"; # or "tz_down"
        };
      };

      "custom/nix".format = "<span size='large'> </span>";

      "custom/dunst" = {
        interval = 1;
        exec = pkgs.writeShellScript "dunst_status" ''
          COUNT=$(dunstctl count waiting)
          ENABLED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0F}'>  </span>"
          DISABLED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0F}'>  </span>"
          if [ $COUNT != 0 ]; then DISABLED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0F}'>  </span>"; fi
          if dunstctl is-paused | grep -q "false" ; then echo $ENABLED; else echo $DISABLED; fi
        '';

        on-click = "dunstctl set-paused toggle";
      };

      "custom/focus" = {
        interval = 1;
        exec = pkgs.writeShellScript "focus_status" ''

          FORMAT_ACTIVE="<span size='large' color='${config.lib.stylix.colors.withHashtag.base08}'> </span>"
          FORMAT_INACTIVE="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0C}'> </span>"

          if focus status | grep yes > /dev/null; then echo $FORMAT_ACTIVE; else echo $FORMAT_INACTIVE; fi
        '';
        on-click = "focus toggle";
      };

      pulseaudio = {
        format = "<span size='large'>󰕾 </span> {volume}%";
        format-muted = "  0%";
      };
      bluetooth = {
        format-disconnected = "<span size='large'󰂯 </span>{device_alias}";
        format-connected = "<span size='large'>󰂱 </span>{device_alias}";
        tooltip = true;
        tooltip-format = "{device_enumerate}";
      };
    };
  };
in
{
  home.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = waybar_config;
    style = builtins.readFile ./style.css;
  };
}
