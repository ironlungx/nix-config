{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "opti-edgar";
  version = "1.0";
  src = ./OPTIEdgarBold-Extended.otf;
  phases = [ "installPhase" ];  # Skip unpack and other phases
  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    install -Dm644 $src $out/share/fonts/opentype/OPTIEdgarBold.otf
  '';
  meta = {
    description = "OPTIEdgarBold";
    platforms = pkgs.lib.platforms.all;
  };
}


