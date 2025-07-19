{
  pkgs,
  lib,
  ...
}:
with lib; {
  services.minecraft-servers = let
    myPlugins = pkgs.linkFarm "paper-plugins" [
      {
        name = "LuckPerms.jar";
        path = pkgs.fetchurl {
          url = "https://download.luckperms.net/1594/bukkit/loader/LuckPerms-Bukkit-5.5.9.jar";
          sha256 = "0rslb3bwyw4si23crnax9h1py8q0vnbf8l47y6ai67asmmjk1fzq"; # replace with actual hash!
        };
      }
      {
        name = "Chunky.jar";
        path = pkgs.fetchurl {
          url = "https://www.spigotmc.org/resources/chunky.81534/download?version=594423";
          sha256 = "08cpq11i83rc949b33dj4dvf2dmqpr6y676ybbhi447ph3y7fm1a";
        };
      }
      {
        name = "ViaVersion.jar";
        path = pkgs.fetchurl {
          url = "https://github.com/ViaVersion/ViaVersion/releases/download/5.4.1/ViaVersion-5.4.1.jar";
          sha256 = "1bbh5g872nds9vs61s9zzr4lfx5rivqvyyaf5riqkkbxxq4fdshv";
        };
      }
      {
        name = "Voicechat.jar";
        path = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/ZemsH7tW/voicechat-bukkit-2.5.34.jar";
          sha256 = "0diwbw8xhqvvgmwzr00fxk6dp4plr0ixq1mxgspx4n0g0naa2wxl";
        };
      }
      {
        name = "BoundlessForging.jar";
        path = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/jnw9A185/versions/BZ47T5h9/BoundlessForging-1.0-SNAPSHOT.jar";
          sha256 = "1jdihzydhvz70n8ibj6ny1pgys2hkj7r6dgfqnlhddm4d41nxq2x";
        };
      }
    ];
    customPaper = pkgs.callPackage (
      {
        lib,
        stdenvNoCC,
        fetchurl,
        makeBinaryWrapper,
        jre,
        udev,
      }:
        stdenvNoCC.mkDerivation {
          pname = "papermc";
          version = "1.21.8-6";

          src = fetchurl {
            url = "https://fill-data.papermc.io/v1/objects/37b7ca967d81ba06ccb7986efc7f41b9faaaca1e06b351b8b3da102d35f9574e/paper-1.21.8-6.jar";
            sha256 = "0kjpz4sjs46snfw53cq63v5amymr85zzqvlqnz60dfl1gnbcmdrp";
          };

          installPhase = ''
            runHook preInstall

            install -D $src $out/share/papermc/papermc.jar

            makeWrapper ${lib.getExe jre} "$out/bin/minecraft-server" \
              --append-flags "-jar $out/share/papermc/papermc.jar nogui" \
              ${lib.optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [udev]}"}

            runHook postInstall
          '';

          nativeBuildInputs = [makeBinaryWrapper];

          dontUnpack = true;
          preferLocalBuild = true;
          allowSubstitutes = false;

          meta = {
            description = "High-performance Minecraft Server";
            homepage = "https://papermc.io/";
            sourceProvenance = with lib.sourceTypes; [binaryBytecode];
            license = lib.licenses.gpl3Only;
            platforms = lib.platforms.unix;
            mainProgram = "minecraft-server";
          };
        }
    ) {};
  in {
    enable = true;
    eula = true;
    openFirewall = true;

    dataDir = "/var/lib/minecraft-servers";
    servers.paper = {
      enable = true;
      managementSystem = {
        tmux.enable = false;
        systemd-socket.enable = true;
      };
      files.plugins = myPlugins;
      files."world/datapacks/blaze_and_caves.zip" = pkgs.fetchurl {
        name = "blaze_and_caves.zip";
        url = "https://cdn.modrinth.com/data/VoVJ47kN/versions/cFFa5Axs/BlazeandCave%27s%20Advancements%20Pack%201.19.1.zip";
        sha256 = "0jlkn0s08z1a7700w8mssyb3b7rmr6m5i8xkszda22kbkxgy5hfz";
      };
      jvmOpts = "-Xmx4G";
      package = customPaper;
      serverProperties = {
        seed = -5902773664138819552;
        server-port = 25565;
        difficulty = 3;
        gamemode = 1;
        motd = "hmmmmmmmmm";
        sync-chunk-writes = false;
        simulation-distance = "8";
        white-list = true;
        enable-rcon = true;
        "rcon.password" = "hunter2";
        "rcon.port" = 25575;
        "plugin-remapping" = false;
      };
      whitelist = {
        IronLung127 = "4fcfb1c0-7a2a-4d16-a427-3acbb1718aa6";
        Vachan = "aa70b729-4cfa-49ff-92bc-fcf56f40f5e5";
        SeaHarbor481470 = "2d9a3f09-ab46-436c-a2e9-219149410fe4";
        darklord2057241 = "6e5f1fa3-dd9f-4ea7-9a79-0d16e97a2cef";
        Just_A_guy565 = "56f081f6-365a-4c75-8625-8b4796df6ef0";
        subsonichunter1 = "b2be56fd-b076-43fd-bdeb-911b3a2e508a";
      };
    };
  };

  options.services.tunneler = let
    cfg = config.services.tunneler;
    pythonEnv = pkgs.python3.withPackages (ps: with ps; [requests pyyaml]);
    tunnelerScript = ./tunneler.py;
    tunnelerExecutable = pkgs.writeScriptBin "tunneler" ''
      #!${pkgs.bash}/bin/bash
      exec ${pythonEnv}/bin/python3 ${tunnelerScript} "${cfg.secrets}" "${cfg.ports}"
    '';
  in {
    enable = mkEnableOption "Tunneler service";

    secrets = mkOption {
      type = types.str;
      description = "Path to secrets file";
      example = "/etc/tunneler/secrets.json";
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

  config = mkIf cfg.enable {
    # Add the executable to system packages
    environment.systemPackages = [tunnelerExecutable];

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
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

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
        ReadWritePaths = ["/var/lib/tunneler"];
      };
    };

    # Create state directory
    systemd.tmpfiles.rules = [
      "d /var/lib/tunneler 0755 ${cfg.user} ${cfg.group} -"
    ];
  };
}
