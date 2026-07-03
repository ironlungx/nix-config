{ config, pkgs, ... }:

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

  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "lothlorien"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
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
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # Ensure the uinput group exists
  users.groups.uinput = { };

  # Add the Kanata service user to necessary groups
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  services.tlp.enable = true;

  services.kanata = {
    enable = true;

    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];

        extraDefCfg = "process-unmapped-keys yes";

        config = ''
          (defsrc
                 q w e r t y u i o p
            caps a s d f h j k l ;
                 lalt            ralt
          )

          (defvar
            tap-time 200
            hold-time 150
          )

          (defalias
            caps esc
            lalt (layer-while-held nav)
            ralt bspc

            a (tap-hold $tap-time $hold-time a lmet)
            s (tap-hold $tap-time $hold-time s lalt)
            d (tap-hold $tap-time $hold-time d lsft)
            f (tap-hold $tap-time $hold-time f lctl)

            j (tap-hold $tap-time $hold-time j rctl)
            k (tap-hold $tap-time $hold-time k rsft)
            l (tap-hold $tap-time $hold-time l ralt)
            ; (tap-hold $tap-time $hold-time ; rmet)

            nav-h left
            nav-j down
            nav-k up
            nav-l right
            q 1
            w 2
            e 3
            r 4
            t 5
            y 6
            u 7
            i 8
            o 9
            p 0
          )

          (deflayer base
                   q  w  e  r  t  y  u  i  o  p
            @caps @a @s @d @f  h @j @k @l @;

                     @lalt      @ralt
          )

          (deflayer nav
              @q @w @e @r @t @y @u @i @o @p
            _ @a @s @d @f   @nav-h @nav-j @nav-k @nav-l _
                   _            _
          )
        '';
      };
    };
  };

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true; # Shows battery charge of connected devices on supported
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.blueman.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults insults
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ironlung" = {
    isNormalUser = true;
    description = "ironlung";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "uinput"
      "adbusers"
      "dialout"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    git
    gcc
    python3
    unzip
    android-tools
    usbutils
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.udisks2.enable = true;
  services.tailscale.enable = true;
  networking.nftables.enable = true;

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.services.kbd-grab = {
    description = "Disable internal laptop keyboard";
    wantedBy = [ ];
    serviceConfig = {
      ExecStart = "${pkgs.evtest}/bin/evtest --grab /dev/input/event15";
      Restart = "no";
      Type = "simple";
    };
  };

  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

  stylix.targets = {
    gnome.enable = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/ironlung/nix-config/";
  };
  programs.fish.enable = true;
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
