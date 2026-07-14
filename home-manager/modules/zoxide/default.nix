{ lib, config, ... }:
let
  cfg = config.myhm.zoxide;
in
{
  options.myhm.zoxide.enable = lib.mkEnableOption "zoxide";
  config.programs.zoxide.enable = cfg.enable;
}
