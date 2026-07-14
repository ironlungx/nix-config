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
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    inputs.stylix.homeModules.stylix
    inputs.helium-flake.homeModules.default

    ./modules
  ];

  nixpkgs = {
    overlays = [
      inputs.firefox-addons.overlays.default
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
    xclip
    devenv
    tldr
    obsidian
    anki
    sooperlooper
    wl-kbptr
  ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    cava.enable = true;
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
    enable = false;
    blockedApps = [ "electron" ];
  };

  services.weather = {
    enable = true;
    latitude = secrets.latitude;
    longitude = secrets.longitude;
    format = "{icon}  {temp} {unit}";
  };

  programs.helium = {
    enable = true;

    # Optional: override the package
    # package = pkgs.helium;

    # 🚩 Flags - Command-line arguments always passed to Helium
    # flags = [
    #   "--enable-features=TouchpadOverscrollHistoryNavigation"
    #   "--start-maximized"
    # ];
    #
    # # Optional: user policies (best-effort, use NixOS module for critical policies)
    # policies = {
    #   "BrowserSignin" = 0;
    # };
  };

  xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
