{
  programs.eza = {
    enable = true;
    icons = "auto";
    colors = "always";
    extraOptions = [
      "-A"
      "-l"
      "-U"
      "--no-permissions"
      "--no-user"
      "--color=auto"
      "--group-directories-first"
    ];
    enableFishIntegration = true;
  };
}
