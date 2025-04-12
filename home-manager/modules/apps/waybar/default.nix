{pkgs, ...}: let
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
      network = {
        format-wifi = "  {bandwidthTotalBytes}";
        format-ethernet = "eth {ipaddr}/{cidr}";
        format-disconnected = "net none";
        tooltip-format = "{ifname} via {gwaddr}";
        tooltip-format-wifi = "Connected to: {essid} {frequency} - ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname}";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
        interval = 5;
      };
      memory = {
        interval = 2;
        format = "  {used:0.2f}G";
      };
      hyprland.window.format = "{class}";
      tray = {
        icon-size = 18;
        spacing = 10;
      };
      custom.sep.format = "|";
      mpris = {
        format = "  {title}";
        max-length = 30;
      };
      clock.format = "  {:%I:%M %p}";
      custom.nix.format = "<span size='large'> </span>";
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
    settings = waybar_config;
    style = builtins.readFile ./style.css;
  };
}
