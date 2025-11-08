{
  config,
  lib,
  pkgs,
  ...
}:
let
  rofiTheme = ./catppuccin-frappe.rasi;
in
{
  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
  programs.rofi = {
    enable = true;
    terminal = "kitty";
    theme = rofiTheme;

    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];

    extraConfig = {
      modi = "run,drun,emoji,calc";
      icon-theme = "Adwaita";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-emoji = " 󰞅 Emoji ";
      display-calc = " Calc";
      sidebar-mode = true;
    };
  };
}
