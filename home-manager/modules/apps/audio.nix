{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qmidiarp
    qpwgraph
    vital
  ];
}
