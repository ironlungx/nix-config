{config, pkgs, ...}: 
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  home.packages = [pkgs.waybar];

  home.file.".config/waybar/config".source = pkgs.writers.writeJSON "waybar-config" {
    position = "top";
    layer = "top";
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;

    modules-left = [
      "hyprland/workspaces"
    ];
    modules-center = [
    ];
    modules-right = [
    ];

    clock = {
      format = "󰥔  {:%a, %d %b, %I:%M %p}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "   {:%d/%m}";
    };

    "hyprland/workspaces" = {
      active-only = false;
      all-outputs = false;

      disable-scroll = false;

      on-scroll-up = "hyprctl dispatch workspace e-1";
      on-scroll-down = "hyprctl dispatch workspace e+1";

      format = "{icon}";
      on-click = "activate";

      format-icons = {
        urgent = "";
        active = "";
        default = "";
        sort-by-number = true;
      };
    };

    "custom/playerlabel" = {
      format = "<span>󰎈 {} 󰎈</span>";
      return-type = "json";
      max-length = 40;
      exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
      on-click = "";
    };

    memory = {
      format = "󰍛 {}%";
      format-alt = "󰍛 {used}/{total} GiB";
      interval = 5;
    };

    cpu = {
      format = "󰻠 {usage}%";
      format-alt = "󰻠 {avg_frequency} GHz";
      interval = 5;
    };

    network = {
      format-wifi = "  {signalStrength}%";
      format-ethernet = "󰈀 100% ";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 0% ";
    };

    tray = {
      icon-size = 20;
      spacing = 8;
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰝟";
      format-icons = {
        default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
      };
      # on-scroll-up= "bash ~/.scripts/volume up";
      # on-scroll-down= "bash ~/.scripts/volume down";
      scroll-step = 5;
      on-click = "pavucontrol";
    };
  };

  /* home.file.".config/waybar/style.css".source = pkgs.writers.writeText "waybar-style" ''
        * {
            border: none;
            border-radius: 0px;
            min-height: 0;
        }

        window#waybar {
            background-color: ${base00};
        }

        #cava.left, #cava.right {
            background: ${base01};
            margin: 5px;
            padding: 8px 16px;
            color: ${base0E};
        }
        #cava.left {
            border-radius: 24px 10px 24px 10px;
        }
        #cava.right {
            border-radius: 10px 24px 10px 24px;
        }
        #workspaces {
            background: ${base01};
            margin: 5px 5px;
            padding: 8px 5px;
            border-radius: 16px;
            color: ${base0E}
        }
        #workspaces button {
            padding: 0px 5px;
            margin: 0px 3px;
            border-radius: 16px;
            color: transparent;
            background-color: ${base01};
            transition: all 0.3s ease-in-out;
        }

        #workspaces button.active {
            background-color: ${base0B};
            color: ${base01};
            border-radius: 16px;
            min-width: 50px;
            background-size: 400% 400%;
            transition: all 0.3s ease-in-out;
        }

        #workspaces button:hover {
            background-color: ${base08};
            color: ${base01};
            border-radius: 16px;
            min-width: 50px;
            background-size: 400% 400%;
        }

        #custom-notification, #tray, #pulseaudio, #network, #battery, #backlight,
        #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward{
            background: ${base01};
            font-weight: bold;
            margin: 5px 0px;
        }
        #custom-notification, #tray, #pulseaudio, #network, #backlight, #battery{
            color: ${base0E};
            border-radius: 10px 24px 10px 24px;
            padding: 0 20px;
            margin-left: 7px;
        }
        #clock {
            color: ${base08};
            background-color: ${base01};
            border-radius: 0px 0px 0px 40px;
            padding: 10px 10px 15px 25px;
            margin-left: 7px;
            font-weight: bold;
            font-size: 16px;
        }
        #custom-launcher {
            color: ${base0B};
            background-color: ${base01};
            border-radius: 0px 0px 40px 0px;
            margin: 0px;
            padding: 0px 35px 0px 15px;
            font-size: 28px;
        }

        #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward {
            background: ${base01};
            font-size: 22px;
        }
        #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.foward:hover{
            color: ${base08};
        }
        #custom-playerctl.backward {
            color: ${base0E};
            border-radius: 24px 0px 0px 10px;
            padding-left: 16px;
            margin-left: 7px;
        }
        #custom-playerctl.play {
            color: ${base0B};
            padding: 0 5px;
        }
        #custom-playerctl.foward {
            color: ${base0E};
            border-radius: 0px 10px 24px 0px;
            padding-right: 12px;
            margin-right: 7px
        }
        #custom-playerlabel {
            background: ${base01};
            color: ${base08};
            padding: 0 20px;
            border-radius: 24px 10px 24px 10px;
            margin: 5px 0;
            font-weight: bold;
        }
        #window{
            background: ${base01};
            padding-left: 15px;
            padding-right: 15px;
            border-radius: 16px;
            margin-top: 5px;
            margin-bottom: 5px;
            font-weight: normal;
            font-style: normal;
        }
      ''; */
}
