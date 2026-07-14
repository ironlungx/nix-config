{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.myhm.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  options.myhm.spicetify.enable = lib.mkEnableOption "spicetify";

  config.programs.spicetify = lib.mkIf cfg.enable {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      popupLyrics
    ];
    # theme = spicePkgs.themes.catppuccin;
    # colorScheme = "frappe";
  };
}
