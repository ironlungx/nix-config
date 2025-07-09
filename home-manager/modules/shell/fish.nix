{pkgs, ...}: {
  programs.bat.enable = true;
  programs.zoxide.enableFishIntegration = true;

  programs.fish = {
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
}
