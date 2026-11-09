{
  config,
  inputs,
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
    launcher = "rofi";
    terminal = "footclient";
    browser = "helium";

    wlsunset.enable = true;
    bluetooth-menu.enable = true;
    foot.enable = true;
    waybar.enable = true;
    dunst.enable = true;
    hyprlock.enable = true;
    nixcord.enable = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
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
      tldr
      obsidian
      anki
      sooperlooper
      prismlauncher
      qpwgraph
      pwvucontrol
      ncmpcpp
      mpc
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
    helium.enable = config.myhm.browser == "helium";
  };

  services.mpd-mpris.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "~/music/";
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    extraConfig = ''
      audio_output {
        type                    "fifo"
        name                    "my_fifo"
        path                    "/tmp/mpd.fifo"
        format                  "44100:16:2"
      }

      audio_output {
        type            "pulse"
        name            "PulseAudio output"
      }
    '';
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
