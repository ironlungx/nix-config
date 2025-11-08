{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pyprland
  ];

  home.file.".config/hypr/pyprland.toml".source = pkgs.writers.writeTOML "pyprland-config" {
    pyprland.plugins = [ "scratchpads" ];

    scratchpads.term = {
      animation = "fromTop";
      command = "kitty";
      class = "kitty";
      lazy = true;
    };

    scratchpads.vesktop = {
      animation = "fromTop";
      command = "vesktop";
      match_by = "title";
      title = "Vesktop";
      lazy = true;
      size = "80% 80%";
      position = "10% 10%";
    };
    scratchpads.spotify = {
      animation = "fromTop";
      command = "spotify";
      class = "Spotify";
      lazy = true;
      size = "80% 80%";
      position = "10% 10%";
    };
  };
}
