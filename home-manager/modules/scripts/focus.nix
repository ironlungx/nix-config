{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.focus-mode;
in {
  options.services.focus-mode = {
    enable = mkEnableOption "focus mode service";

    stateFile = mkOption {
      type = types.str;
      default = "/tmp/is_focus";
      description = "File used to track focus mode state";
    };

    blockedApps = mkOption {
      type = types.listOf types.str;
      default = ["electron"];
      description = "List of processes to kill when focus mode is active";
    };

    pollingInterval = mkOption {
      type = types.float;
      default = 0.5;
      description = "Polling interval in seconds";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.killall
      (pkgs.writeShellScriptBin "focus" ''
        FILE="${cfg.stateFile}"

        is_focus() {
          if [ -f "$FILE" ]; then
            return 0  # In Bash, 0 means true
          else
            return 1  # Non-zero values mean false
          fi
        }

        toggle() {
          if [ -f "$FILE" ]; then
            rm "$FILE"
          else
            touch "$FILE"
          fi
        }

        ## Main execution
        if [[ "$1" == "toggle" ]]; then
          toggle
          exit 0
        elif [[ "$1" == "status" ]]; then
          if is_focus; then
            echo "yes"
          else
            echo "no"
          fi
        fi
      '')
    ];

    systemd.user.services.focus-mode-daemon = {
      Unit = {
        Description = "Focus mode daemon service";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = toString (pkgs.writeShellScript "focus-daemon" ''
          FILE="${cfg.stateFile}"
          POLLING_INTERVAL="${toString cfg.pollingInterval}"

          while true; do
            while [ ! -f "$FILE" ]; do
              sleep $POLLING_INTERVAL
            done

            while [ -f "$FILE" ]; do
              ${concatStringsSep "\n" (map (app: "killall -9 ${app} > /dev/null 2>&1 || true") cfg.blockedApps)}
              sleep $POLLING_INTERVAL
            done
          done
        '');
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
