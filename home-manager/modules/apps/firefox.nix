{
  pkgs,
  inputs,
  ...
}: {
  # home.packages = with pkgs; [
  #   inputs.zen-browser.packages."${system}".default
  # ];

  programs.firefox = {
    enable = true;
    # package = inputs.zen-browser.packages."${pkgs.system}".default;

    profiles.ironlung = {
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
          definedAliases = ["@np"];
        };

        "My NixOS" = {
          urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
          icon = "https://mynixos.com/favicon.ico";
          definedAliases = ["@mynixos"];
        };

        "NixOS Wiki" = {
          urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
          icon = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@nw"];
        };

        "Duckduckgo" = {
          urls = [{template = "https://duckduckgo.com/?q={searchTerms}";}];
          icon = "https://duckduckgo.com/favicon.png";
          definedAliases = ["@dg"];
        };

        "Youtube" = {
          urls = [{template = "https://youtube.com/search?q={searchTerms}";}];
          icon = "https://youtube.com/favicon.ico";
          definedAliases = ["@yt"];
        };

        "Perplexity" = {
          urls = [{template = "https://www.perplexity.ai/?q={searchTerms}";}];
          icon = "https://www.perplexity.ai/favicon.png";
          definedAliases = ["@p"];
        };

        bing.metaData.hidden = true;
        ebay.metaData.hidden = true;
        google.metaData.alias = "@g";
      };

      search.default = "ddg";

      search.force = true;

      bookmarks = {
        force = true;

        settings = [
          {
            name = "wikipedia";
            tags = ["wiki"];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
        ];
      };

      settings = {
        "extensions.autoDisableScopes" = 0;
        "browser.startup.homepage" = "https://ironlungx.github.io/Bento/";
        "browser.search.defaultenginename" = "Duckduckgo";

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "sidebar.verticalTabs" = true;

        # Disable fx accounts
        "identity.fxaccounts.enabled" = false;
        # Disable "save password" prompt
        "signon.rememberSignons" = false;
        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        # Layout

        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 20;
          newElementCount = 5;
          dirtyAreaCache = ["nav-bar" "PersonalToolbar" "toolbar-menubar" "TabsToolbar" "widget-overflow-fixed-list"];

          placements = {
            PersonalToolbar = ["personal-bookmarks"];
            TabsToolbar = ["customizableui-special-spring4" "tabbrowser-tabs" "new-tab-button" "alltabs-button"];
            nav-bar = ["back-button" "forward-button" "stop-reload-button" "vertical-spacer" "urlbar-container" "downloads-button" "ublock0_raymondhill_net-browser-action" "_testpilot-containers-browser-action" "reset-pbm-toolbar-button" "unified-extensions-button"];
            toolbar-menubar = ["menubar-items"];
            unified-extensions-area = [];
            widget-overflow-fixed-list = [];
          };
          seen = ["save-to-pocket-button" "developer-button" "ublock0_raymondhill_net-browser-action" "_testpilot-containers-browser-action"];
        };
      };

      userChrome = ''
        /* some css */
      '';

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        sponsorblock
        darkreader
        vimium
        youtube-shorts-block
        stylus
      ];
    };
  };
}
