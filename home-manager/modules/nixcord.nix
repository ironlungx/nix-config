{
  programs.nixcord = {
    enable = true; # enable Nixcord. Also installs discord package
    config = {
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css"
      ];
      frameless = true; # set some Vencord options
      plugins = {
        fakeNitro.enable = true;
        fixSpotifyEmbeds.enable = true;
      };
    };
  };
}
