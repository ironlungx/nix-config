{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.weather;

  # Python environment with required packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [requests]);

  # Path to your weather.py script (must be in same directory as this module)
  weatherScript = ./weather.py;

  # First script: calls weather.py with args
  weatherExecutable = pkgs.writeScriptBin "weather-service" ''
    #!${pkgs.bash}/bin/bash
    exec ${pythonEnv}/bin/python3 ${weatherScript} "$@"
  '';

  # Second script: hardcodes lat, long, and format from config
  weatherLauncher = pkgs.writeScriptBin "weather" ''
    #!${pkgs.bash}/bin/bash
    ${weatherExecutable}/bin/weather-service ${toString cfg.latitude} ${toString cfg.longitude} '${cfg.format}'
  '';
in {
  options.services.weather = {
    enable = mkEnableOption "weather service";

    latitude = mkOption {
      type = types.float;
      description = "Latitude for weather lookup.";
    };

    longitude = mkOption {
      type = types.float;
      description = "Longitude for weather lookup.";
    };

    format = mkOption {
      type = types.str;
      description = "Format string passed to weather.py (e.g. '{temp}°C').";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      weatherExecutable
      weatherLauncher
    ];
  };
}
