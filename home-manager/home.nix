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
    inputs.stylix.homeManagerModules.stylix

    ./modules/nixcord.nix
    ./modules/nvim.nix
    ./modules/hyprland
    ./modules/spicetify.nix
    ./modules/gaming.nix
    ./modules/stylix.nix
    ./modules/waybar.nix
    ./modules/zen.nix
    ./modules/kitty.nix
    ./modules/fish.nix
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
    alacritty
    fish
    xclip
    stow
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "ironlungx";
    userEmail = "hwlooverhello@gmail.com";
  };

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
