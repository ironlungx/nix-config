
{ pkgs, ... }:
/* let
  themeZip = pkgs.fetchurl {
    name = "catppuccin-frappe-prismlauncher.zip";
    url = "https://github.com/PrismLauncher/Themes/releases/download/2025-03-07_1741339143/Catppuccin-Frappe-theme.zip";
    sha256 =  "10hl2mcadvx20fylzrqlmddl844jcfby7fbn76cn5ilwy1gc691v";
    postFetch = ''
      cp $out theme.zip
      ${pkgs.unzip}/bin/unzip theme.zip -d $out
    '';
  };
in */
{
  home.packages = with pkgs; [
    prismlauncher
  ];
  # home.file.".local/share/PrismLauncher/themes/Catppuccin-Frappe-theme" = {
  #   source = themeZip;
  # };
}

