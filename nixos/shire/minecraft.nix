{
  pkgs,
  lib,
  ...
}: let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [requests pyyaml]);
in {
  imports = [];

  services.minecraft-servers = let
    myPlugins = pkgs.linkFarm "paper-plugins" [
      {
        name = "LuckPerms.jar";
        path = pkgs.fetchurl {
          url = "https://download.luckperms.net/1596/bukkit/loader/LuckPerms-Bukkit-5.5.11.jar";
          sha256 = "1qh2lblwrhvz4dadyv05nnv88qzikgvi3gff6vmxxiq36yxvh650";
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
          url = "https://github.com/ViaVersion/ViaVersion/releases/download/5.4.2/ViaVersion-5.4.2.jar";
          sha256 = "0lyzgqfiwx3m0w76kdg7b2llqgnrpzrakfpyi6l8di9xlbg9n07h";
        };
      }
      {
        name = "Voicechat.jar";
        path = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/bNX2205a/voicechat-bukkit-2.5.35.jar";
          sha256 = "1n07i4shdb3mn09ziw5g0p8az5wfbgl625k9i1jdz2d5vd2bmrmk";
        };
      }
      {
        name = "BoundlessForging.jar";
        path = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/jnw9A185/versions/BZ47T5h9/BoundlessForging-1.0-SNAPSHOT.jar";
          sha256 = "1jdihzydhvz70n8ibj6ny1pgys2hkj7r6dgfqnlhddm4d41nxq2x";
        };
      }
      {
        name = "EssentialsX.jar";
        path = pkgs.fetchurl {
          url = "https://github.com/EssentialsX/Essentials/releases/download/2.21.2/EssentialsX-2.21.2.jar";
          sha256 = "1inz1c6zs4w3ckjil51yyz7r87rwvdk3cvw869y58g1gy0k90x8b";
        };
      }
      {
        name = "EssentialsX-Chat.jar";
        path = pkgs.fetchurl {
          url = "https://github.com/EssentialsX/Essentials/releases/download/2.21.2/EssentialsXChat-2.21.2.jar";
          sha256 = "1nq903fdyfq6x41my8anfnm1xd846bfsygj8r7m54b8lb8r3kmqy";
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
            url = "https://fill-data.papermc.io/v1/objects/8de7c52c3b02403503d16fac58003f1efef7dd7a0256786843927fa92ee57f1e/paper-1.21.8-60.jar";
            sha256 = "07kzwlpajzwj8dl7hmh2gbfzgzhy7w05ib3gs41kah027cncbrwd";
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

      jvmOpts = "-Xms6G -Xmx6G -XX:+UseZGC -XX:+ZGenerational";
      package = customPaper;
      serverProperties = {
        seed = -4104965072236284201;
        server-port = 25565;
        difficulty = 3;
        gamemode = 1;
        motd = "A very cool minecraft server gang";
        sync-chunk-writes = false;
        simulation-distance = "8";
        white-list = true;
        enable-rcon = true;
        "rcon.password" = "hunter1";
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
        Pyro_Gaming_TF2 = "570682b0-8a20-4c47-9b84-123c7aa12c9c";
        Vorpld = "9423d24c-04cf-4ead-a14e-360c79f3d99e";
        Sub_Scope = "5ad3c563-057b-4629-bc22-04f42c31eb09";
        Spilled_Squid = "5fd52b26-e0ac-4394-809f-01ae980c4204";
      };
    };
  };

  environment.systemPackages = [
    pythonEnv
    pkgs.procps
  ];

  systemd.user.services.tunneler = {
    description = "Tunneler";
    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/python3 /home/user/tunneler.py /home/user/secrets.yaml 25565:25565";
      WorkingDirectory = "%h";
      Environment = [
        "HOME=%h"
        "PATH=${lib.makeBinPath [pkgs.procps pkgs.openssh pkgs.coreutils]}"
      ];
      Restart = "on-failure";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    wantedBy = ["default.target"];
  };
  systemd.user.services.tunneler.enable = false;
}
