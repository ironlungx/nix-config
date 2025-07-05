{pkgs, ...}: {
  programs.foot = {
    enable = false;
    server.enable = true;
    settings.main = {
      pad = "10x10";
    };
  };
}
