{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tunneler;
  
  # Python environment with required packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [ requests pyyaml ]);
  
  # Path to your tunneler.py script
  tunnelerScript = ./tunneler.py;
  
  # Executable script that calls tunneler.py with arguments
  tunnelerExecutable = pkgs.writeScriptBin "tunneler" ''
    #!${pkgs.bash}/bin/bash
    exec ${pythonEnv}/bin/python3 ${tunnelerScript} "${cfg.secrets}" "${cfg.ports}"
  '';

in {
  options = {
    services.tunneler = {
      enable = mkEnableOption "Tunneler service";
      
      secrets = mkOption {
        type = types.str;
        description = "Path to secrets file";
        example = "/etc/tunneler/secrets.yaml";
      };
      
      ports = mkOption {
        type = types.str;
        description = "Ports to forward in format: local:remote,local2:remote2";
        example = "25565:25565,1000:2000";
      };
      
      user = mkOption {
        type = types.str;
        default = "tunneler";
        description = "User to run the tunneler service as";
      };
      
      group = mkOption {
        type = types.str;
        default = "tunneler";
        description = "Group to run the tunneler service as";
      };
    };
  };

  config = mkIf cfg.enable {
    # Add the executable to system packages
    environment.systemPackages = [ tunnelerExecutable ];
    
    # Create user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "Tunneler service user";
    };
    
    users.groups.${cfg.group} = {};
    
    # Create systemd service
    systemd.services.tunneler = {
      description = "Tunneler service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${tunnelerExecutable}/bin/tunneler";
        Restart = "always";
        RestartSec = "10";
        
        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/lib/tunneler" ];
      };
    };
    
    # Create state directory
    systemd.tmpfiles.rules = [
      "d /var/lib/tunneler 0755 ${cfg.user} ${cfg.group} -"
    ];
  };
}
