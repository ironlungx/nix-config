{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    
    ./modules/shell/fish.nix
    ./modules/shell/zoxide.nix
    ./modules/shell/starship.nix
    ./modules/shell/eza.nix
    ./modules/stylix.nix

    ./modules/apps/kitty.nix
    ./modules/cli
  ];

  nixpkgs = {
    overlays = [];
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
    firefox
  ];


  programs = {
    home-manager.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "ironlungx";
    userEmail = "hwlooverhello@gmail.com";
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
