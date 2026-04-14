{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.default ];

  # Zen and Stylix DO NOT mix well...
  stylix.targets.zen-browser.enable = false;
  # stylix.targets.zen-browser.profileNames = [ "ironlung" ];

  programs.zen-browser = {
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };

    profiles.ironlung = {
      userChrome = pkgs.runCommand "userChrome.css" { } ''
        cat ${
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/Frappe/Flamingo/userChrome.css";
            sha256 = "0vnr5l65ciij7ai1f5zimwpqs9ry7v79nfrrk70qxbvqagx2ak08";
          }
        } > $out
        echo ':root {
          --zen-main-browser-background: rgba(26,27,38,0.8) !important;
        }' >> $out
      '';

      userContent = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/Frappe/Flamingo/userContent.css";
        sha256 = "1v9q3qxn6cphn9sgnfm6z7dgkr76r6c0kfgp04rjihl4y5d496pg";
      };

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "zen.welcome-screen.seen" = true;
        "zen.view.show-newtab-button-border-top" = true;
        "zen.view.show-newtab-button-top" = false;
        "zen.theme.disable-lightweight" = false;
        "zen.window-sync.sync-only-pinned-tabs" = true; # stupid zen feature

        "zen.tabs.vertical.right-side" = true;
        "layout.css.prefers-color-scheme.content-override" = true;

        "extensions.autoDisableScopes" = 0;
        "extensions.webextensions.restrictedDomains" = "";
        "browser.startup.homepage" = "https://ironlungx.github.io/Bento/";
        "browser.search.defaultenginename" = "Duckduckgo";
        "browser.aboutConfig.showWarning" = false;
        "browser.startup.page" = 1;
        "browser.download.useDownloadDir" = false;
        "zen.tabs.select-recently-used-on-close" = false;

        "browser.uiCustomization.state" =
          ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["addon_darkreader_org-browser-action","jid1-kkzogwgsw3ao4q_jetpack-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"],"nav-bar":["back-button","forward-button","vertical-spacer","urlbar-container","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","unified-extensions-button","myallychou_gmail_com-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs"],"vertical-tabs":[],"PersonalToolbar":["import-button","personal-bookmarks"],"zen-sidebar-top-buttons":[],"zen-sidebar-foot-buttons":["downloads-button","zen-workspaces-button","zen-create-new-button"]},"seen":["_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","addon_darkreader_org-browser-action","jid1-kkzogwgsw3ao4q_jetpack-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","developer-button","screenshot-button","myallychou_gmail_com-browser-action"],"dirtyAreaCache":["unified-extensions-area","nav-bar","vertical-tabs","zen-sidebar-foot-buttons","PersonalToolbar","zen-sidebar-top-buttons","toolbar-menubar","TabsToolbar"],"currentVersion":23,"newElementCount":7}'';
      };
      search.force = true;
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "My NixOS" = {
          urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
          icon = "https://mynixos.com/favicon.ico";
          definedAliases = [ "@mynixos" ];
        };

        "NixOS Wiki" = {
          urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
          icon = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nw" ];
        };

        "Duckduckgo" = {
          urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
          icon = "https://duckduckgo.com/favicon.png";
          definedAliases = [ "@dg" ];
        };

        "Youtube" = {
          urls = [ { template = "https://youtube.com/search?q={searchTerms}"; } ];
          icon = "https://youtube.com/favicon.ico";
          definedAliases = [ "@yt" ];
        };

        "Perplexity" = {
          urls = [ { template = "https://www.perplexity.ai/?q={searchTerms}"; } ];
          icon = "https://www.perplexity.ai/favicon.png";
          definedAliases = [ "@p" ];
        };

        bing.metaData.hidden = true;
        ebay.metaData.hidden = true;
        google.metaData.alias = "@g";
      };

      search.default = "ddg";

      extensions = {
        force = true;
        packages = with pkgs.firefoxAddons; [
          ublock-origin
          sponsorblock
          darkreader
          vimium-ff
          youtube-shorts-block
          return-youtube-dislikes
          stylus
          istilldontcareaboutcookies
          youtube-unhook
        ];
      };
      settings."uBlock0@raymondhill.net".settings = {
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
        ];
      };
    };
  };
}
