{
  config,
  pkgs,
  ...
}: let
  waybar_config = {
    mainBar = {
      "layer" = "top";
      "position" = "bottom";
      "modules-left" = [
        "custom/nix"
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
        "network"
        "pulseaudio"
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

      clock.format = "  {:%I:%M %p}";

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
    };
  };
in {
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
