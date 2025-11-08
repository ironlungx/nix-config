{
  inputs,
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
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    inputs.stylix.homeModules.stylix

    ./modules
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
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
    xclip

    devenv

    # aider-chat
    tldr

    obsidian

    lutris

    # stremio
    # inputs.seto.packages.${pkgs.system}.default
  ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    cava.enable = true;
    zen-browser.enable = true;
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

  services.kdeconnect.enable = true;

  services.focus-mode = {
    enable = true;
    blockedApps = [ "electron" ];
  };

  services.weather = {
    enable = true;
    latitude = secrets.latitude;
    longitude = secrets.longitude;
    format = "{icon}  {temp} {unit}";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
