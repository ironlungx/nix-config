{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "shire";
  # networking.wireless.enable = true; # skill issue?
  networking.networkmanager.enable = true;
  networking.bridges.br-988f5524e813.interfaces = [ "wlp5s0" ];

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
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = ["networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
    # packages = with pkgs; [];
  };

  virtualisation.docker.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/user/nix-config/";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    rsync
    git
  ];
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment? what comment hahahah?
}
