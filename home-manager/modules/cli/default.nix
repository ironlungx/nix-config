{
  imports = [
    ./nvim.nix
    ./tmux
  ];

  programs.btop = {
    enable = true;
    settings = {
      update_ms = 200;
      vim_keys = true;
    };
  };
}
