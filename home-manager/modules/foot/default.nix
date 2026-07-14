{ config, lib, ... }:
let
  cfg = config.myhm.foot;
in
{
  options.myhm.foot.enable = lib.mkEnableOption "foot";

  config.programs.foot = lib.mkIf cfg.enable {
    enable = true;
    server.enable = true;
    settings.main = {
      pad = "10x10";
    };
  };
}
