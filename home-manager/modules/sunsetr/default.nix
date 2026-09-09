{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myhm.sunsetr;
in
{
  options.myhm.sunsetr.enable = lib.mkEnableOption "sunsetr";
  config.home.packages = lib.mkIf cfg.enable [
    pkgs.sunsetr
  ];

}
