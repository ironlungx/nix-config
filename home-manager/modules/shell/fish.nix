{pkgs, ...}: {
  home.packages = with pkgs; [
    eza
  ];

  programs.bat.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
      v = "nvim";
      t = "tmux";

      ls = "eza -A -l -U --no-filesize --no-permissions --no-user --color=auto --group-directories-first";
    };
  };
}
