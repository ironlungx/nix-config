{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myhm.waybar;
  isLaptop = config.myhm.isLaptop;

  # detect active WM from what the host imported, rather than a separate flag
  wmModule =
    if config.programs.niri.enable or false then
      "niri"
    else if config.wayland.windowManager.hyprland.enable or false then
      "hyprland"
    else
      "sway";

  workspacesModule =
    {
      niri = "niri/workspaces";
      hyprland = "hyprland/workspaces";
      sway = "sway/workspaces";
    }
    .${wmModule};

  waybar_config = {
    mainBar = {
      "layer" = "top";
      "position" = "bottom";
      "modules-left" = [
        "custom/nix"
        workspacesModule
        "sway/mode"
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
        "network"
      ]

      ++ lib.optional (wmModule == "niri") "niri/language"
      ++ (if isLaptop then [ "battery" ] else [ "bluetooth" ])
      ++ [
        "custom/sep"
        "custom/dunst"
        "custom/focus"
        "tray"
      ];

      "sway/mode" = {
        "format" = "{}";
        "max-length" = 50;
      };

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

      #"sway/workspaces": {
      #   "format": "<span size='larger'>{name}</span> {windows}",
      #   "format-window-separator": " | ",
      #   "window-rewrite-default": "{name}",
      #   "window-format": "<span color='#e0e0e0'>{name}</span>",
      #   "window-rewrite": {
      #     "class<firefox> title<.*chat.gig.tech.*>": "",
      #     "class<kitty>": "",
      #   }
      # }

      # "1": "",
      # "2": "",
      # "3": "",
      # "4": "",
      # "5": "",
      # "urgent": "",
      # "focused": "",
      # "default": "",

      "sway/workspaces" = {
        "format" = "{name}";
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

      "niri/language" = {
        format = "{long}";
      };

      "battery" = {
        "bat" = "BAT0";
        "interval" = 8;
        "format" = "{icon} {capacity}%";
        "format-icons" = {
          "default" = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          "charging" = [
            "󰢟"
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
        };
        tooltip-format = "{timeTo}, {power}W";
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
  options.myhm.waybar.enable = lib.mkEnableOption "waybar";
  config.home.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
  config.programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = waybar_config;
    style = builtins.readFile ./style.css;
  };
}
