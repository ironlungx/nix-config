{
  programs.ghostty = {
    enable = true;
    settings = {
      window-padding-x = 10;
      window-padding-y = 10;
      font-style = "Medium";
      font-thicken = true;
      font-feature = "+calt";
      confirm-close-surface = false;
      # cursor-style = "underline";
      # shell-integration-features = "no-cursor";
      # shell-integration = "fish";

      keybind = [
        "\"alt+v=text:nvim +\\\":norm G\\\" +\\\":set nowrap\\\"\      \""
        "chain=write_screen_file:paste"
        "chain=text:\\n"
      ];
    };
  };
}
