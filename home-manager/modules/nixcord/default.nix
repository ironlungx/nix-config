{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.myhm.nixcord;
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  options.myhm.nixcord.enable = lib.mkEnableOption "nixcord";
  config.programs.nixcord = lib.mkIf cfg.enable {
    vesktop.enable = true;
    discord.vencord.enable = true;

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
        anonymiseFileNames = {
          enable = true;
          anonymiseByDefault = true;
        };
        messageLogger = {
          enable = true;
          logEdits = true;
          logDeletes = true;
          ignoreSelf = true;
        };
        favoriteEmojiFirst.enable = true;
        fixCodeblockGap.enable = true;
        # silentTyping = {
        #   enable = true;
        #   showIcon = true;
        # };
      };
    };
  };
}
