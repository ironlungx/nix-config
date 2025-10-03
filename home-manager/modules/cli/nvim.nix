{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim # not doing programs.nvim.enable cus home manager complains about init.lua

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
    tree-sitter
    imagemagick

    ruff
    # black

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
