{pkgs, ...}: {
  programs.bat.enable = true;

  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting ""
    '';

    shellAliases = {
      cat = "bat";
      v = "nvim";
      t = "tmux";
    };
  };
}
