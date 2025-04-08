{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    exa
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
      v = "nvim";
      t = "tmux";
    };
  };
}
