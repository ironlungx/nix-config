{pkgs, ...}: {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    zip
    unzip
    lazygit
    gnumake
    ripgrep

    # LSP servers
    nixd
    black
    stylua
    alejandra
    lua-language-server
    clang-tools
    ruff
    basedpyright
    fixjson
  ];
}
