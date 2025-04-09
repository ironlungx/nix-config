{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  waybar_config = import ./config.nix;
  waybar_style = import ./style.nix;
in {
  programs.waybar = {
    enable = true;
    settings = waybar_config;
    style = waybar_style;
  };
}
