{ lib, config, ... }:
let
  cfg = config.myhm.eza;
in
{
  options.myhm.eza.enable = lib.mkEnableOption "eza";
  config.programs.eza = lib.mkIf cfg.enable {
    enable = true;
    icons = "auto";
    colors = "always";
    extraOptions = [
      "-A"
      "-l"
      "-U"
      "--no-permissions"
      "--no-user"
      "--color=auto"
      "--group-directories-first"
    ];
    enableFishIntegration = true;
  };
}
