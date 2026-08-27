{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    theme = pkgs.catppuccin-grub;
  };

  boot.tmp.useTmpfs = true;

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "valinor";

  # Enable networking
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;
  networking.nftables.enable = true;

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gtk" ];
    config.niri = {
      default = [
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.udisks2.enable = true;
  services.ratbagd.enable = true;

  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

  stylix.targets = {
    gnome.enable = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults insults
  '';

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    extraConfig.pipewire."99-null-sink" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "music_share";
            "node.description" = "Music Share";
            "media.class" = "Audio/Sink";
          };
        }
      ];
    };
  };

  users.users.ironlung = {
    isNormalUser = true;
    description = "ironlung";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
      "kvm"
      "libvirtd"
      "adbusers"
      "uucp"
      "dialout"
    ];
    packages = [ ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.udevil.enable = true;

  programs.virt-manager.enable = true;

  # steam and stuff
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };

  users.groups.libvirtd.members = [ "ironlung" ];
  virtualisation.libvirtd.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;
  virtualisation.docker.enableOnBoot = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/ironlung/nix-config/";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libnotify
    expat
    alsa-lib
    libusb1
  ];

  nixpkgs.config.allowUnfree = true;

  hardware.opentabletdriver.enable = true;
  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
    gcc
    python3
    unzip
    android-tools

    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol

    wireguard-tools
    # winboat

    carla
    dragonfly-reverb
    surge-xt
    qdelay
    vital
    guitarix-vst
    guitarix

    yabridge
    yabridgectl
    mangohud
    bottles

    wineWow64Packages.stable
    winetricks
    wineWow64Packages.waylandFull
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "ironlung"
  ];

  services.openssh.enable = true;

  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
    pkgs.esptool
  ];

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
  };

  networking.firewall.trustedInterfaces = [
    "virbr0"
    "tailscale0"
  ];
  networking.firewall.allowedTCPPorts = [
    443
    59100
  ];
  networking.firewall.allowedUDPPorts = [
    59100
    config.services.tailscale.port
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  system.stateVersion = "24.11";
}
