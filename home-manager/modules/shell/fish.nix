{pkgs, ...}: {
  programs.bat.enable = true;
  programs.zoxide.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting ""
      fish_vi_key_bindings
    '';

    shellAliases = {
      cat = "bat";
      v = "nvim";
      t = "tmux";
      cd = "z";
    };
  };
}
