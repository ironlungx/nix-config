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
    stylua
    alejandra
    lua-language-server
    clang-tools
    fixjson

    ruff
    black

    (python3.withPackages (ps:
      with ps; [
        python-lsp-server
        python-lsp-jsonrpc
        pyls-isort
        pyls-flake8
        flake8
        isort
      ]))
  ];
}
