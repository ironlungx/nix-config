# modules/tofi/default.nix
{ lib, config, ... }:
let
  cfg = config.myhm;
in
{
  config.programs.tofi = lib.mkIf (cfg.launcher == "tofi") {
    enable = true;
    settings = {
      border-width = 0;
      height = "100%";
      num-results = 7;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      width = "100%";
    };
  };
}
