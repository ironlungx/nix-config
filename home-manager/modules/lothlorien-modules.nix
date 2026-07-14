{ lib, pkgs, ... }:
{
  imports = [
    ./niri
    ./cli
    ./shell
    ./apps/foot.nix
    ./apps/waybar
    ./apps/rofi
    ./apps/dunst.nix
    ./scripts/weather.nix
    ./stylix.nix

    ./apps/dunst.nix
    ./apps/hyprlock.nix
    ./apps/nixcord.nix
  ];

  programs.tofi = {
    enable = true;

    # # Catppuccin Frappé

    settings = {
      # text-color = "#c6d0f5";
      # prompt-color = "#e78284";
      # selection-color = "#e5c890";
      # background-color = "#303446";
      border-width = 0;
      height = "100%";
      num-results = 7;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      width = "100%";
    };
  };
}
