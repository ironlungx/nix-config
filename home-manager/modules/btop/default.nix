{ lib, config, ... }:
let
  cfg = config.myhm.btop;
in
{
  options.myhm.btop.enable = lib.mkEnableOption "btop";

  config.programs.btop = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      update_ms = 200;
      vim_keys = true;
    };
  };
}
