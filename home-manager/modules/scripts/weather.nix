{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.focus-mode;
in {
  options.services.weather = {
    enable = mkEnableOption "weather service";
    latitude = mkOption {type = types.float;};
    longitude = mkOption {type = types.float;};


  };
}
