{
  config,
  lib,
  pkgs,
  ...
}:
let
  rofiTheme = ./catppuccin-frappe.rasi;
  cfg = config.myhm.rofi;
in
{
  options.myhm.rofi.enable = lib.mkEnableOption "rofi";

  config.home.packages =
    with pkgs;
    lib.mkIf cfg.enable [
      adwaita-icon-theme
    ];

  config.programs.rofi = lib.mkIf (config.myhm.launcher == "rofi") {
    enable = true;
    terminal = config.myhm.terminal;
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
