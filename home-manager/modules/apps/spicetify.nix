{
  lib, 
  inputs,
  pkgs,
  ...
}: {
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
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
