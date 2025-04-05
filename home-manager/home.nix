{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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
    sessionPath = [ # Add support for .local/bin in order to make mason work on NixOS
      "$HOME/.local/bin"
    ];
  };

  programs.neovim.enable = true;
  home.packages = with pkgs; [
    alacritty
    kitty
    fish
    xclip
  ];

  programs.home-manager.enable = true;

  programs.git = { enable = true; userName = "ironlungx"; userEmail = "hwlooverhello@gmail.com"; };

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
