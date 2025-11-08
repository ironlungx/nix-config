# KID A Font :)
# Unfortunately this font has got very few glyphs so I can't use it in many places

{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "bd-plakatbau";
  version = "1.0";
  src = ./bdplakatt.ttf;
  phases = [ "installPhase" ]; # Skip unpack and other phases
  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    install -Dm644 $src $out/share/fonts/opentype/BDPlakatbau.otf
  '';
  meta = {
    description = "BD Plakatbau font";
    platforms = pkgs.lib.platforms.all;
  };
}
