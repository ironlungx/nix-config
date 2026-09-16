{
  config,
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
    inputs.nix-index-database.homeModules.nix-index
    inputs.helium-flake.homeModules.default

    ../modules
    ../wm/niri
  ];

  myhm = {
    isLaptop = true;
    keyboardLayout = "gb,us";
    launcher = "tofi";
    terminal = "alacritty";
    browser = "qutebrowser";
    wallpaper = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ironlungx/wallpapers/refs/heads/main/in%20rainbows_themed_catppuccin-frappe.jpg";
      sha256 = "0hkrb2973ms6qy099i5d8kb9fbxqpl5vh1clf2735jwjzmlvn6sf";

    };

    wlsunset.enable = true;
    bluetooth-menu.enable = true;
    foot.enable = true;
    waybar.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    hyprlock.enable = true;
    nixcord.enable = true;
    firefox.enable = true;
  };

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "audio-relay" ];
      permittedInsecurePackages = [
        "electron-40.10.5"
      ];
    };
  };

  home = {
    username = "ironlung";
    homeDirectory = "/home/ironlung";
    sessionPath = [ "$HOME/.local/bin" ];
    packages = with pkgs; [
      steam
      thunar
      distrobox
      tldr
      obsidian
      anki
      pwvucontrol
      qpwgraph
      sioyek
      mpv
      pass
      gnupg
    ];
    stateVersion = "26.11";
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    cava.enable = true;
    helium.enable = config.myhm.browser == "helium";
    git = {
      enable = true;
      settings.user = {
        name = "ironlungx";
        email = "hwlooverhello@gmail.com";
      };
    };
  };

  services = {
    weather = {
      enable = false;
      latitude = secrets.latitude;
      longitude = secrets.longitude;
      format = "{icon}  {temp} {unit}";
    };
    udiskie.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
