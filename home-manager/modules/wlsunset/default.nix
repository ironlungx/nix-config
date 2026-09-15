{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myhm.wlsunset;
in
{
  options.myhm.wlsunset.enable = lib.mkEnableOption "wlsunset";
  config.home.packages = lib.mkIf cfg.enable [
    pkgs.wlsunset
  ];

}
