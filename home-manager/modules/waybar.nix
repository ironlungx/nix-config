{ pkgs, ... }: {
  home.packages = with pkgs; [ waybar writers];

  home.file.".config/waybar/config" = pkgs.writers.writeJSON "waybar-config" {
    foo = "bar";
    baz = {
      hmmm = 2;
      woiru = [ 1 2 3 "a" 3 4];
    };
  };
}
