{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  secrets = import ../secrets.nix;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    inputs.helium-flake.homeModules.default
    ../modules
    ../wm/niri
  ];

  myhm = {
    isLaptop = false;
    keyboardLayout = "us";
    launcher = "tofi";

    foot.enable = true;
    waybar.enable = true;
    dunst.enable = true;
    hyprlock.enable = true;
  };

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
    sessionPath = [ "$HOME/.local/bin" ];
    packages = with pkgs; [
      thunar
      distrobox
      xclip
      devenv
      tldr
      obsidian
      anki
      sooperlooper
      prismlauncher
      mangohud
      qpwgraph
    ];
    stateVersion = "25.05";
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    cava.enable = true;
    git = {
      enable = true;
      settings.user = {
        name = "ironlungx";
        email = "hwlooverhello@gmail.com";
      };
    };
    helium.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  services = {
    udiskie.enable = true;
    kdeconnect.enable = true;
    focus-mode = {
      enable = false;
      blockedApps = [ "electron" ];
    };
    weather = {
      enable = true;
      latitude = secrets.latitude;
      longitude = secrets.longitude;
      format = "{icon}  {temp} {unit}";
    };
  };

  xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
}
