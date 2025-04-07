{ pkgs, ... }: {
  home.packages = [ pkgs.waybar ];

  home.file.".config/waybar/config".source = pkgs.writers.writeJSON "waybar-config" {
    layer = "top";
    position = "top";
    height = 24;
    spacing = 4;
    "margin-top" = 0;
    "margin-bottom" = 0;

    modules-left = [
      "custom/launcher"
        "wlr/workspaces"
    ];
    modules-center = [
      "hyprland/window"
    ];
    modules-right = [
      "custom/settings"
        "cpu"
        "network"
        "custom/storage"
        "pulseaudio"
        "battery"
        "clock"
    ];

    "wlr/workspaces" = {
      format = "{name}";
      "on-click" = "activate";
      "all-outputs" = true;
      "sort-by-number" = true;
      "format-icons" = {
        urgent = "";
        active = "";
        default = "";
      };
    };

    "hyprland/window" = {
      format = "󰲎 {}";
      "max-length" = 60;
      "separate-outputs" = true;
    };

    "custom/launcher" = {
      format = "";
      "on-click" = "wofi --show drun";
      tooltip = false;
    };

    "custom/settings" = {
      format = "⚙";
      "on-click" = "XDG_CURRENT_DESKTOP=gnome gnome-control-center";
      tooltip = false;
    };

    clock = {
      format = "{:%d %B %a %H:%M}";
      tooltip = false;
    };

    cpu = {
      interval = 10;
      format = "{usage}%";
      "max-length" = 10;
      tooltip = false;
    };

    "custom/storage" = {
      format = "Pron Folder {}";
      "format-alt" = "{percentage}%";
      "format-alt-click" = "click-right";
      "return-type" = "json";
      interval = 60;
      exec = "echo '{\"text\":\"100TB\", \"percentage\": 95}'";
    };

    network = {
      format = "{ifname}";
      "format-wifi" = "  {essid}";
      "format-ethernet" = " {ifname}";
      "format-disconnected" = "";
      "tooltip-format" = "{ifname}";
      "tooltip-format-wifi" = "{essid} ({signalStrength}%)";
      "tooltip-format-ethernet" = "{ifname}";
      "tooltip-format-disconnected" = "Disconnected";
      "max-length" = 20;
    };

    pulseaudio = {
      format = "{volume}%";
      "format-bluetooth" = " {volume}%";
      "format-muted" = "󰝟";
      "format-icons" = {
        headphone = "";
        "hands-free" = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" ];
      };
      "scroll-step" = 5;
      "on-click" = "pavucontrol";
      "ignored-sinks" = [ "Easy Effects Sink" ];
    };

    battery = {
      interval = 60;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}%";
      "format-icons" = [ "" "" "" "" "" ];
    };
  };
               }
