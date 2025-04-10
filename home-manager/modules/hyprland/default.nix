{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nautilus
    nwg-look
  ];

  imports = [
    ./dunst.nix
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./pyprland.nix
  ];

  services.swayosd.enable = true;
}
