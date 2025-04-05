{pkgs, ...}: {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    nixd
    black
    stylua
    alejandra
    lua-language-server
    clang-tools
    ruff
    basedpyright
    lazygit
    gnumake
  ];
}
