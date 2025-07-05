{
  programs.nixcord = {
    vesktop.enable = true;

    enable = true; # enable Nixcord. Also installs discord package
    config = {
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css"
      ];
      frameless = true; # set some Vencord options
      plugins = {
        fakeNitro.enable = true;
        fixSpotifyEmbeds.enable = true;
        spotifyShareCommands.enable = true;
        spotifyControls.enable = true;
        messageLogger = {
          enable = true;
          logEdits = true;
          logDeletes = true;
          ignoreSelf = true;
        };
        silentTyping = {
          enable = true;
          showIcon = true;
        };
      };
    };
  };
}
