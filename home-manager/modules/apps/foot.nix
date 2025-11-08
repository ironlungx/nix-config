{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings.main = {
      pad = "10x10";
    };
  };
}
