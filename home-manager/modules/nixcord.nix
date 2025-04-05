{
  programs.nixcord = {
    enable = true;  # enable Nixcord. Also installs discord package
    config = {
      themeLinks = [        # or use an online theme
        "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css"
      ];
      frameless = true; # set some Vencord options
      plugins = { };
    };
  };
}
