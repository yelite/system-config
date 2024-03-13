{
  config,
  pkgs,
  lib,
  inputs,
  hostPlatform,
  ...
}: let
  addonsPkgs = inputs.firefox-addons.packages.${hostPlatform.system};
in {
  config = lib.mkIf (hostPlatform.isLinux && config.myHomeConfig.display.enable) {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      policies = {
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        Cookies = {RejectTracker = true;};
        FirefoxHome = {
          Search = false;
          Pocket = false;
          SponsoredTopSites = false;
          SponsoredPocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };

        DontCheckDefaultBrowser = true;

        ExtensionSettings = {
          "ebay@search.mozilla.org".installation_mode = "blocked";
          "amazondotcom@search.mozilla.org".installation_mode = "blocked";
          "bing@search.mozilla.org".installation_mode = "blocked";
          "wikipedia@search.mozilla.org".installation_mode = "blocked";
        };
      };
      profiles = {
        # https://github.com/nix-community/home-manager/issues/4703
        # has to prefix profile name with dev-edition
        "main.dev-edition-default" = {
          id = 0;
          name = "dev-edition-default";
          isDefault = true;

          userChrome = ''
            #TabsToolbar {
              visibility: collapse;
            }
            /* Hide sidebar header (except Bookmarks, History, Sync'd Tabs) */
            #sidebar-box:not([sidebarcommand="viewBookmarksSidebar"]):not([sidebarcommand="viewHistorySidebar"]):not([sidebarcommand="viewTabsSidebar"]) 
              > #sidebar-header {
                visibility: collapse;
              }

            #sidebar-splitter {
              width: 3px !important;
            }
          '';

          extensions = with addonsPkgs; [
            ublock-origin
            localcdn
            privacy-badger
            facebook-container
            multi-account-containers
            sponsorblock
            search-by-image
            sidebery
          ];
          settings = {
            # Based on https://github.com/xenoxanite/melted.flakes/blob/566ee0a3c4703aba471ee5cc44a2d584f7ba7020/home/programs/firefox/default.nix#L4-L4

            "browser.compactmode.show" = true;
            "browser.toolbars.bookmarks.visibility" = "never";
            # restore session
            "browser.startup.page" = 3;
            "browser.newtabpage.activity-stream.system.showSponsored" = false;

            # Enable userChrome.css
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # Autoplay
            "media.autoplay.block-event.enabled" = true;
            "media.autoplay.default" = 5;

            # Use system dns
            "network.trr.mode" = 5;

            # UI
            # "browser.tabs.inTitlebar" = 0;

            # Enable HTTPS only mode
            "dom.security.https_only_mode" = true;

            # Show punycode in URLs to prevent homograph attacks
            "network.IDN_show_punycode" = true;

            # Extensions
            "extensions.enabledScopes" = 5;
            "extensions.webextensions.restrictedDomains" = "";

            # Disable annoying firefox functionality
            "browser.aboutConfig.showWarning" = false; # about:config warning
            "browser.aboutwelcome.enabled" = false;
            "browser.formfill.enable" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.translations.automaticallyPopup" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.pocket.enabled" = false;
            "privacy.webrtc.legacyGlobalIndicator" = false; # Sharing indicator
            "signon.autofillForms" = false;
            "signon.rememberSignons" = false;

            # Disable telemetry
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.pioneer-new-studies-available" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.server" = "";
            "app.shield.optoutstudies.enabled" = false;
            "browser.discovery.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            permissions = {"default.desktop-notification" = false;};

            # From betterfox
            "content.notify.interval" = 100000;
            "gfx.canvas.accelerated.cache-items" = 4096;
            "gfx.canvas.accelerated.cache-size" = 512;
            "gfx.content.skia-font-cache-size" = 20;
            "browser.cache.jsbc_compression_level" = 3;
            "media.memory_cache_max_size" = 65536;
            "image.mem.decode_bytes_at_a_time" = 32768;
            "network.buffer.cache.size" = 262144;
            "network.buffer.cache.count" = 128;
            "network.http.pacing.requests.enabled" = false;
            "network.dns.disablePrefetch" = true;
            "layout.css.grid-template-masonry-value.enabled" = true;
            "dom.enable_web_task_scheduling" = true;
            "layout.css.has-selector.enabled" = true;
            "dom.security.sanitizer.enabled" = true;
          };
        };
      };
    };
  };
}
