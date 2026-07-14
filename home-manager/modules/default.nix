# modules/default.nix
{ lib, ... }:
let
  here = ./.;
  entries = builtins.readDir here;

  isCandidate =
    name: type:
    name != "default.nix"
    && (
      (type == "directory" && builtins.pathExists (here + "/${name}/default.nix"))
      || (type == "regular" && lib.hasSuffix ".nix" name)
    );

  candidates = lib.filterAttrs isCandidate entries;
in
{
  imports = lib.mapAttrsToList (name: _: here + "/${name}") candidates;

  # minimal stuff to be enabled
  myhm = {
    nvim.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    fish.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    zoxide.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
    btop.enable = lib.mkDefault true;
  };

}
