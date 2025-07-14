{
  config,
  lib,
  pkgs,
  ...
}: {
  wsl.enable = true;
  wsl.defaultUser = "ironlung";

  programs.fish.enable = true;
  users.users.ironlung.shell = pkgs.fish;

  nix.settings.experimental-features = "nix-command flakes";

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/ironlung/nix-config";
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
