{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index # Black magic
    inputs.nixcord.homeManagerModules.nixcord
    inputs.spicetify-nix.homeManagerModules.default
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
    xclip
    stow

    devenv
    arduino-ide

    aider-chat
    inputs.seto.packages.${pkgs.system}.default

    tldr

    obsidian
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
  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
