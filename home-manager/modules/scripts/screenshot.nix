{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myhm.screenshot;
in
{
  options.myhm.screenshot.enable = lib.mkEnableOption "screenshot";

  config.home.packages =
    with pkgs;
    lib.mkIf cfg.enable [
      wl-kbptr
      gawk
      coreutils
      grim
      wl-clipboard
      (pkgs.writeShellScriptBin "screenshot" ''
        set -euo pipefail
                                                                                                                                   
        P1=$(${pkgs.wl-kbptr}/bin/wl-kbptr -o modes=tile,bisect -p 2>/dev/null | ${pkgs.gawk}/bin/awk -F"+" '{ print $2 "," $3 }')
        P2=$(${pkgs.wl-kbptr}/bin/wl-kbptr -o modes=tile,bisect -p 2>/dev/null | ${pkgs.gawk}/bin/awk -F"+" '{ print $2 "," $3 }')
                                                                                                                                   
        x1=$(${pkgs.coreutils}/bin/echo "$P1" | ${pkgs.coreutils}/bin/cut -d',' -f1)
        y1=$(${pkgs.coreutils}/bin/echo "$P1" | ${pkgs.coreutils}/bin/cut -d',' -f2)
        x2=$(($(${pkgs.coreutils}/bin/echo "$P2" | ${pkgs.coreutils}/bin/cut -d',' -f1) + 2))
        y2=$(($(${pkgs.coreutils}/bin/echo "$P2" | ${pkgs.coreutils}/bin/cut -d',' -f2) + 2))
                                                                                                                                   
        w=$((x2 - x1))
        h=$((y2 - y1))
                                                                                                                                   
        ${pkgs.grim}/bin/grim -g "$x1,$y1 ''${w}x$h" - | ${wl-clipboard}/bin/wl-copy
      '')
    ];
}
