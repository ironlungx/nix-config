{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = false;
      confirm-close-surface = false;
      window-padding-x = 10;
      window-padding-y = 10;
      font-thicken = true;
    };
  };
}
