{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  secrets = import ./secrets.nix;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index # Black magic
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    inputs.stylix.homeModules.stylix

    ./modules
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "ironlung";
    homeDirectory = "/home/ironlung";
    sessionPath = [
      "$HOME/.local/bin" # Add support for .local/bin in order to make mason work on NixOS
    ];

    file = {}; # TODO: Move from stow to this
  };

  home.packages = with pkgs; [
    youtube-music
    xclip
    stow

    devenv
    arduino-ide

    aider-chat
    inputs.seto.packages.${pkgs.system}.default

    tldr

    obsidian

    stremio

    rclone
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.cava.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 200;
      vim_keys = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "ironlungx";
    userEmail = "hwlooverhello@gmail.com";
  };

  systemd.user.startServices = "sd-switch";
  services.udiskie.enable = true;
  services.fluidsynth.enable = true;

  services.focus-mode = {
    enable = true;
    blockedApps = ["electron"];
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
