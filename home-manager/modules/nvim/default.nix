{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myhm.nvim;
in
{
  options.myhm.nvim.enable = lib.mkEnableOption "nvim";

  config.home = lib.mkIf cfg.enable {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      neovim # not doing programs.nvim.enable cus home manager complains about init.lua

      zip
      unzip
      lazygit
      gnumake
      ripgrep

      # LSP servers
      nixd
      nixfmt
      statix
      stylua
      alejandra
      lua-language-server
      clang-tools
      fixjson
      tree-sitter
      imagemagick
      tinymist

      ruff
      # black

      (python3.withPackages (
        ps: with ps; [
          python-lsp-server
          python-lsp-jsonrpc
          pyls-isort
          pyls-flake8
          flake8
          isort
        ]
      ))
    ];
  };
}
