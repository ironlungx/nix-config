{ config, lib, ... }:
let
  cfg = config.myhm.fish;
in
{
  options.myhm.fish.enable = lib.mkEnableOption "fish";

  config.myhm.zoxide.enable = lib.mkIf cfg.enable true;

  config.programs = lib.mkIf cfg.enable {
    bat.enable = true;
    zoxide.enableFishIntegration = true;
    fish = {
      enable = true;

      shellInit = ''
        set fish_greeting ""
        fish_vi_key_bindings
        export PAGER=bat
        export MANPAGER=bat
      '';

      shellAliases = {
        cat = "bat";
        v = "nvim";
        t = "tmux";
        cd = "z";
        nix-shell = "nix-shell --command 'fish' ";
      };
    };
  };
}
