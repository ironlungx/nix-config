{
  inputs,
  system,
  lib,
  config,
  pkgs,
  ...
}:
let
  secrets = import ./secrets.nix;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index # Black magic
    inputs.nixcord.homeModules.nixcord
    inputs.stylix.homeModules.stylix
    inputs.helium-flake.homeModules.default
    ./modules/lothlorien-modules.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "audio-relay" ];
    };
  };

  home = {
    username = "ironlung";
    homeDirectory = "/home/ironlung";
    sessionPath = [
      "$HOME/.local/bin" # Add support for .local/bin
    ];
  };

  home.packages = with pkgs; [
    thunar
    distrobox
    tldr
    obsidian
    anki
    kanata
    pwvucontrol
  ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    cava.enable = true;
    helium.enable = true;
  };

  services.weather = {
    enable = true;
    latitude = secrets.latitude;
    longitude = secrets.longitude;
    format = "{icon}  {temp} {unit}";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "ironlungx";
      email = "hwlooverhello@gmail.com";
    };
  };

  systemd.user.startServices = "sd-switch";
  services.udiskie.enable = true;
  home.stateVersion = "25.05";
}
